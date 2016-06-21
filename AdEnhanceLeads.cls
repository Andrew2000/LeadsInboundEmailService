global class AdEnhanceLeads implements Messaging.InboundEmailHandler {

global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                  Messaging.InboundEnvelope env){

// Create an inboundEmailResult object for returning 
// the result of the Force.com Email Service
Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

String myPlainText = '';
String phoneNum = '';
String emailAddress = 'tbd@tbd.com';
String companyName = 'TBD';
String firstName = '';
String website = '';
String lastName = 'TBD';
AdEnhanceCampaignId__c AdEnhance = AdEnhanceCampaignId__c.getInstance('AdEnhance');
AdEnhanceCampaignId__c CampaignName = AdEnhanceCampaignId__c.getInstance('CampaignName');
// Add the email plain text into the local variable

try
{
      myPlainText = email.htmlBody.substring(0, email.htmlBody.indexOf('<stop>'));
}
catch (System.StringException e)
{
     myPlainText = email.htmlBody;
     System.debug('No <stop> in email: ' + e);
}

Pattern htmlPattern = Pattern.compile('(?m)(<[!b-z]*>|</[!b-z]*>|<br/>|<head>|</head>|<!DOCTYPE html>|<meta content=\'text/html; charset=UTF-8\' http-equiv=\'Content-Type\' />)'); 
myPlainText= htmlPattern.matcher(myPlainText).replaceAll('');                                                      
                                                      
// new Lead object to be created

Lead[] newLead = new Lead[0];

//Match Phone
Pattern p = Pattern.compile('(?m)\\+?1?\\s*\\(?-*\\.*(\\d{3})\\)?\\.*-*\\s*(\\d{3})\\.*-*\\s*(\\d{4})$');
Matcher m = p.matcher(myPlainText);
if (m.find()) 
{
   phoneNum =(m.group());
}          
//Match Email
Pattern p2 = Pattern.compile('(?m)\\b[\\w.%-]+@[-.\\w]+\\.[A-Za-z]{2,4}\\b');
Matcher m2 = p2.matcher(myPlainText);
if (m2.find()) 
{
   emailAddress =(m2.group()); 
}                                                          
//Match Company
Pattern p3 = Pattern.compile('(?m)(?<=Business Name: )(.+)');
Matcher m3 = p3.matcher(myPlainText);
if (m3.find()) 
{
   companyName =(m3.group()); 
}         
//Match FirstName
Pattern p4 = Pattern.compile('(?m)(?<=Contact Name: )(.+)(?= )');
Matcher m4 = p4.matcher(myPlainText);
if (m4.find()) 
{
   firstName =(m4.group()); 
}                                                      
//Match Company
Pattern p5 = Pattern.compile('(?m)(?<=Contact Name: ).+? (.+)');
Matcher m5 = p5.matcher(myPlainText);
if (m5.find()) 
{
   lastName =(m5.group(1)); 
}
//Match Website
Pattern p6 = Pattern.compile('(?m)(?<=Website: )(.+)');
Matcher m6 = p6.matcher(myPlainText);
if (m6.find()) 
{
   website =(m6.group()); 
}   
    // Create Lead if there are errors an exception will be thrown and the catch statement will be called
try {
// Add a new Lead
 newLead.add(new Lead(Description = myPlainText,
     Phone = phoneNum,
     Email = emailAddress,
     FirstName = firstName,                 
     LastName = lastName,
     Status = 'Open',
     Company = companyName,
     Website = website,
     //Email = 'tbd@tbd.com',
     LeadSource = 'AdEnhance Claimed Business',
     Campaign_Name__c = CampaignName.CampaignId__c,
     recordTypeId = '012d00000007UYO'
     //,
     //OwnerId = '005d0000004OScW'
                     ));
     insert newLead;
     
     CampaignMember cml = new CampaignMember();
     cml.campaignid= AdEnhance.CampaignId__c;
     cml.leadid = newLead[0].id;
     cml.status = 'Sent';
// Insert the new Camapgin Member and it will be created and appended to the lead record
     insert cml;

System.debug('New Lead Object: ' + newLead );
}catch(Exception e) {
   // If there is an exception it will be thrown here
   // The exception will be written to the Apex Debug logs

    System.debug('Exception type caught: ' + e.getTypeName());   
    System.debug('Message: ' + e.getMessage());   
    System.debug('Cause: ' + e.getCause());    // returns null
    System.debug('Line number: ' + e.getLineNumber());   
    System.debug('Stack trace: ' + e.getStackTraceString());
    sendErrorMail(e.getMessage(),myPlainText);
}

// Set the result to true, no need to send an email back to the user
// with an error message

  result.success = true;

  // Return the result for the Force.com Email Service
  return result;
}
    public static void sendErrorMail(String errorMessage, String myPlainText){              
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     String[] toAddresses = new String[] {'andrewl@propelmarketing.com','adenhanceleads@gmail.com'};
     mail.setToAddresses(toAddresses);
     mail.setReplyTo('andrewl@propelmarketing.com');  
     mail.setSenderDisplayName('Apex error message');
     mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
     mail.setPlainTextBody(errorMessage+'\n'+'\n'+'Email Body:'+'\n'+myPlainText);
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}