@isTest
public class twitterCompControllerTest {
    @isTest
    static void testGetCaseDetails() {
        // Create test data
        Case testCase = new Case(
            Subject = 'Test Case',
            Description = 'Test Description',
            Post_Url__c = 'https://twitter.com/letshyphen/status/12345'
        );
        insert testCase;
        Post_Comments__c testComment = new Post_Comments__c(
            Comment__c = 'Test Comment',
            Commented_By__c = 'Test User',
            Post_Url__c = 'https://twitter.com/letshyphen/status/12345',
            Post_comment_Time__c = String.valueOf(DateTime.now()),
            Case__c = testCase.Id
        );
        insert testComment;
        // Call the method to test
        List<twitterCompController.twitterWrapper> result = twitterCompController.getCaseDetails(testCase.Id);
        
        
    }
    
    @isTest
    static void testReplyToTweetOnTwittter() {
        // Create test data
        Case testCase = new Case(
            Subject = 'Test Case',
            Post_Id__c = '12345'
        );
        insert testCase;
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to test
        String result = twitterCompController.replyToTweetOnTwittter(testCase.Id, 'Test Reply');
        
        // Assert the result
        System.assertEquals('Success', result);
    }
    
    // Mock HTTP response generator
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"message": "Tweet replied successfully"}');
            return res;
        }
    }
    
}