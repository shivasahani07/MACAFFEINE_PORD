@isTest
public class InstagramUtilityTestMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        // Create a mock HTTP response with the expected JSON body
        String jsonResponse = '{ "data": [{"instagram_business_account": { "id": "test_business_user_id" } }] }';
        
        // Create a new HTTP response
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(jsonResponse);
        response.setStatusCode(200);
        
        return response;
    }
    
}