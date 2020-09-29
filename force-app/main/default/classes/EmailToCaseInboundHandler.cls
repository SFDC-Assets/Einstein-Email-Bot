// https://sforcehacks.blogspot.com/2012/01/email-to-case-custom-email-handler.html?m=1

global class EmailToCaseInboundHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(
            Messaging.InboundEmail email,
            Messaging.InboundEnvelope envelope
    ) {
        // create apex object and grab intent
        EmailObject eo = new EmailObject(email);

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

        if((Boolean)myFlow.getVariableValue('Found_Contact')) {
            System.debug('FLOW: Found Contact');
        } else {
            System.debug('Did not find Contact');
        }

        if((Boolean)myFlow.getVariableValue('Found_Shipment')) {
            System.debug('FLOW: Found Shipment');
        } else {
            System.debug('Did not find Shipment');
        }

        if((Boolean)myFlow.getVariableValue('Email_Send_Success')) {
            System.debug('FLOW: Email Send Success');
        } else {
            System.debug('Email send was not a success');
        }

        // if Create_Case == true, there was no auto-reply and the case gets created
        if((Boolean)myFlow.getVariableValue('Create_Case')) {
            System.debug('Had to create a case');
            EmailToCaseUtility.createCase(email);
        } else {
            System.debug('Did not create a case');
        }

        // boiler plate
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        result.success = true;
        return result;
    }
}