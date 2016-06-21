@isTest(seeAllData=true)
Private Class InBoundEmailTest{
     //Test Method for main class
     static testMethod void TestinBoundEmail(){
       Test.startTest();
      // create a new email and envelope object
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
       // setup the data for the email
      email.subject = 'Create Contact';
      email.fromAddress = 'someaddress@email.com';
      email.plainTextBody = 'email body\n2225256325\nTitle\ntest@test.com\n111-111-1111';
     
      // add an Binary attachment

      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfileone.txt';
      attachment.mimeTypeSubType = 'text/plain';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

 
      // add an Text atatchment
 
      Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
      attachmenttext.body = 'my attachment text';
      attachmenttext.fileName = 'textfiletwo3.txt';
      attachmenttext.mimeTypeSubType = 'texttwo/plain';
      email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
     
     
      // call the email service class and test it with the data in the testMethod
          try{
              AdEnhanceLeads  testInbound=new AdEnhanceLeads ();
              testInbound.handleInboundEmail(email, env);
          }catch(Exception e) {
              System.debug('Exception type caught: ' + e.getTypeName());   
              System.debug('Message: ' + e.getMessage());   
              System.debug('Cause: ' + e.getCause());    // returns null
              System.debug('Line number: ' + e.getLineNumber());   
              System.debug('Stack trace: ' + e.getStackTraceString());   
}

       

   }
}