// https://sforcehacks.blogspot.com/2012/01/email-to-case-custom-email-handler.html?m=1

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