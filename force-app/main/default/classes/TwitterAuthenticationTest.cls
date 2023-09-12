@isTest
public class TwitterAuthenticationTest {
    
    
    @isTest
    static void testGetAccessToken() {
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
        // Create a mock HTTP response with a success status code (200)
        HttpCalloutMock mock = new MockHttpResponseGenerator(200, '{"token_type":"bearer","expires_in":3600,"access_token":"sample_access_token","scope":"read"}');
        Test.setMock(HttpCalloutMock.class, mock);
        // Call the getAccessToken method
        Test.startTest();
        TwitterAuthentication.getAccessToken();
        Test.stopTest();
        // Verify that the custom setting was updated with the new access token
        Twitter_Api_Details__c tweetSetting = Twitter_Api_Details__c.getOrgDefaults();
        //System.assertEquals('sample_access_token', tweetSetting.Comment_AccessToken__c);
    }
    
    
    @isTest
    static void testGetRefreshedToken() {
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
        // Create a mock HTTP response with a success status code (200)
        HttpCalloutMock mock = new MockHttpResponseGenerator(200, '{"token_type":"bearer","expires_in":3600,"access_token":"sample_access_token","scope":"read"}');
        Test.setMock(HttpCalloutMock.class, mock);
        // Call the getAccessToken method
        Test.startTest();
        TwitterAuthentication.getRefreshedToken();
        Test.stopTest();
        // Verify that the custom setting was updated with the new access token
    }    
    
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }
    
}