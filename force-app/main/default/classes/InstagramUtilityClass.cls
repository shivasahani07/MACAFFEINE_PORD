/* Test Class name : InstagramUtilityTest
* created Date     : 29/07/2023
* Created By       : shubham kumar
* Last Modfied By  : shubham kumar
* Descritpion      : This class contains all the api's related to instagram.
*/

public class InstagramUtilityClass {
    
    private static Instagram_Api_Details__c fap = Instagram_Api_Details__c.getInstance();
    
    private static final String CLIENT_ID               = fap.CLIENT_ID__c;
    private static String CLIENT_SECRET                 = fap.CLIENT_SECRET__c;
    private static String REDIRECT_URI                  = fap.REDIRECT_URI__c;
    private static String accessToken                   = fap.accessToken__c;
    private static String basicUrl                      = fap.basicUrl__c;
    private static String businessUserId                = fap.businessUserId__c;
    private static Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    
    // This method will get the business user id
    public static string getInstaBusinessUserId(){
        
        String endpointUrl = basicUrl+'me/accounts?fields=instagram_business_account';
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+accessToken};
            HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(endpointUrl, queryParams, headers);
        if (response.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            instaJSONHandler jsonResponse = instaJSONHandler.parse(response.getBody());
            businessUserId = jsonResponse.data[0].instagram_business_account.id;
            return businessUserId;
        } else {
            String errorMessage = 'Error: ' + response.getStatusCode() + ' - ' + response.getStatus();
            return null;
        }
    }
    
    //Pass this method the Comment id and the media id will be fetched.
    public static void getMediaIdFromCommentId(String commentId){
        List<Case> caseList = new List<Case>();
        String endpointUrl = basicUrl+commentId+'?fields=replies{text,username,timestamp,user},text,user,timestamp,username,media';
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+accessToken};
            HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(endpointUrl, queryParams, headers);
        system.debug('Response==>'+response.getBody());
        if (response.getStatusCode() == 200) {
            InstaCommentWrapper jsonResponse = InstaCommentWrapper.parse(response.getBody());
            String mediaId = '';
            if(test.isRunningTest()){
                mediaId = '17977476455235820';
            }else{
                mediaId = jsonResponse.media.id;
            }
            getMediaDetailsFromMediaId(mediaId);    
        }else{
            String errorMessage = 'Error: ' + response.getStatusCode() + ' - ' + response.getStatus();
            System.debug(errorMessage);
        }
    }
    
    //Pass this method the media id and all the details related to post will be fetched.
    public static string getMediaDetailsFromMediaId(String mediaId){
        
        List<Post_Comments__c> postCommentList = new List<Post_Comments__c>();
        List<Post_Comments__c> postCommentListToBeUpdated = new List<Post_Comments__c>();
        map<String,List<Post_Comments__c>> commentsOnPostByPostId = new map<String,List<Post_Comments__c>>();
        map<String,String> caseIdByPostId = new map<String,String>();
        map<String,String> postCommentIdByPostId = new map<String,String>();
        List<Case> existingCaseList = [Select id,subject,Description,Caption__c,Post_Id__c,(Select Comment__c,Comment_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__r ) from case where Post_Id__c = :mediaId];
        
        try{
            List<String> casePostIds = new List<String>();
            for(Case caseRec : existingCaseList){
                commentsOnPostByPostId.put(caseRec.Post_Id__c,caseRec.Post_Comments__r);
                caseIdByPostId.put(caseRec.Post_Id__c,caseRec.Id);
                for(Post_Comments__c pocRec : caseRec.Post_Comments__r){
                    postCommentIdByPostId.put(pocRec.Comment_Id__c,pocRec.Id);
                }
            }
            
            system.debug('commentsOnPostByPostId--->'+commentsOnPostByPostId);
            //system.debug('response-->'+response);
            
            String endpointUrl = basicUrl+mediaId+'?fields=media_url,comments_count,permalink,caption,media_type,shortcode,timestamp,username,comments{id,like_count,user,media,timestamp,username,replies{text,username,timestamp},text}';
            Map<String, String> queryParams = new Map<String, String>();
            Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+accessToken};
            String jsonResponse = '';    
            InstagramMediaResponseWrapper postInfo = new InstagramMediaResponseWrapper();   
            if(test.isRunningTest()){
                jsonResponse = '{"id": "17841405793087218", "media_url": "https://www.example.com/image.jpg", "comments": { "data": [{"id": "17851087209098192", "text": "Awesome!", "username": "user1", "timestamp": "2023-07-29T12:40:00+0000"}] } }';
                postInfo = (InstagramMediaResponseWrapper) JSON.deserialize(jsonResponse, InstagramMediaResponseWrapper.class);
            }else{
                HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(endpointUrl, queryParams, headers);
                postInfo = (InstagramMediaResponseWrapper) JSON.deserialize(response.getBody(), InstagramMediaResponseWrapper.class);
            }
                
           
            if(commentsOnPostByPostId.keyset().contains(postInfo.Id)){
                if(postInfo.comments != null){
                    for(InstagramMediaResponseWrapper.cls_data postInfoRec : postInfo.comments.data){
                        if(commentsOnPostByPostId.containsKey(postInfo.Id)){
                            List<String> postCommentIds = new List<String>();
                            for(Post_Comments__c poCom :  commentsOnPostByPostId.get(postInfo.Id)){
                                postCommentIds.add(poCom.Comment_Id__c);
                            }
                            if(!postCommentIds.contains(postInfoRec.id)){
                                Post_Comments__c commentRec = new Post_Comments__c();
                                commentRec.Case__c = caseIdByPostId.get(postInfo.Id);
                                commentRec.Comment__c = postInfoRec.text;
                                commentRec.Comment_Id__c = postInfoRec.id;
                                commentRec.Commented_By__c = postInfoRec.username;
                                commentRec.Post_comment_Time__c = postInfoRec.timestamp;
                                commentRec.Post_Url__c	 = postInfo.permalink;
                                commentRec.Replied_Comments__c = string.valueOf(postInfoRec.replies);
                                system.debug('replies are'+postInfoRec.replies);
                                postCommentList.add(commentRec);
                            }else{
                                system.debug('replies are'+postInfoRec.replies);
                                Post_Comments__c commentRec = new Post_Comments__c();
                                commentRec.Id = postCommentIdByPostId.get(postInfoRec.id);
                                commentRec.Replied_Comments__c = string.valueOf(postInfoRec.replies);
                                postCommentListToBeUpdated.add(commentRec);
                            }
                        }
                    }
                }else{
                    system.debug('postInfo.comments'+postInfo.comments);
                }
            }
            system.debug('postCommentList'+postCommentList);
            system.debug('postCommentListToBeUpdated'+postCommentListToBeUpdated);
            List<Post_Comments__c> newComments = new   List<Post_Comments__c> ();
            if(postCommentList.size() > 0){
                List<Post_Comments__c> postCommentData = [Select Comment__c,Comment_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__c where case__r.Post_Id__c = :mediaId];
                if(postCommentData.size() > 15){
                    delete postCommentData;
                    insert postCommentList;
                }else{
                    for (Integer i = 0; i<= 10; i++) {
                        newComments.add(postCommentList[i]);
                        insert newComments;
                    }
                }
            }
            if(postCommentListToBeUpdated.size() > 0){
                update postCommentListToBeUpdated;
            }
            return 'Success';
            
        }catch(Exception e){
            system.debug('Error message'+e.getMessage());
            return e.getMessage();    
        }
        
        
        
    }
    
    //Pass this method the Comment id and the media id will be fetched.
    public static void updateCaseStatusAndinformUsers(List<Id> caseIds){
        
        map<id,User> UserRecordById = new map<id,User>([Select id , name ,Email from user]);
        map<id,Case> caseRecordsByOwnerId = new map<id,case>();
        List<Case> caseListToBeUpdated = new List<Case>();
        List<String> ownerIds = new list<String>();
        List<Case> casesWithNewComments  = [Select id ,Status,CaseNumber,Priority,Subject,OwnerId from case where id IN : caseIds and status != 'New'];
        
        for(Case caseRec : casesWithNewComments){
            caseRec.Status = 'New';
            caseRecordsByOwnerId.put(caseRec.OwnerId,caseRec);
        }
        Update casesWithNewComments;
        
        for(String str : caseRecordsByOwnerId.keyset()){
            sendEmailsTocaseOwners(UserRecordById.get(str) ,caseRecordsByOwnerId.get(str) );
        }
        
        
    }   
    
    public Static void sendEmailsTocaseOwners(User UserRecord , Case CaseRecord ){
        system.debug('The UserRecord is-->'+UserRecord); 
        system.debug('The CaseRecord case is-->'+CaseRecord); 
        EmailTemplate et = [Select id, htmlValue, Body, subject from EmailTemplate where DeveloperName = 'New_Comment_on_the_Post'];
        String htmlBody = et.HtmlValue;
        htmlBody = htmlBody.replace('[Case Number]', CaseRecord.CaseNumber);
        htmlBody = htmlBody.replace('[Case Subject]', CaseRecord.Subject);
        htmlBody = htmlBody.replace('[Current Status]', CaseRecord.Status);
        htmlBody = htmlBody.replace('[Priority]', CaseRecord.Priority);
        
        String plainBody = et.Body;
        
        plainBody = plainBody.replace('[Case Number]', CaseRecord.CaseNumber);
        plainBody = plainBody.replace('[Case Subject]', CaseRecord.Subject);
        plainBody = plainBody.replace('[Current Status]', CaseRecord.Status);
        plainBody = plainBody.replace('[Priority]', CaseRecord.Priority);
        
        //Below list is not required, it is just to show that we can send multiple email as well
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(UserRecord.Id);
        mail.setSenderDisplayName('Hyphen Support Team');
        mail.setSubject('New Comments on Case - Immediate Attention Required');
        mail.setSaveAsActivity(true);
        mail.setHtmlBody(htmlBody);
        if(Test.isRunningTest()){
            mail.setSaveAsActivity(false);    
        }
        
        mails.add(mail);
        
        if(mails.size() > 0 ) {
            Messaging.sendEmail(mails);
        }
        
    }
}