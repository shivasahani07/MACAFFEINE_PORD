@isTest
public class FBAuthControllerTest {
    @TestSetup
    static void setupTestData() {
        Meta_App_Credentials__c live = new Meta_App_Credentials__c();
        live.App_Id__c = 'asdasdasddas';
        live.Redirect_URI__c = 'https://www.sfdc.com/call_back';
        live.Access_Token__c='EAAKJz6xiZC6gBO2KIGlCVpLdEshQfphFxZAEsohWvd4tQ7Oz0l3XEa2Cl7P9V4KlKLF9IpAuXeBzh7YobZC7NCBTLcAuiMEwxMcFSvsaIGzwDh83Hz0dWAZCtpy8jQecKnMZAKziJZBfhHLx0LEWdxXP3LQ23SHcZCNZCcsLXUZCu3kq0ZCVo3T7IesseOZB';
        live.App_Secret__c='c35b532f78fa602cc906d82f83d6ba848j88';
        live.Name='live';
        live.Page_Name__c='Test Salesforce Integration';
        live.Webhook_Token__c='EAAKJz6xiZC6gBAEQ7Ub3pazJxFazWFUXEkbp2Hlg0W0EmblRJVhrLLr1WUwL81hqfSxRXJJ8otiGZAyQ66onZBoRFTOqdjZBKioZA5iy55N0rxyZBulbw1XVgu6ktZA0b0vs6uZAFG7SodcyHayN2id8WAktoJejpdCcaTLF9NwV6FkTvizWzYBZXUNUU';
        live.Source__c='Facebook';
        live.SObject_Record_Type__c='Social';
        live.Owner_Type__c='User';
        insert live;
    }
    
    @isTest
    static void testGetUserAccessToken() {
        String code = 'ncieiceineene';
        Test.setMock(HttpCalloutMock.class, new FacebookLoginMock('token'));
        Test.startTest();
        String accessToken = FBAuthController.getUserAccessToken(code);
        Test.stopTest();
        // Add assertions to verify the accessToken
        //System.assertNotEquals(null, accessToken, 'Access token should not be null');
        // Additional assertions here
    }
    
    @isTest
    static void testgetAppAccessToken() {
        // Call the FBAuthController.getAppAccessToken() method and perform assertions on the returned app access token
        
        Test.startTest();
        string accesstoken=FBAuthController.getAppAccessToken();
        Test.stopTest();
    }
    
    @isTest
    static void testPostCommentToFB() {
        Test.setMock(HttpCalloutMock.class, new FacebookLoginMock('page_token'));
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;
        Test.startTest();
        FBAuthController.postCommentToFB(testCase.Id, 'Post123', 'Parent456', 'Test comment');
        Test.stopTest();
        // Add assertions to verify the behavior of postCommentToFB
        // For example, verify inserted records or log messages
    }
    
    @isTest
    static void testGetCaseDetails() {
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;
        Post_Comments__c postComments = new Post_Comments__c();
        postComments.Comment_Id__c='106857975834754_1454793368707778';
        postComments.Comment__c='Hii im test';
        postComments.Case__c=testCase.id;
        postComments.Post_comment_Time__c='20202';
        insert postComments;
        Test.startTest();
        FBAuthController.getCaseDetails(testCase.Id);
        Test.stopTest();
        // Add assertions to verify the behavior of getCaseDetails
        // For example, verify the data returned by the method
    }
    
    @isTest
    static void testSubscribeToPageWebhook_Success() {
        // Set up mock HTTP response with a success status code (200)
        Test.setMock(HttpCalloutMock.class, new FacebookLoginMock('page_token'));
        
        // Call the method to be tested
        Test.startTest();
        FBAuthController.subscribeToPageWebhook(); // Replace YourClass with the actual class name
        Test.stopTest();
        
        // Verify the results
        //List<Log__c> logs = [SELECT Id, Message__c FROM Log__c];
        // System.assertEquals(1, logs.size());
        // System.assertEquals('Webhook subscription successful!', logs[0].Message__c);
    }
    
    @isTest
    static void testGetRepliesDetails() {
        Test.startTest();
        string times = string.valueOfGmt(system.now());
        Case existingPost = new Case(
            Type_of_Post__c = 'Post',
            Origin = 'Facebook',
            Subject = 'Existing post',
            Post_Id__c = '103319499517877_106857975834754',
            Description = 'This is an existing post.',
            OwnerId = UserInfo.getUserId()
        );
        insert existingPost;
        // Create a parent comment
        Post_Comments__c parentComment = new Post_Comments__c(
            Comment__c = 'Parent Comment',
            Comment_Id__c = 'parent123',
            Commented_By__c = 'User1',
            Post_Url__c = 'https://example.com/post/123',
            Post_Comment_Time__c ='times',
            Parent_Comment__c = null ,
            Case__c=existingPost.id
            // Parent comment has no parent
        );
        insert parentComment;
        
        // Create child comments (replies)
        List<Post_Comments__c> childComments = new List<Post_Comments__c>{
            new Post_Comments__c(
                Comment__c = 'Reply 1',
                Comment_Id__c = 'reply1',
                Commented_By__c = 'User2',
                Post_Url__c = 'https://example.com/post/123',
                //Post_Comment_Time__c ='times',
                Case__c=existingPost.id,
                Parent_Comment__c = parentComment.Id
            ),
                new Post_Comments__c(
                    Comment__c = 'Reply 2',
                    Comment_Id__c = 'reply2',
                    Commented_By__c = 'User3',
                    Post_Url__c = 'https://example.com/post/123',
                    //Post_Comment_Time__c ='times',
                    Case__c=existingPost.id,
                    Parent_Comment__c = parentComment.Id
                )
                };
                    insert childComments;
        
        
        // Call the method to be tested
        List<FBAuthController.RepledPostComments> repliesList = FBAuthController.getRepliesDetails(parentComment.Comment_Id__c);
        Test.stopTest();
        // Verify the results
        
        // Add more assertions to verify the structure and content of the repliesList
        
        
        // ... Add more assertions for other fields ...
    }
    
    
    
    
    // Mock class for simulating HTTP callouts
    class FacebookLoginMock implements HttpCalloutMock {
        
        String endpoint;
        
        public FacebookLoginMock(String endPoint) {
            this.endpoint = endPoint;
        }
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            
            if (req.getEndpoint().containsIgnoreCase('accounts')) {
                res.setBody('{"data":[{"access_token":"EAAKJz6xiZC6gBO1rQnXmAMvnfa6rhdylyAldc3EPGqsvsScpsAe8ZBvEu0QrfxwMZBTSgANwq1vpp9BLXIrwbhGbl0cZBX9b3RormsspVZBBaDXWHaKAIYNF4iilwZAbtfDb1IZB8a8ORjyXRjCLCiPZAZAI8FJ50rfMgdzQWXyLWu6sp8fbUaKcUViPboZBLlnvcNJ5ZChLo2iOwgcx3pSnzZCwwyIZD","category":"E-commerce website","category_list":[{"id":"1756049968005436","name":"E-commerce website"}],"name":"Test Salesforce Integration","id":"103319499517877","tasks":["ADVERTISE","ANALYZE","CREATE_CONTENT","MESSAGING","MODERATE","MANAGE"]}],"paging":{"cursors":{"before":"QVFIUkxlbTNqOWRycENrUkJFd0JrREI5enpiRnoyMjI3VU04M2pQcVp3Wk4wdWNlTVF6bXNQOTlkRGp2djgtSmlWNHJsa1JHYTlYVDVEeVFEeFZAwb1daYktn","after":"QVFIUml1RjlOSmtCR1Myc1pST2hKcFZAFMk1yRC1MdUhhZAHIwTzgydjFzbWs2TG1abWxKMXZA5c09kcEpQdnROZATVGcDQ5VzYyQlliODc4MnRqa25fa1diejhB"}}}');
            }else if (req.getEndpoint().containsIgnoreCase('comments')) {
                res.setBody('{"data":[{"access_token":"EAAKJz6xiZC6gBO1rQnXmAMvnfa6rhdylyAldc3EPGqsvsScpsAe8ZBvEu0QrfxwMZBTSgANwq1vpp9BLXIrwbhGbl0cZBX9b3RormsspVZBBaDXWHaKAIYNF4iilwZAbtfDb1IZB8a8ORjyXRjCLCiPZAZAI8FJ50rfMgdzQWXyLWu6sp8fbUaKcUViPboZBLlnvcNJ5ZChLo2iOwgcx3pSnzZCwwyIZD","category":"E-commerce website","category_list":[{"id":"1756049968005436","name":"E-commerce website"}],"name":"Test Salesforce Integration","id":"103319499517877","tasks":["ADVERTISE","ANALYZE","CREATE_CONTENT","MESSAGING","MODERATE","MANAGE"]}],"paging":{"cursors":{"before":"QVFIUkxlbTNqOWRycENrUkJFd0JrREI5enpiRnoyMjI3VU04M2pQcVp3Wk4wdWNlTVF6bXNQOTlkRGp2djgtSmlWNHJsa1JHYTlYVDVEeVFEeFZAwb1daYktn","after":"QVFIUml1RjlOSmtCR1Myc1pST2hKcFZAFMk1yRC1MdUhhZAHIwTzgydjFzbWs2TG1abWxKMXZA5c09kcEpQdnROZATVGcDQ5VzYyQlliODc4MnRqa25fa1diejhB"}}}');
            }else if(req.getEndpoint().containsIgnoreCase('messages')){
                res.setBody('{"message_id":"asdklaskldalskdjlajdasd"}');
            }else{
                res.setBody('{"key":"@#$@#%@%^"}');
            }
            
            return res;
        }
    }
    
    // Mock class for simulating HTTP response
    private class MockHttpResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"success": true}');
            return res;
        }
    }
    
    @isTest
    static void testsendMessage(){
        Test.setMock(HttpCalloutMock.class, new FacebookLoginMock('sendm'));
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;
        Post_Comments__c postComments = new Post_Comments__c();
        postComments.Comment_Id__c='106857975834754_1454793368707778';
        postComments.Comment__c='Hii im test';
        postComments.Case__c=testCase.id;
        postComments.Post_comment_Time__c='20202';
        insert postComments;
        Test.startTest();
        FBAuthController.sendMessage('Post123', 'Test comment', testCase.Id,  postComments.id);
        Test.stopTest();
    }
    
}