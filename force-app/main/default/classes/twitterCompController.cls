public class twitterCompController {
    private static Twitter_Api_Details__c fap           = Twitter_Api_Details__c.getInstance();
    private static final String CLIENT_ID               = fap.CLIENT_ID__c;
    private static String CLIENT_SECRET                 = fap.CLIENT_SECRET__c;
    private static String REDIRECT_URI                  = fap.REDIRECT_URI__c;
    private static String accessToken                   = fap.accessToken__c;
    private static String bearerToken                   = fap.Bearer_Token__c;
    private static String basicUrl                      = fap.basicUrl__c;
    private static String businessUserId                = fap.businessUserId__c;
    private static String Mention                       = fap.Mention__c;
    private static String authCode                      = fap.Auth_Code__c;
    private static String commentAccessToken            = fap.Comment_AccessToken__c;
    private static String refreshAccessToken            = fap.Comment_RefreshToken__c;
    
    @AuraEnabled
    public Static List<twitterWrapper> getCaseDetails(String recordId){
        List<twitterWrapper> twitterWrapperList = new List<twitterWrapper>();
        List<Case> CaseDetails = [Select id,subject,Description,Caption__c,Post_Url__c,Comment_Replied__c,(Select Comment__c,Comment_Id__c,Replied_Comments__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__r ) from case where id = :recordId ];
        
        for(Case caseRec : CaseDetails){
            if(caseRec.Post_Comments__r.size() > 0){
                for(Post_Comments__c pcRec : caseRec.Post_Comments__r ){
                    twitterWrapper iw = new twitterWrapper();
                    iw.comment = pcRec.Comment__c;
                    iw.CommentedBy = pcRec.Commented_By__c;
                    iw.PostUrl = pcRec.Post_Url__c;
                    iw.CommentId = pcRec.Comment_Id__c;
                    iw.postTime = pcRec.Post_comment_Time__c;
                    iw.postCaption = caseRec.Description;
                    twitterWrapperList.add(iw);
                }
            }else{
                twitterWrapper iw = new twitterWrapper();
                iw.postCaption = caseRec.Description;
                iw.comment = caseRec.Comment_Replied__c;
                iw.PostUrl = caseRec.Post_Url__c;
                twitterWrapperList.add(iw);
            }
            
        }
        return twitterWrapperList;
    }
    
    @AuraEnabled
    public Static String replyToTweetOnTwittter(String recordId,String textMessage){
        textMessage = textMessage.replaceAll('<[^>]+>','');
        Case CaseRec = [Select id,Post_Id__c from case where id = :recordId ];
        String tweetId = CaseRec.Post_Id__c;
        String ENDPOINT_URL = 'https://api.twitter.com/2/tweets';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer '+commentAccessToken);
        
        // Set the request body
        Map<String, Object> payloadMap = new Map<String, Object>{'text' => textMessage,'reply' => new Map<String, String>{'in_reply_to_tweet_id' => tweetId}};
        String jsonPayload = JSON.serialize(payloadMap);
        request.setBody(jsonPayload);
        
        try {
            String responseBody = '';
            if(test.isRunningTest()){
                responseBody = '{"data":{"edit_history_tweet_ids":["1694294660359782754"],"id":"1694294660359782754","text":"@kritisanon @ABandwear89816 thanks"}}';
            }else{
                HttpResponse response = http.send(request);   
                responseBody = response.getBody();
            }
            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            Map<String, Object> dataMap = (Map<String, Object>) jsonMap.get('data');
            String Commentid = (String) dataMap.get('id');
            system.debug('Commentid-->'+Commentid);
            case newCase = new case();
            caseRec.Id   = recordId;
            caseRec.Comment_Replied__c = textMessage;
            caseRec.Reply_Id__c = Commentid;
            caseRec.Comment_URL__c = 'https://twitter.com/letshyphen/status/'+Commentid;
            update CaseRec;
            System.debug('Response Body: ' + responseBody);
            
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
        
        return 'Success';
        
    }
    //Wrapper for twitter
    public class twitterWrapper{
        @AuraEnabled
        public String comment{get;set;}
        @AuraEnabled
        public String postTime{get;set;}
        @AuraEnabled
        public String postCaption{get;set;}
        @AuraEnabled
        public String CommentedBy {get;set;}
        @AuraEnabled
        public String PostUrl{get;set;}
        @AuraEnabled
        public String CommentId{get;set;}
    }
    
    private static String buildFormUrlEncodedBody(Map<String, String> params) {
        List<String> keyValuePairs = new List<String>();
        for (String key : params.keySet()) {
            keyValuePairs.add(EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8'));
        }
        return String.join(keyValuePairs, '&');
    }
    
}