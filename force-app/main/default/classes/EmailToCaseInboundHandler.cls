global class EmailToCaseInboundHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(
            Messaging.InboundEmail email,
            Messaging.InboundEnvelope envelope
    ) {
        // returned at the end
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        // create apex defined type
        EmailBotObject eo = new EmailBotObject(email);

        // assign email object to flow variable and start flow
        Map<String, Object> myMap = new Map<String, Object>();
        myMap.put('Received_Email', (Object)eo);
        Flow.Interview.Email_Bot myFlow = new Flow.Interview.Email_Bot(myMap);
        myFlow.start();

        // if Create_Case == true, there was no auto-reply and the case gets created
        if((Boolean)myFlow.getVariableValue('Create_Case')) {
            System.debug('Had to create a case');
            Case newCase = (Case)myFlow.getVariableValue('New_Case');
            EmailToCaseUtility.createCase(email, newCase);
        } else {
            System.debug('Did not create a case');
        }
        
        result.success = true;
        return result;
    }
}


