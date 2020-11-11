/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class EmailBotObject {

    @AuraEnabled
    public String subject;
    @AuraEnabled
    public String textBody;
    @AuraEnabled
    public String htmlBody;
    @AuraEnabled
    public String fromAddress;
    @AuraEnabled
    public List<String> toAddresses;
    @AuraEnabled
    public String intent;
    @AuraEnabled
    public Double intentConfidence;
    @AuraEnabled
    public String sentiment;
    @AuraEnabled
    public Double sentimentConfidence;

    public String emailBodyForPrediction;

    public EmailBotObject() {}

    public EmailBotObject(Messaging.InboundEmail email) {
        // string manipulation because I wanted to use already built sentiment and intent models
        String splitCharacter = '--';
        // map email fields
        this.subject = email.subject;
        this.textBody = email.plainTextBody.split(splitCharacter)[0];
        this.htmlBody = email.htmlBody.split(splitCharacter)[0];
        this.emailBodyForPrediction = String.isBlank(textBody) ? htmlBody : textBody;
        System.debug('email body for prediction: ' + emailBodyForPrediction);
        this.fromAddress = email.fromAddress;
        this.toAddresses = email.toAddresses;
        // run the Einstein stuff
        this.getIntent().getNER().getSentiment();
    }

    public EmailBotObject getIntent() {

        EinsteinPlay.Einstein_PredictionResult prediction = EinsteinServices.getIntent(
            emailBodyForPrediction,
            EmailToCaseUtility.settings().Intent_Model_ID__c
        );

        if(prediction != null && !prediction.probabilities.isEmpty()) {
            this.intent = prediction.probabilities[0].label;
            this.intentConfidence = prediction.probabilities[0].probability;
        }

        return this;
    }

    public EmailBotObject getNER() {

        EinsteinPlay.Einstein_PredictionResult prediction = EinsteinServices.getNER(
            emailBodyForPrediction, 
            EmailToCaseUtility.settings().NER_Model_ID__c
        );

        if(prediction != null && !prediction.probabilities.isEmpty()) {
            // Find use cases for the future
        }

        return this;
    }

    public EmailBotObject getSentiment() {

        EinsteinPlay.Einstein_PredictionResult prediction = EinsteinServices.getSentiment(
            emailBodyForPrediction,
            EmailToCaseUtility.settings().Sentiment_Model_ID__c
        );

        if(prediction != null && !prediction.probabilities.isEmpty()) {
            sentiment =  prediction.probabilities[0].label;
            sentimentConfidence = prediction.probabilities[0].probability;
        }

        return this;
    }

    public static EmailBotObject parse(String json) {
        return (EmailBotObject) System.JSON.deserialize(json, EmailBotObject.class);
    }
}