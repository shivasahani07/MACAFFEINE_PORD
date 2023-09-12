/* Test Class name : twitterApisTest
* created Date     : 29/07/2023
* Created By       : shubham kumar
* Last Modfied By  : shubham kumar
* Descritpion      : This class contains all the api's related to instagram.
*/
public class twitterApis {
    
    //Getting the basic details from custom setting
    private static Twitter_Api_Details__c fap           = Twitter_Api_Details__c.getInstance();
    private static final String CLIENT_ID               = fap.CLIENT_ID__c;
    private static String CLIENT_SECRET                 = fap.CLIENT_SECRET__c;
    private static String REDIRECT_URI                  = fap.REDIRECT_URI__c;
    private static String accessToken                   = fap.accessToken__c;
    private static String bearerToken                   = fap.Bearer_Token__c;
    private static String basicUrl                      = fap.basicUrl__c;
    private static String businessUserId                = fap.businessUserId__c;
    private static String Mention                       = fap.Mention__c;
    private static Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    
    //Get all the posts that are related to this business user id
   
    public static void getAllRecentTweetsFromTwitter(){
        List<case> insertedCaseList 										= new List<case>();
        List<case> CaseListToBeInserted 									= new List<case>();
        map<String,List<Post_Comments__c>> commentsOnPostByPostId           = new map<String,List<Post_Comments__c>>();
        map<String,String> caseIdByPostId                                   = new map<String,String>();
        map<String,String> postCommentIdByPostId                            = new map<String,String>();
        map<String,String> caseIdByPostCommentId                            = new map<String,String>();
        List<String> casePostIds                                            = new List<String>();
        
        List<case> existingCaseList = [Select id,subject,Description,Caption__c,Post_Id__c from case where recordTypeId = :caseRecordTypeId and Origin = 'Twitter'];
        List<Post_Comments__c> postCommentDataList = new List<Post_Comments__c>();
        postCommentDataList  = [Select Comment__c,Comment_Id__c,case__c,Case__r.Post_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__c where case__c IN :existingCaseList ]; 
        
        for(Post_Comments__c postCommRec : postCommentDataList){
            postCommentIdByPostId.put(postCommRec.Comment_Id__c,postCommRec.Id);
            caseIdByPostCommentId.put(postCommRec.Comment_Id__c,postCommRec.Case__c);
            if(commentsOnPostByPostId.containsKey(postCommRec.Case__c)){
                commentsOnPostByPostId.get(postCommRec.Case__r.Post_Id__c).add(postCommRec);
            }else{
                list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
                postCommNewList.add(postCommRec);
                commentsOnPostByPostId.put(postCommRec.Case__r.Post_Id__c,postCommNewList);
            }
        }
        
        for(Case caseRec : existingCaseList){
            list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
            caseIdByPostId.put(caseRec.Post_Id__c,caseRec.Id);
            if(!commentsOnPostByPostId.keyset().contains(caseRec.Post_Id__c)){
                commentsOnPostByPostId.put(caseRec.Post_Id__c,postCommNewList);
            }
        }
        
        String endpointUrl = basicUrl+'/tweets/search/recent';
        String fieldsParam = 'max_results=50&tweet.fields=text,id,in_reply_to_user_id,author_id,created_at&query='+Mention;
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        String fullUrl = endpointUrl + '?' + fieldsParam;
        
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+bearerToken};
            String responseBody = '';
        if(test.isRunningTest()){
            responseBody = '{"data":[{"in_reply_to_user_id":"356087800","text":"We can’t wait to hear your Hyphen story🫶","edit_history_tweet_ids":["1691484940108505089"],"created_at":"2023-08-15T16:20:10.000Z","id":"1691484940108505089","author_id":"1663898120684711943"}]}';
        }else{
            HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(fullUrl, queryParams, headers);
            responseBody = response.getBody();
            
        }
        
        twitterApiResponseWrapper responseWrapper = (twitterApiResponseWrapper) JSON.deserialize(responseBody, twitterApiResponseWrapper.class);
        if( responseWrapper.data.size() == 50){
            system.debug('50 cases are there lets proceed'+responseWrapper.data.size());
            Twitter_Api_Details__c tweetSetting = Twitter_Api_Details__c.getOrgDefaults();
            tweetSetting.Id = tweetSetting.Id;
            tweetSetting.Next_Recent_Tweet_Pagination_Token__c = responseWrapper.meta.next_token;
            update tweetSetting;
        }
        
        
        system.debug('responseWrapper'+responseWrapper);
        for(twitterApiResponseWrapper.data postInfo : responseWrapper.data){
            System.debug('postInfo === >'+postInfo);
            if(!commentsOnPostByPostId.keyset().contains(postInfo.Id)){
                Case newCase = new case();
                newCase.Related_to__c = postInfo.author_id;
                //newCase.Brand__c      = 'Hyphen';
                newCase.Origin        = 'Twitter';
                newCase.Post_Id__c    = postInfo.id;
                newcase.Created_Time__c = String.valueOf(postInfo.created_at).removeEnd('.000Z');
                newcase.POST_URL__c = 'https://twitter.com/letshyphen/status/'+postInfo.id;
                newcase.recordtypeId = caseRecordTypeId;
                newcase.Priority = 'High';
                newcase.Type_of_Post__c = 'Post';
                newcase.Subject = 'Post from twitter Related to '+postInfo.author_id+'. Created Date-Time : '+postInfo.created_at.removeEnd('.000Z');
                newcase.Description = postInfo.text;
                if(!commentsOnPostByPostId.keyset().contains(newCase.Post_Id__c)){
                    insertedCaseList.add(newcase);
                }
            }else{
                
            }
        }
        
        system.debug('size of insertedCaseList==>'+insertedCaseList.size());
        if(!insertedCaseList.isEmpty()){
            insert insertedCaseList;
        }
    }
    
    public static void getAllTweetsFromTimeLine(){
        List<case> insertedCaseList 										= new List<case>();
        List<case> CaseListToBeInserted 									= new List<case>();
        map<String,List<Post_Comments__c>> commentsOnPostByPostId           = new map<String,List<Post_Comments__c>>();
        map<String,String> caseIdByPostId                                   = new map<String,String>();
        map<String,String> postCommentIdByPostId                            = new map<String,String>();
        map<String,String> caseIdByPostCommentId                            = new map<String,String>();
        List<String> casePostIds                                            = new List<String>();
        
        List<case> existingCaseList = [Select id,subject,Description,Caption__c,Post_Id__c from case where recordTypeId = :caseRecordTypeId and Origin = 'Twitter'];
        List<Post_Comments__c> postCommentDataList = new List<Post_Comments__c>();
        postCommentDataList  = [Select Comment__c,Comment_Id__c,case__c,Case__r.Post_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__c where case__c IN :existingCaseList ]; 
        
        for(Post_Comments__c postCommRec : postCommentDataList){
            postCommentIdByPostId.put(postCommRec.Comment_Id__c,postCommRec.Id);
            caseIdByPostCommentId.put(postCommRec.Comment_Id__c,postCommRec.Case__c);
            if(commentsOnPostByPostId.containsKey(postCommRec.Case__c)){
                commentsOnPostByPostId.get(postCommRec.Case__r.Post_Id__c).add(postCommRec);
            }else{
                list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
                postCommNewList.add(postCommRec);
                commentsOnPostByPostId.put(postCommRec.Case__r.Post_Id__c,postCommNewList);
            }
        }
        
        for(Case caseRec : existingCaseList){
            list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
            caseIdByPostId.put(caseRec.Post_Id__c,caseRec.Id);
            if(!commentsOnPostByPostId.keyset().contains(caseRec.Post_Id__c)){
                commentsOnPostByPostId.put(caseRec.Post_Id__c,postCommNewList);
            }
        }
        String endpointUrl = basicUrl+'/users/'+businessUserId+'/tweets';
        String fieldsParam = 'max_results=50&tweet.fields=text,id,in_reply_to_user_id,author_id,created_at';
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        String fullUrl = endpointUrl + '?' + fieldsParam;
        
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+bearerToken};
            String responseBody = '';
        if(test.isRunningTest()){
            responseBody = '{"data":[{"in_reply_to_user_id":"356087800","text":"We can’t wait to hear your Hyphen story🫶","edit_history_tweet_ids":["1691484940108505089"],"created_at":"2023-08-15T16:20:10.000Z","id":"1691484940108505089","author_id":"1663898120684711943"}]}';
        }else{
            HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(fullUrl, queryParams, headers);
            responseBody = response.getBody();
        }
        twitterApiResponseWrapper responseWrapper = (twitterApiResponseWrapper) JSON.deserialize(responseBody, twitterApiResponseWrapper.class);
        if( responseWrapper.data.size() == 50){
            system.debug('50 cases are there lets proceed'+responseWrapper.data.size());
            Twitter_Api_Details__c tweetSetting = Twitter_Api_Details__c.getOrgDefaults();
            tweetSetting.Id = tweetSetting.Id;
            tweetSetting.Next_Timeline_Pagination_Token__c = responseWrapper.meta.next_token;
            update tweetSetting;
        }
        
        system.debug('responseWrapper'+responseWrapper);
        for(twitterApiResponseWrapper.data postInfo : responseWrapper.data){
            System.debug('postInfo === >'+postInfo);
            if(!commentsOnPostByPostId.keyset().contains(postInfo.Id)){
                Case newCase = new case();
                newCase.Related_to__c = postInfo.author_id;
                //newCase.Brand__c      = 'Hyphen';
                newCase.Origin        = 'Twitter';
                newCase.Post_Id__c    = postInfo.id;
                newcase.Created_Time__c = String.valueOf(postInfo.created_at).removeEnd('.000Z');
                newcase.POST_URL__c = 'https://twitter.com/letshyphen/status/'+postInfo.id;
                newcase.recordtypeId = caseRecordTypeId;
                newcase.Priority = 'High';
                newcase.Type_of_Post__c = 'Post';
                newcase.Subject = 'Post from twitter Related to '+postInfo.author_id+'. Created Date-Time : '+postInfo.created_at.removeEnd('.000Z');
                newcase.Description = postInfo.text;
                if(!commentsOnPostByPostId.keyset().contains(newCase.Post_Id__c)){
                    insertedCaseList.add(newcase);
                }
            }else{
                
            }
        }
        
        system.debug('size of insertedCaseList==>'+insertedCaseList.size());
        if(!insertedCaseList.isEmpty()){
            insert insertedCaseList;
        }
    }
    
    public static void getAllMentionsFromTimeLine(){
        List<case> insertedCaseList 										= new List<case>();
        List<case> CaseListToBeInserted                                     = new List<case>();
        map<String,List<Post_Comments__c>> commentsOnPostByPostId           = new map<String,List<Post_Comments__c>>();
        map<String,String> caseIdByPostId                                   = new map<String,String>();
        map<String,String> postCommentIdByPostId                            = new map<String,String>();
        map<String,String> caseIdByPostCommentId                            = new map<String,String>();
        List<String> casePostIds                                            = new List<String>();
        
        List<case> existingCaseList = [Select id,subject,Description,Caption__c,Post_Id__c from case where recordTypeId = :caseRecordTypeId and Origin = 'Twitter'];
        List<Post_Comments__c> postCommentDataList = new List<Post_Comments__c>();
        postCommentDataList  = [Select Comment__c,Comment_Id__c,case__c,Case__r.Post_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__c where case__c IN :existingCaseList ]; 
        
        for(Post_Comments__c postCommRec : postCommentDataList){
            postCommentIdByPostId.put(postCommRec.Comment_Id__c,postCommRec.Id);
            caseIdByPostCommentId.put(postCommRec.Comment_Id__c,postCommRec.Case__c);
            if(commentsOnPostByPostId.containsKey(postCommRec.Case__c)){
                commentsOnPostByPostId.get(postCommRec.Case__r.Post_Id__c).add(postCommRec);
            }else{
                list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
                postCommNewList.add(postCommRec);
                commentsOnPostByPostId.put(postCommRec.Case__r.Post_Id__c,postCommNewList);
            }
        }
        
        for(Case caseRec : existingCaseList){
            list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
            caseIdByPostId.put(caseRec.Post_Id__c,caseRec.Id);
            if(!commentsOnPostByPostId.keyset().contains(caseRec.Post_Id__c)){
                commentsOnPostByPostId.put(caseRec.Post_Id__c,postCommNewList);
            }
        }
        
        String endpointUrl = basicUrl+'/users/'+businessUserId+'/mentions';
        String fieldsParam = 'max_results=50&tweet.fields=text,id,author_id,in_reply_to_user_id,created_at';
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        String fullUrl = endpointUrl + '?' + fieldsParam;
        
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+bearerToken};
            String responseBody = '';
        if(test.isRunningTest()){
            responseBody = '{"data":[{"in_reply_to_user_id":"356087800","text":"We can’t wait to hear your Hyphen story🫶","edit_history_tweet_ids":["1691484940108505089"],"created_at":"2023-08-15T16:20:10.000Z","id":"1691484940108505089","author_id":"1663898120684711943"}]}';
        }else{
            
            HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(fullUrl, queryParams, headers);
            responseBody = response.getBody();
        }
        
        twitterApiResponseWrapper responseWrapper = (twitterApiResponseWrapper) JSON.deserialize(responseBody, twitterApiResponseWrapper.class);
        if( responseWrapper.data.size() == 50){
            system.debug('50 cases are there lets proceed'+responseWrapper.data.size());
            Twitter_Api_Details__c tweetSetting = Twitter_Api_Details__c.getOrgDefaults();
            tweetSetting.Id = tweetSetting.Id;
            tweetSetting.Next_Mention_Pagination_Token__c = responseWrapper.meta.next_token;
            update tweetSetting;
        }
        
        
        system.debug('responseWrapper'+responseWrapper);
        for(twitterApiResponseWrapper.data postInfo : responseWrapper.data){
            System.debug('postInfo === >'+postInfo);
            if(!commentsOnPostByPostId.keyset().contains(postInfo.Id)){
                Case newCase = new case();
                newCase.Related_to__c = postInfo.author_id;
                //newCase.Brand__c      = 'Hyphen';
                newCase.Origin        = 'Twitter';
                newCase.Post_Id__c    = postInfo.id;
                newcase.Created_Time__c = String.valueOf(postInfo.created_at).removeEnd('.000Z');
                newcase.POST_URL__c = 'https://twitter.com/letshyphen/status/'+postInfo.id;
                newcase.recordtypeId = caseRecordTypeId;
                newcase.Priority = 'High';
                newcase.Type_of_Post__c = 'Tags/Mentions';
                newcase.Subject = 'Post from twitter Related to '+postInfo.author_id+'. Created Date-Time : '+postInfo.created_at.removeEnd('.000Z');
                newcase.Description = postInfo.text;
                if(!commentsOnPostByPostId.keyset().contains(newCase.Post_Id__c)){
                    insertedCaseList.add(newcase);
                }
            }else{
                
            }
        }
        
        system.debug('size of insertedCaseList==>'+insertedCaseList.size());
        if(!insertedCaseList.isEmpty()){
            database.insert(insertedCaseList);
        }
    }
    
    @Future(callout=true)
    public static void getAllCommentsRelatedToTweet(String tweetId){
        case CaseRecord = [Select id , subject , Post_Id__c from case where Post_Id__c = :tweetId][0];
        List<case> existingCaseList = [Select id,subject,Description,Caption__c,Post_Id__c,(Select Comment__c,Comment_Id__c,case__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__r ) from case where recordTypeId = :caseRecordTypeId];
        List<case> insertedCaseList = new List<case>();
        List<Post_Comments__c> postCommentList                    = new List<Post_Comments__c>();
        List<Post_Comments__c> postCommentListToBeUpdated         = new List<Post_Comments__c>();
        List<Id> caseIdsToBeUpdated                               = new List<Id>();
        map<String,List<Post_Comments__c>> commentsOnPostByPostId = new map<String,List<Post_Comments__c>>();
        map<String,String> caseIdByPostId                         = new map<String,String>();
        map<String,String> postCommentIdByPostId                  = new map<String,String>();
        map<String,String> caseIdByPostCommentId                  = new map<String,String>();
        List<String> casePostIds                                  = new List<String>();
        for(Case caseRec : existingCaseList){
            commentsOnPostByPostId.put(caseRec.Post_Id__c,caseRec.Post_Comments__r);
            caseIdByPostId.put(caseRec.Post_Id__c,caseRec.Id);
            for(Post_Comments__c pocRec : caseRec.Post_Comments__r){
                postCommentIdByPostId.put(pocRec.Comment_Id__c,pocRec.Id);
                caseIdByPostCommentId.put(pocRec.Comment_Id__c,pocRec.Case__c);
            }
        }
        system.debug('commentsOnPostByPostId'+commentsOnPostByPostId);
        String endpointUrl = basicUrl+'/tweets/search/recent';
        String fieldsParam = 'max_results=50&tweet.fields=text,id,in_reply_to_user_id,created_at&query=conversation_id:'+tweetId;
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        String fullUrl = endpointUrl + '?' + fieldsParam;
        
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Bearer '+bearerToken};
            HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(fullUrl, queryParams, headers);
        System.debug('response.getBody() === > '+response.getBody());
        
        twitterApiResponseWrapper responseWrapper = (twitterApiResponseWrapper) JSON.deserialize(response.getBody(), twitterApiResponseWrapper.class);
        system.debug('responseWrapper'+responseWrapper);
        for(twitterApiResponseWrapper.data postInfo : responseWrapper.data){
            System.debug('postInfo === >'+postInfo);
            if(!commentsOnPostByPostId.keyset().contains(postInfo.Id)){
                Post_Comments__c commentRec     = new Post_Comments__c();
                commentRec.Comment_Id__c        = postInfo.id;
                commentRec.Post_comment_Time__c = String.valueOf(postInfo.created_at).removeEnd('.000Z');
                commentRec.POST_URL__c          = 'https://twitter.com/letshyphen/status/'+postInfo.id;
                commentRec.Comment__c           = postInfo.text;
                commentRec.Case__c              = CaseRecord.Id;
                if(!postCommentIdByPostId.keyset().contains(postInfo.id)){
                    insert commentRec;
                    //insertedCaseList.add(newcase);
                }
            }else{
                
            }
        }
    }
    
   
    
}