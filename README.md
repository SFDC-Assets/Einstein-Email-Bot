
# Email Bot in Salesforce

This is an example of how to make an Email Bot in Salesforce.

## Installation Instructions

**Pre-requisites**

 1. [Unofficial SF - Flow Base Components](https://unofficialsf.com/introducing-flowbasecomponents/)    
 2. [Unofficial SF - Send Better Email Flow Action](https://unofficialsf.com/send-better-email-flow-action/)
 3. [Einstein Playground App](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000Ed1V8UAJ)

**Installation**

 1. Install the [Unofficial SF - Flow Base Components](https://unofficialsf.com/introducing-flowbasecomponents/) and [Unofficial SF - Send Better Email Flow Action](https://unofficialsf.com/send-better-email-flow-action/) unmanaged packages. This will give the bot the ability to send emails using email templates from a Flow. While installing both of these unmanaged packages, there's an advanced settings tab in the package installation prompt for each one, make sure you select "Compile Only Apex in the Package".
 2. Install [Einstein Playground App](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000Ed1V8UAJ)
 3. Install code and configuration from this GitHub repo [using DX](https://medium.com/@abarnes26/how-to-connect-vscode-to-a-salesforce-org-the-easy-way-11baa8dc351b) or any other means.
 4. Intent: build an intent model or use one that already exists in your org. Add Model ID to Custom Metadata, add the model ID to the `Email Bot Setting` custom metadata.
 5. Sentiment: build a sentiment model, use one that already exists in your org, or use the `CommunitySentiment` model. Add the model ID to the `Email Bot Setting` custom metadata.
 6. Entity Recognition: for testing purposes I used `NER7`.
 7. For testing, create a custom email service that uses the inbound email handler.
 8. Ship it ⚓️

## Flow Variables

 - **`Create_Case`** - Boolean - defaults to true. If you do not want a case created from the email, set this to false.
 - **`New_Case`** - Case - fields filled out in this Case record will be used to create a case in  `EmailToCaseUtility`
 - **`Received_Email`** - EmailBotObject - holds all of the email information and Einstein results.

 ## License
 [MIT](https://github.com/iiretepii/Einstein-Email-Bot/blob/master/LICENSE)
