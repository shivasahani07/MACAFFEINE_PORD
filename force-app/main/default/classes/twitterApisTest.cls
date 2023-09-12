@isTest
public class twitterApisTest {
    private static Id caseRecordTypeId                                       = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    @isTest
    static void testGetAllRecentTweetsFromTwitter() {
        Twitter_Api_Details__c fap  = New Twitter_Api_Details__c();
        fap.CLIENT_ID__c='TEST client id';
        fap.CLIENT_SECRET__c='test clident secret';
        fap.REDIRECT_URI__c='test rediret url';
        fap.accessToken__c='38u8ue32u20e9ue0329';
        fap.Bearer_Token__c='38u8ue32u20e9ue0329';
        fap.basicUrl__c='htttps//wwwdinciencec';
        fap.businessUserId__c='tttps//wwwdincience';
        fap.Mention__c='mention';
        fap.Auth_Code__c='38u8ue32u20e9ue0329';
        fap.Comment_AccessToken__c='Accesstokentest';
        insert fap;
        
        Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        Case caseRec = new Case();
        caseRec.Post_Id__c = '17841405793087218';
        caseRec.RecordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        caseRec.Description = 'Testing';
        caseRec.Subject = 'Testing';
        caseRec.Created_Time__c='2023-08-08';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id;
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=17841405793087218])])';
        insert postComment;
        
        // Create an instance of the twitterApiResponseWrapper class and populate its data
        twitterApiResponseWrapper responseWrapper = new twitterApiResponseWrapper();
        responseWrapper.meta = new twitterApiResponseWrapper.meta();
        responseWrapper.meta.oldest_id = '123';
        responseWrapper.meta.result_count = 10;
        responseWrapper.meta.newest_id = '456';
        
        twitterApiResponseWrapper.data tweetData = new twitterApiResponseWrapper.data();
        tweetData.text = 'Sample tweet content';
        tweetData.edit_history_tweet_ids = new List<String>{'789', '1011'};
            tweetData.created_at = '2023-08-21T12:34:56.000Z';
        tweetData.id = '12345';
        tweetData.in_reply_to_user_id = '67890';
        tweetData.author_id = '54321';
        responseWrapper.data = new List<twitterApiResponseWrapper.data>{tweetData};
            // Convert the responseWrapper instance to a JSON string
            String jsonRepresentation = JSON.serialize(responseWrapper);
        System.debug(jsonRepresentation);
        
        
        
        Test.startTest();
        // Create and set mock HTTP response here
        // Mock the HttpCalloutMock class for the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to be tested
        twitterApis.getAllRecentTweetsFromTwitter();
        Test.stopTest();
        
        
    }
    
    @isTest
    static void testGetAllTweetsFromTimeLine() {
        Twitter_Api_Details__c fap  = New Twitter_Api_Details__c();
        fap.CLIENT_ID__c='TEST client id';
        fap.CLIENT_SECRET__c='test clident secret';
        fap.REDIRECT_URI__c='test rediret url';
        fap.accessToken__c='38u8ue32u20e9ue0329';
        fap.Bearer_Token__c='38u8ue32u20e9ue0329';
        fap.basicUrl__c='htttps//wwwdinciencec';
        fap.businessUserId__c='tttps//wwwdincience';
        fap.Mention__c='mention';
        fap.Auth_Code__c='38u8ue32u20e9ue0329';
        fap.Comment_AccessToken__c='Accesstokentest';
        insert fap;
        
        Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        Case caseRec = new Case();
        caseRec.Post_Id__c = '17841405793087218';
        caseRec.RecordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        caseRec.Description = 'Testing';
        caseRec.Subject = 'Testing';
        caseRec.Created_Time__c='2023-08-08';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id;
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=17841405793087218])])';
        insert postComment;
        
        // Create an instance of the twitterApiResponseWrapper class and populate its data
        twitterApiResponseWrapper responseWrapper = new twitterApiResponseWrapper();
        responseWrapper.meta = new twitterApiResponseWrapper.meta();
        responseWrapper.meta.oldest_id = '123';
        responseWrapper.meta.result_count = 10;
        responseWrapper.meta.newest_id = '456';
        
        twitterApiResponseWrapper.data tweetData = new twitterApiResponseWrapper.data();
        tweetData.text = 'Sample tweet content';
        tweetData.edit_history_tweet_ids = new List<String>{'789', '1011'};
            tweetData.created_at = '2023-08-21T12:34:56.000Z';
        tweetData.id = '12345';
        tweetData.in_reply_to_user_id = '67890';
        tweetData.author_id = '54321';
        responseWrapper.data = new List<twitterApiResponseWrapper.data>{tweetData};
            // Convert the responseWrapper instance to a JSON string
            String jsonRepresentation = JSON.serialize(responseWrapper);
        System.debug(jsonRepresentation);
        
        
        
        Test.startTest();
        // Create and set mock HTTP response here
        // Mock the HttpCalloutMock class for the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to be tested
        twitterApis.getAllTweetsFromTimeLine();
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetAllMentionsFromTimeLine() {
        Twitter_Api_Details__c fap  = New Twitter_Api_Details__c();
        fap.CLIENT_ID__c='TEST client id';
        fap.CLIENT_SECRET__c='test clident secret';
        fap.REDIRECT_URI__c='test rediret url';
        fap.accessToken__c='38u8ue32u20e9ue0329';
        fap.Bearer_Token__c='38u8ue32u20e9ue0329';
        fap.basicUrl__c='htttps//wwwdinciencec';
        fap.businessUserId__c='tttps//wwwdincience';
        fap.Mention__c='mention';
        fap.Auth_Code__c='38u8ue32u20e9ue0329';
        fap.Comment_AccessToken__c='Accesstokentest';
        insert fap;
        
        Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        Case caseRec = new Case();
        caseRec.Post_Id__c = '17841405793087218';
        caseRec.RecordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        caseRec.Description = 'Testing';
        caseRec.Subject = 'Testing';
        caseRec.Created_Time__c='2023-08-08';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id;
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=17841405793087218])])';
        insert postComment;
        
        // Create an instance of the twitterApiResponseWrapper class and populate its data
        twitterApiResponseWrapper responseWrapper = new twitterApiResponseWrapper();
        responseWrapper.meta = new twitterApiResponseWrapper.meta();
        responseWrapper.meta.oldest_id = '123';
        responseWrapper.meta.result_count = 10;
        responseWrapper.meta.newest_id = '456';
        
        twitterApiResponseWrapper.data tweetData = new twitterApiResponseWrapper.data();
        tweetData.text = 'Sample tweet content';
        tweetData.edit_history_tweet_ids = new List<String>{'789', '1011'};
            tweetData.created_at = '2023-08-21T12:34:56.000Z';
        tweetData.id = '12345';
        tweetData.in_reply_to_user_id = '67890';
        tweetData.author_id = '54321';
        responseWrapper.data = new List<twitterApiResponseWrapper.data>{tweetData};
            // Convert the responseWrapper instance to a JSON string
            String jsonRepresentation = JSON.serialize(responseWrapper);
        System.debug(jsonRepresentation);
        
        
        
        Test.startTest();
        // Create and set mock HTTP response here
        // Mock the HttpCalloutMock class for the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to be tested
        twitterApis.getAllMentionsFromTimeLine();
        Test.stopTest();
        
    } 
    
    @isTest
    static void testGetAllCommentsRelatedToTweet() {
         Twitter_Api_Details__c fap  = New Twitter_Api_Details__c();
        fap.CLIENT_ID__c='TEST client id';
        fap.CLIENT_SECRET__c='test clident secret';
        fap.REDIRECT_URI__c='test rediret url';
        fap.accessToken__c='38u8ue32u20e9ue0329';
        fap.Bearer_Token__c='38u8ue32u20e9ue0329';
        fap.basicUrl__c='htttps//wwwdinciencec';
        fap.businessUserId__c='tttps//wwwdincience';
        fap.Mention__c='mention';
        fap.Auth_Code__c='38u8ue32u20e9ue0329';
        fap.Comment_AccessToken__c='Accesstokentest';
        insert fap;
        
        Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        Case caseRec = new Case();
        caseRec.Post_Id__c = '789';
        caseRec.RecordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        caseRec.Description = 'Testing';
        caseRec.Subject = 'Testing';
        caseRec.Created_Time__c='2023-08-08';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id;
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=12345, text=Test Reply 1, username=67890, timeStamp=2023-07-29T12:34:56+0000,Case__c=17841405793087218])])';
        insert postComment;
        
        // Create an instance of the twitterApiResponseWrapper class and populate its data
        twitterApiResponseWrapper responseWrapper = new twitterApiResponseWrapper();
        responseWrapper.meta = new twitterApiResponseWrapper.meta();
        responseWrapper.meta.oldest_id = '123';
        responseWrapper.meta.result_count = 10;
        responseWrapper.meta.newest_id = '456';
        
        twitterApiResponseWrapper.data tweetData = new twitterApiResponseWrapper.data();
        tweetData.text = 'Sample tweet content';
        tweetData.edit_history_tweet_ids = new List<String>{'789', '1011'};
        tweetData.created_at = '2023-08-21T12:34:56.000Z';
        tweetData.id = '12345';
        tweetData.in_reply_to_user_id = '67890';
        tweetData.author_id = '54321';
        responseWrapper.data = new List<twitterApiResponseWrapper.data>{tweetData};
            // Convert the responseWrapper instance to a JSON string
            String jsonRepresentation = JSON.serialize(responseWrapper);
        System.debug(jsonRepresentation);
        
        
        
        Test.startTest();
        // Create and set mock HTTP response here
        // Mock the HttpCalloutMock class for the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to be tested
        twitterApis.getAllCommentsRelatedToTweet('789');
        Test.stopTest();
        
    }
    
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create and return a mock HTTPResponse
            // Simulate a successful response from Twitter's API
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"meta":{"result_count":10,"oldest_id":"123","newest_id":"456"},"data":[{"text":"Sample tweet content","in_reply_to_user_id":"67890","id":"12345","edit_history_tweet_ids":["789","1011"],"created_at":"2023-08-21T12:34:56.000Z","author_id":"54321"}]}');
            
            return res;
        }
        
        
    }
    
}