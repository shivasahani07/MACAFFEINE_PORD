@isTest
public class DynamicHttpCalloutTest {
    
    // Inner class to implement HttpCalloutMock for GET requests
    private class HttpGetMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Create a mock response
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            response.setBody('{"message": "Mock GET response"}');
            return response;
        }
    }
    
    // Inner class to implement HttpCalloutMock for POST requests
    private class HttpPostMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Create a mock response
            HttpResponse response = new HttpResponse();
            response.setStatusCode(201);
            response.setStatus('Created');
            response.setBody('{"message": "Mock POST response"}');
            return response;
        }
    }
    
    @isTest
    static void testHttpGetCallout() {
        // Set up the test data
        String endpointUrl = 'https://example.com/api/resource';
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer token'};
        
        // Set the mock HTTP callout response
        Test.setMock(HttpCalloutMock.class, new HttpGetMock());
        
        // Make the HTTP GET callout
        HttpResponse response = DynamicHttpCallout.makeHttpGetCallout(endpointUrl, queryParams, headers);
        
        // Verify the response
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('OK', response.getStatus());
        System.assertEquals('{"message": "Mock GET response"}', response.getBody());
    }
    
    @isTest
    static void testHttpPostCallout() {
        // Set up the test data
        String endpointUrl = 'https://example.com/api/resource';
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer token'};
        
        // Set the mock HTTP callout response
        Test.setMock(HttpCalloutMock.class, new HttpPostMock());
        
        // Make the HTTP POST callout
        HttpResponse response = DynamicHttpCallout.makeHttpPostCallout(endpointUrl, queryParams, headers);
        
        // Verify the response
        System.assertEquals(201, response.getStatusCode());
        System.assertEquals('Created', response.getStatus());
        System.assertEquals('{"message": "Mock POST response"}', response.getBody());
    }
    
    @isTest
    static void testHttpDeleteCallout() {
        // Set up the test data
        String endpointUrl = 'https://example.com/api/resource';
        Map<String, String> queryParams = new Map<String, String>();
        Map<String, String> headers = new Map<String, String>{'Authorization' => 'Bearer token'};
        
        // Set the mock HTTP callout response
        Test.setMock(HttpCalloutMock.class, new HttpGetMock());
        
        // Make the HTTP DELETE callout
        HttpResponse response = DynamicHttpCallout.makeHttpDeleteCallout(endpointUrl, queryParams, headers);
        
        // Verify the response
        System.assertEquals(200, response.getStatusCode());
        System.assertEquals('OK', response.getStatus());
        System.assertEquals('{"message": "Mock GET response"}', response.getBody());
    }
}