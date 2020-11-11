
# Email Bot in Salesforce

This solution offers an email-to-flow functionality. The Apex will accept an email, convert the email to an Apex Object, retrieve intent, sentiment and NER from Einstein Platform Services, and start a flow that includes the email information. This allows admins to manage logic around inbound emails. For this specific example, an admin wanted to send an auto-reply email with order information when a customer asks about order status.

## Flow Variables

 - **`Create_Case`** - Boolean - defaults to true. If you do not want a case created from the email, set this to false. There is some apex written (`EmailToCaseUtility`) to save binary attachments and email information to the case that is created.
 - **`New_Case`** - Case - fields filled out in this Case record will be used to create a case in  `EmailToCaseUtility`
 - **`Received_Email`** - EmailBotObject - holds all of the email information (from address, to addresses, text body, subject... etc) as well as results from Einstein Intent and Sentiment.

 ## Custom Metadata Type

 When you create a new instance of the custom metadata, the code is looking for one called "Email Bot".

- **`Case Origin`** - When case is created, this value will populate to the Case Origin field.
- **`Case Status`** - When case is created, this value will be populated to the Case Status field.
- **`Intent Model ID`** - ID for Einstein Intent model.
- **`NER Model ID`** - Entity Recognition isn't included in this version, but the infrastructure is there. This defaults to `NER7`.
- **`Sentiment Model ID`** - ID for Einstein Sentiment model. This defaults to the `CommunitySentiment` model.
Support Queue ID

## Installation Instructions

**Install has dependency on these Managed Packages**

 1. [Unofficial SF - Flow Base Components](https://unofficialsf.com/introducing-flowbasecomponents/)    
 2. [Unofficial SF - Send Better Email Flow Action](https://unofficialsf.com/send-better-email-flow-action/)
 3. [Einstein Playground App](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000Ed1V8UAJ)

**Installation**

 1. Install the [Unofficial SF - Flow Base Components](https://unofficialsf.com/introducing-flowbasecomponents/) and [Unofficial SF - Send Better Email Flow Action](https://unofficialsf.com/send-better-email-flow-action/) unmanaged packages. This will give the bot the ability to send emails using email templates from a Flow. While installing both of these unmanaged packages, there's an advanced settings tab in the package installation prompt for each one, make sure you select "Compile Only Apex in the Package".
 2. Install [Einstein Playground App](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000Ed1V8UAJ)
 3. Install code and configuration from this GitHub repo [using DX](https://medium.com/@abarnes26/how-to-connect-vscode-to-a-salesforce-org-the-easy-way-11baa8dc351b) or this install button <a href="https://githubsfdeploy.herokuapp.com?owner=iiretepii&repo=Einstein-Email-Bot"><img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png"></a>
 4. Intent: build an intent model or use one that already exists in your org. Add Model ID to Custom Metadata, add the model ID to the `Email Bot Setting` custom metadata.
 5. Sentiment: build a sentiment model, use one that already exists in your org, or use the `CommunitySentiment` model. Add the model ID to the `Email Bot Setting` custom metadata.
 6. Entity Recognition: for testing purposes I used `NER7`.
 7. For testing, create a custom email service that uses the inbound email handler.
 8. Ship it ⚓️

 ## License
 [BSD-3-Clause License](https://github.com/iiretepii/Einstein-Email-Bot/blob/master/LICENSE)
