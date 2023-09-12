public class InstagramMentionCreationBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    private static Instagram_Api_Details__c fap = Instagram_Api_Details__c.getInstance();
    private static final String CLIENT_ID                                    = fap.CLIENT_ID__c;
    private static String CLIENT_SECRET                                      = fap.CLIENT_SECRET__c;
    private static String REDIRECT_URI                                       = fap.REDIRECT_URI__c;
    private static String accessToken                                        = fap.accessToken__c;
    private static String basicUrl                                           = fap.basicUrl__c;
    private static String businessUserId                                     = fap.businessUserId__c;
    private static List<case> existingCaseList                               = new List<case> ();
    private static List<case> insertedCaseList                               = new List<case>();
    private static List<Post_Comments__c> newpostCommentList                            = new List<Post_Comments__c>();
    private static List<Post_Comments__c> newpostCommentForExistingPosts                = new List<Post_Comments__c>();
    private static List<Post_Comments__c> postCommentsForExistingPostsToBeInserted      = new List<Post_Comments__c>();
    private static List<Post_Comments__c> postCommentListToBeUpdated                    = new List<Post_Comments__c>();
    private static List<Id> caseIdsToBeUpdated                               = new List<Id>();
    private static map<String,List<Post_Comments__c>> commentsOnPostByPostId = new map<String,List<Post_Comments__c>>();
    private static map<String,String> caseIdByPostId                         = new map<String,String>();
    private static map<String,String> postCommentIdByPostId                  = new map<String,String>();
    private static map<String,String> caseIdByPostCommentId                  = new map<String,String>();
    List<String> casePostIds                                                 = new List<String>();
    List<Case> ExistingCaseRecords                                           = new List<Case>();
    //Getting the record Type Id
    private static Id caseRecordTypeId                                       = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String origin = 'Instagram';
        String query = 'Select id,subject,Description,Caption__c,Post_Id__c,(Select Comment__c,Comment_Id__c,case__c,Case__r.Post_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__r) from case where Origin = :origin and recordTypeId = :caseRecordTypeId';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<case> caseRecordsList) {
        for(case caseRec : caseRecordsList){
            ExistingCaseRecords.add(caseRec);
        }
    }
    
    public void finish(Database.BatchableContext context) {
        system.debug('ExistingCaseRecords'+ExistingCaseRecords.size());
        Set<Id> CaseIdsToBeDeleted = new Set<Id>();
        for(case caseRec : ExistingCaseRecords){
            system.debug('The size is ==>'+caseRec.Post_Comments__r.size());
            for(Post_Comments__c postCommRec : caseRec.Post_Comments__r){
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
        }
        
        for(Case caseRec : ExistingCaseRecords){
            list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
            caseIdByPostId.put(caseRec.Post_Id__c,caseRec.Id);
            if(!commentsOnPostByPostId.keyset().contains(caseRec.Post_Id__c)){
                commentsOnPostByPostId.put(caseRec.Post_Id__c,postCommNewList);
            }
        }
        
        String endpointUrl = 'https://graph.facebook.com/v17.0/'+businessUserId+'/tags';
        String fieldsParam = 'fields=media_url,comments_count,permalink,caption,media_type,timestamp,username,comments.limit(25){id,like_count,user,media,timestamp,username,replies{text,username,timestamp},text}&limit=50';
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        String fullUrl = endpointUrl + '?' + fieldsParam + '&access_token=' + accessToken;
        String body = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(fullUrl);
        request.setMethod('GET');
        
        if (test.isRunningTest()){
            body = '{"data":[{"id":"17841405793087218","username":"example_user","timestamp":"2023-07-29T12:34:56+0000","caption":"This is an amazing photo!","media_type":"IMAGE","media_url":"https://www.example.com/image.jpg","permalink":"https://www.instagram.com/p/ABC123/","comments_count":5,"comments":{"data":[{"id":"17851087209098192","text":"Awesome!","username":"user1","timestamp":"2023-07-29T12:40:00+0000"},{"id":"17851087209098193","text":"Great shot!","username":"user2","timestamp":"2023-07-29T12:42:30+0000"},{"id":"17851087209098194","text":"Beautiful!","username":"user3","timestamp":"2023-07-29T12:45:15+0000"},{"id":"17851087209098195","text":"Nice!","username":"user4","timestamp":"2023-07-29T12:50:20+0000"},{"id":"17851087209098196","text":"Love it!","username":"user5","timestamp":"2023-07-29T13:00:00+0000"}],"paging":{"cursors":{"before":"cursor_before","after":"cursor_after"},"next":"https://www.instagram.com/p/ABC123/comments?cursor=cursor_after"}}},{"id":"17841405793087219","username":"another_user","timestamp":"2023-07-29T14:30:45+0000","caption":"Sunset vibes!","media_type":"VIDEO","media_url":"https://www.example.com/video.mp4","permalink":"https://www.instagram.com/p/XYZ456/","comments_count":2,"comments":{"data":[{"id":"17851087209098197","text":"Amazing video!","username":"user6","timestamp":"2023-07-29T14:40:00+0000"},{"id":"17851087209098198","text":"Beautiful sunset!","username":"user7","timestamp":"2023-07-29T14:45:30+0000"}],"paging":{"cursors":{"before":"cursor_before","after":"cursor_after"},"next":"https://www.instagram.com/p/XYZ456/comments?cursor=cursor_after"}}}],"paging":{"cursors":{"before":"cursor_before","after":"cursor_after"},"next":"https://www.instagram.com/user123/media?cursor=cursor_after"}}';
        }else{
            HttpResponse response = http.send(request);
            body = response.getBody();
        }
        
        
        FacebookApiResponse responseWrapper = (FacebookApiResponse) JSON.deserialize(body, FacebookApiResponse.class);
        system.debug('responseWrapper'+responseWrapper);
        for(FacebookApiResponse.DataWrapper postInfo : responseWrapper.data){
            System.debug('postInfo === >'+postInfo);
            if(!commentsOnPostByPostId.keyset().contains(postInfo.Id)){
                Case newCase = new case();
                newCase.Related_to__c = postInfo.username;
                newCase.Brand__c      = 'Hyphen';
                newCase.Origin        = 'Instagram';
                newCase.Post_Id__c = postInfo.id;
                newcase.Created_Time__c = String.valueOf(postInfo.timestamp).removeEnd('+0000');
                newcase.POST_URL__c = postInfo.permalink;
                newcase.recordtypeId = caseRecordTypeId;
                if((postInfo.comments != null)){
                    newcase.Comments_JSON__c = string.valueOf(postInfo.comments.data);
                }
                newcase.Priority = 'High';
                newcase.Type_of_Post__c = 'Tags/Mentions';
                newcase.Subject = 'Mention Post from instagram.Related to '+postInfo.username+'. Created Date-Time : '+newcase.Created_Time__c;
                newcase.Description = postInfo.caption;
                if(!commentsOnPostByPostId.keyset().contains(newCase.Post_Id__c)){
                    insert newcase;
                    insertedCaseList.add(newcase);
                }
                System.debug('postInfo.comments  If == >'+postInfo.comments );
                if((postInfo.comments != null)){
                    if(newcase.Id != null){
                        for(FacebookApiResponse.CommentData postInfoRec : postInfo.comments.data){
                            Post_Comments__c commentRec = new Post_Comments__c();
                            commentRec.Case__c = newcase.Id;
                            commentRec.Comment__c = postInfoRec.text;
                            commentRec.Comment_Id__c = postInfoRec.Id;
                            commentRec.Commented_By__c = postInfoRec.username;
                            commentRec.Post_comment_Time__c = postInfoRec.timestamp;
                            commentRec.Replied_Comments__c = string.valueOf(postInfoRec.replies);
                            commentRec.Post_Url__c	 = postInfo.permalink;
                            newpostCommentList.add(commentRec);
                        }      
                    }
                }
            }else{
                if(postInfo.comments != null){
                    for(FacebookApiResponse.CommentData postInfoRec : postInfo.comments.data){
                        if(commentsOnPostByPostId.containsKey(postInfo.Id)){
                            List<String> postCommentIds = new List<String>();
                            if(commentsOnPostByPostId.get(postInfo.Id).size() > 0){
                                for(Post_Comments__c poCom :  commentsOnPostByPostId.get(postInfo.Id)){
                                    postCommentIds.add(poCom.Comment_Id__c);
                                }    
                            }
                            if(!postCommentIds.contains(postInfoRec.Id)){
                                Post_Comments__c commentRec = new Post_Comments__c();
                                commentRec.Case__c = caseIdByPostId.get(postInfo.Id);
                                commentRec.Comment__c = postInfoRec.text;
                                commentRec.Comment_Id__c = postInfoRec.Id;
                                commentRec.Commented_By__c = postInfoRec.username;
                                commentRec.Post_comment_Time__c = postInfoRec.timestamp;
                                commentRec.Post_Url__c	 = postInfo.permalink;
                                commentRec.Replied_Comments__c = string.valueOf(postInfoRec.replies);
                                system.debug('replies are'+postInfoRec.replies);
                                newpostCommentForExistingPosts.add(commentRec);
                            }else{
                                //This will come here comments have to be updated..
                                system.debug('replies are'+postInfoRec.replies);
                                Post_Comments__c commentRec = new Post_Comments__c();
                                commentRec.Id = postCommentIdByPostId.get(postInfoRec.Id);
                                if(caseIdByPostCommentId.ContainsKey(postInfoRec.Id)){
                                    caseIdsToBeUpdated.add(caseIdByPostCommentId.get(postInfoRec.Id));    
                                }
                                commentRec.Replied_Comments__c = string.valueOf(postInfoRec.replies);
                                postCommentListToBeUpdated.add(commentRec);
                                
                            }
                        }
                    }
                }else{
                    system.debug('postInfo.comments'+postInfo.comments);
                }
            }
        }
        for(Post_Comments__c postCommRec : newpostCommentForExistingPosts){
            CaseIdsToBeDeleted.add(postCommRec.Case__c);
            if(postCommentIdByPostId.keySet().contains(postCommRec.Comment_Id__c)){
                
            }else{
                postCommentsForExistingPostsToBeInserted.add(postCommRec);
                
            }
        }

        if(newpostCommentList.size() > 0){
            Database.insert(newpostCommentList,false);
        }
        
        if(postCommentsForExistingPostsToBeInserted.size() > 0){
            List<Post_Comments__c> postCommentsDelete = [Select id from Post_Comments__c where Case__c IN:CaseIdsToBeDeleted];
            database.delete(postCommentsDelete);
            Database.insert(postCommentsForExistingPostsToBeInserted, false);    
        }
        
        if(postCommentListToBeUpdated.size() > 0){
            Database.update(postCommentListToBeUpdated,false);
        }
        
    }
}