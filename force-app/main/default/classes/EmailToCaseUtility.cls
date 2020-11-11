/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class EmailToCaseUtility {

    public static Boolean createCase(Messaging.inboundEmail email) {
        return createCase(email, null);
    }

    public static Boolean createCase(Messaging.inboundEmail email, Case newCase) {

        Boolean success = true;

        try {
            if(newCase == null) {
                newCase = new Case(
                    Subject = email.subject,
                    Description =  email.plainTextBody,
                    SuppliedEmail = email.fromAddress,
                    SuppliedName = email.fromName
                );
            }

            if(String.isBlank(newCase.Subject)) newCase.Subject = email.subject;
            if(String.isBlank(newCase.Description)) newCase.Description = email.plainTextBody;
            if(String.isBlank(newCase.SuppliedEmail)) newCase.SuppliedEmail = email.fromAddress;
            if(String.isBlank(newCase.SuppliedName)) newCase.SuppliedName = email.fromName;
            if(String.isBlank(newCase.Origin)) newCase.Origin = settings().Case_Origin__c;
            if(String.isBlank(newCase.Status)) newCase.Origin = settings().Case_Status__c;
            if(String.isNotBlank(settings().Support_Queue_ID__c)) newCase.OwnerId = settings().Support_Queue_ID__c;

            Contact con = getContact(email.fromAddress);

            if(con != null) newCase.ContactId = con.Id;

            Database.SaveResult srCase = Database.insert(newCase, true);

            if(!srCase.isSuccess()) {
                success = false;
            } else {
                System.debug('Successfully inserted case id: ' + srCase.getId());
                EmailMessage emailMsg = new EmailMessage();
                emailMsg.HtmlBody =  email.htmlBody;
                emailMsg.TextBody = email.plainTextBody;
                emailMsg.FromAddress = email.fromAddress;                
                emailMsg.FromName = email.fromName;
                emailMsg.Subject = email.subject;
                emailMsg.Incoming = true;
                emailMsg.ParentId = srCase.getId();

                Database.SaveResult srEmail = Database.insert(emailMsg, true);

                if(srEmail.isSuccess()) {
                    if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                        for (Messaging.InboundEmail.binaryAttachment att :email.binaryAttachments) {
                            // TODO: bulkify
                            ContentVersion cv = new ContentVersion();
                            cv.VersionData = att.body;
                            cv.Title = att.fileName;
                            cv.PathOnClient = att.fileName;

                            cv = [
                                SELECT  ContentDocumentId 
                                FROM    ContentVersion 
                                WHERE   Id =:cv.Id 
                                LIMIT   1
                            ];
                
                            ContentDocumentLink cdl = new ContentDocumentLink();
                            cdl.LinkedEntityId = srCase.getId();
                            cdl.ContentDocumentId = cv.ContentDocumentId;
                            cdl.ShareType = 'V';
                            insert cdl;
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug(
                'Something went wrong: ' 
                + e.getCause() 
                + '\n' 
                + e.getStackTraceString()
            );
            success = false;
        }
        return success;
    }

    private static Email_Bot_Setting__mdt EmailBotSettings;

    public static Email_Bot_Setting__mdt settings() {
        if(EmailBotSettings == null) {
            EmailBotSettings = [
                SELECT  MasterLabel, Intent_Model_ID__c, NER_Model_ID__c, 
                        Sentiment_Model_ID__c, Support_Queue_ID__c,
                        Case_Status__c, Case_Origin__c
                FROM    Email_Bot_Setting__mdt 
                WHERE   MasterLabel = 'Email Bot'
            ];
        }
        return EmailBotSettings;
    }

    public static Contact getContact(String emailAddress) {
        Contact con;
        try {
            con = [
                SELECT  Id, Name, Email
                FROM    Contact
                WHERE   Email =: emailAddress
                LIMIT   1
            ];
        } catch (Exception e) {
            System.debug('EmailToCaseUtility - Contact was not found');
        }
        return con;
    }
}