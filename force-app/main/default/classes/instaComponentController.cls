/*
* Test Class name : InstagramAuthHelperTest_v1
* created Date     : 29/07/2023
* Created By       : shubham kumar
* Last Modfied By  : shubham kumar
* Descritpion      : This class contains all the api's related to instagram.
*/
public class instaComponentController {
    
    //Getting the basic details from custom setting
    private static Instagram_Api_Details__c fap = Instagram_Api_Details__c.getInstance();
    
    private static final String CLIENT_ID        = fap.CLIENT_ID__c;
    private static String CLIENT_SECRET          = fap.CLIENT_SECRET__c;
    private static String REDIRECT_URI           = fap.REDIRECT_URI__c;
    private static String accessToken            = fap.accessToken__c;
    private static String basicUrl               = fap.basicUrl__c;
    private static String businessUserId         = fap.businessUserId__c;
    
    
    @AuraEnabled
    public Static List<ReplyWrapperRecords> getRepliesDetails(String commentId){
        List<ReplyWrapperRecords> repliesWrapperList = new List<ReplyWrapperRecords>();
        List<ReplyWrapperRecords> replyDataList = new List<ReplyWrapperRecords>();
        List<Post_Comments__c> postCommentDetails = [Select Comment__c,Comment_Id__c,Replied_Comments__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__c where Comment_Id__c =:commentId];
        
        if(postCommentDetails.size() > 0){
            try{
                String jsonString = postCommentDetails[0].Replied_Comments__c;
                system.debug('jsonString'+jsonString);
                if(jsonString != null){
                    String jsonData = jsonString.substringAfter('data=(').substringBeforeLast(')');
                    
                    jsonData = jsonData.replaceAll('ReplyData:', '');
                    
                    jsonData = '[' + jsonData + ']';
                    String recordsString = jsonString.substring(1, jsonString.length() - 1);
                    String[] records = recordsString.split('],');
                    integer i = 0;
                    for (String record : records) {
                        i++;
                        String[] fields = record.split(', ');
                        ReplyWrapperRecords replyData = new ReplyWrapperRecords();
                        replyData.id = fields[0].substringAfter('='); // Extract value after 'id='
                        //replyData.times
                        replyData.text = fields[1].substringAfter('=').replaceAll('(?i)<br\\s*?/?>', '\n'); // Extract value after 'text='
                        if(i == records.size()){
                            replyData.username = fields[3].substringAfter('='); // Extract value after 'username='
                            replyData.username = replyData.username.removeEnd('])');
                        }else{
                            replyData.username = fields[3].substringAfter('='); // Extract value after 'username='    
                        }
                        fields[2] = fields[2].substringAfter('=').removeEnd('+0000');
                        List<String> DateTimeData = fields[2].split('T');
                        replyData.postDate = DateTimeData[0];
                        replyData.postTime = DateTimeData[1];
                        
                        system.debug('replyData'+replyData);
                        replyDataList.add(replyData);
                    } 
                    system.debug('replyDataList'+replyDataList);
                    return replyDataList;     
                }else{
                    return replyDataList;  
                }
            }
            catch(exception e){
                system.debug('Error is '+e.getMessage());
                return replyDataList;  
            }
        }else{
            
            return replyDataList;  
        }
        
    }
    //This is being called on page load..
    @AuraEnabled
    public Static List<instaWrapper> getCaseDetails(String recordId){
        List<instaWrapper> instaWrapperList = new List<instaWrapper>();
        List<Case> CaseDetails = [Select id,subject,Description,Type_of_Post__c,Caption__c,POST_URL__c,(Select Comment__c,Comment_Id__c,Replied_Comments__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__r ) from case where id = :recordId];
        
        for(Case caseRec : CaseDetails){
            try{
            if(caseRec.Post_Comments__r.size() > 0){
               
                    for(Post_Comments__c pcRec : caseRec.Post_Comments__r ){
                        instaWrapper iw = new instaWrapper();
                        iw.comment = pcRec.Comment__c;
                        iw.CommentedBy = pcRec.Commented_By__c;
                        iw.PostUrl = pcRec.Post_Url__c;
                        iw.CommentId = pcRec.Comment_Id__c;
                        pcRec.Post_comment_Time__c = pcRec.Post_comment_Time__c.removeEnd('+0000');
                        List<String> DateTimeData = pcRec.Post_comment_Time__c.split('T');
                        system.debug('DateTimeData'+DateTimeData);
                        iw.postDate = DateTimeData[0];
                        iw.postTime = DateTimeData[1];
                        iw.postType = caseRec.Type_of_Post__c;
                        iw.postCaption = caseRec.Description;
                        instaWrapperList.add(iw);
                    }
                }else{
                    instaWrapper iw = new instaWrapper();
                    iw.PostUrl = caseRec.Post_Url__c;
                    iw.postCaption = caseRec.Description;
                    iw.postType = caseRec.Type_of_Post__c;
                    instaWrapperList.add(iw);
                }
            }
             catch(exception e){
                system.debug('Error is '+e.getMessage());
                return instaWrapperList;  
            }
        }
        return instaWrapperList;
    }
    
    @AuraEnabled
    public Static void replyToComment(String commentId,String commentMessage){
        system.debug('commentId'+commentId);
        system.debug('commentMessage'+commentMessage);
	
       
        commentMessage = EncodingUtil.urlEncode(commentMessage, 'UTF-8');
        commentMessage = commentMessage.replaceAll(' ','%20');
        commentMessage = commentMessage.replaceAll('<[^>]+>','');
       
        String endpointUrl = basicUrl+commentId+'/replies?message='+commentMessage;
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+accessToken};
            HttpResponse response = DynamicHttpCallout.makeHttpPOSTCallout(endpointUrl, queryParams, headers);
        system.debug('Response==>'+response.getBody());
        // Process the response
        if (response.getStatusCode() == 200) {
            system.debug('The Response is ==>'+response.getBody());
        }else{
            system.debug('The Failed Response is ==>'+response.getBody());
        }   
    }
    
    public class instaWrapper{
        @AuraEnabled
        public String comment{get;set;}
        @AuraEnabled
        public String postTime{get;set;}
        @AuraEnabled
        public String postDate{get;set;}
        @AuraEnabled
        public String postCaption{get;set;}
        @AuraEnabled
        public String postType{get;set;}
        @AuraEnabled
        public String CommentedBy {get;set;}
        @AuraEnabled
        public String PostUrl{get;set;}
        @AuraEnabled
        public String CommentId{get;set;}
    }
    
    public class ReplyWrapperRecords {
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String postDate { get; set; }
        @AuraEnabled
        public String postTime { get; set; }
        @AuraEnabled
        public String text { get; set; }
        @AuraEnabled
        public String username { get; set; }
    }
}