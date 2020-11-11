/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
global class EmailToCaseInboundHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(
            Messaging.InboundEmail email,
            Messaging.InboundEnvelope envelope
    ) {
        // create apex object and grab intent
        EmailBotObject eo = new EmailBotObject(email);

        // assign email object to flow variable and start flow
        Map<String, Object> myMap = new Map<String, Object>();
        myMap.put('Received_Email', (Object)eo);
        Flow.Interview.Email_Bot myFlow = new Flow.Interview.Email_Bot(myMap);
        System.debug('Flow has STARTED');
        try {
            myFlow.start();    
        } catch (Exception e) {
            System.debug(
                'Error witht he flow: ' 
                + e.getCause() 
                + '\n' 
                + e.getStackTraceString()
            );
        }
        System.debug('Flow has COMPLETED');
        // if Create_Case == true, there was no auto-reply and the case gets created
        if((Boolean)myFlow.getVariableValue('Create_Case')) {
            System.debug('Had to create a case');
            Case newCase = (Case)myFlow.getVariableValue('New_Case');
            EmailToCaseUtility.createCase(email, newCase);
        } else {
            System.debug('Did not create a case');
        }

        // boiler plate
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        result.success = true;
        return result;
    }
}