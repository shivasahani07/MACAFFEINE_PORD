public class DynamicHttpCallout {
    // Method to make a dynamic HTTP GET callout
    public static HttpResponse makeHttpGetCallout(String endpointUrl, Map<String, String> queryParams, Map<String, String> headers) {
        // Construct the full URL with query parameters
        String fullUrl = endpointUrl;
        /*if (queryParams != null && !queryParams.isEmpty()) {
            fullUrl += '?' + String.join(new List<String>(queryParams.keySet()), '&');
        }*/
        system.debug('endpointUrl====>'+endpointUrl);
        
        // Create the HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(fullUrl);
        request.setMethod('GET');
        
        // Add headers if provided
        if (headers != null && !headers.isEmpty()) {
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }
        
        // Create an instance of the HTTP class to send the request
        Http http = new Http();
        HttpResponse response = http.send(request);
        return response;
    }
    
    // Method to make a dynamic HTTP POST callout
    public static HttpResponse makeHttpPOSTCallout(String endpointUrl, Map<String, String> queryParams, Map<String, String> headers) {
        
        String fullUrl = endpointUrl;
        system.debug('headers'+headers); 
        // Create the HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(fullUrl);
        request.setMethod('POST');
        
        // Add headers if provided
        if (headers != null && !headers.isEmpty()) {
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }
        
        // Create an instance of the HTTP class to send the request
        Http http = new Http();
        HttpResponse response = http.send(request);
        return response;
    }
    
    // Method to make a dynamic HTTP DELETE callout
    public static HttpResponse makeHttpDeleteCallout(String endpointUrl, Map<String, String> queryParams, Map<String, String> headers) {
        // Construct the full URL with query parameters
        String fullUrl = endpointUrl;
        if (queryParams != null && !queryParams.isEmpty()) {
            fullUrl += '?' + String.join(new List<String>(queryParams.keySet()), '&');
        }
        // Create the HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(fullUrl);
        request.setMethod('GET');
        
        // Add headers if provided
        if (headers != null && !headers.isEmpty()) {
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }
        
        // Create an instance of the HTTP class to send the request
        Http http = new Http();
        HttpResponse response = http.send(request);
        return response;
    }
    
    
}