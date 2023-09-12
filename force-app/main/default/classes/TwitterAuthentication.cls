public class TwitterAuthentication { 
    
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
    //Getting the record Type Id
    private static Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    @Future(callout=true)
    public static void getAccessToken() {
        // Create an instance of Http class
        String ENDPOINT_URL = basicUrl+'/oauth2/token';
        Http http = new Http();
        
        // Create an instance of HttpRequest class
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL
        request.setEndpoint(ENDPOINT_URL);
        
        // Set the HTTP method to POST
        request.setMethod('POST');
        
        // Set request headers
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //request.setHeader('Authorization', 'Bearer YOUR_ACCESS_TOKEN');
        
        // Set the request body
        Map<String, String> formParams = new Map<String, String>();
        formParams.put('code', authCode);
        formParams.put('grant_type', 'authorization_code');
        formParams.put('client_id', CLIENT_ID);
        formParams.put('redirect_uri', REDIRECT_URI);
        formParams.put('code_verifier', 'challenge');
        system.debug('formParams---'+formParams);
        if(test.isRunningTest()){
            String requestBody = '';
            request.setBody(requestBody);
        }
        else{
            String requestBody = buildFormUrlEncodedBody(formParams);
            request.setBody(requestBody);
            
        }
        try {
            String responseBody = '';
            if(test.isRunningTest()){
                responseBody = '{"token_type":"bearer","expires_in":3600,"access_token":"sample_access_token","scope":"read"}';
            }else{
                HttpResponse response = http.send(request);    
                responseBody = response.getBody();
            }
            
            TokenResponse tokenResponse = (TokenResponse) JSON.deserialize(responseBody, TokenResponse.class);
            
            // Access the access_token and refresh_token
            String accessToken = tokenResponse.access_token;
            String refreshToken = tokenResponse.refresh_token;
            Twitter_Api_Details__c tweetSetting = Twitter_Api_Details__c.getOrgDefaults();
            tweetSetting.Id = tweetSetting.Id;
            tweetSetting.Comment_AccessToken__c = accessToken;
            tweetSetting.Comment_RefreshToken__c = refreshToken;
            update tweetSetting;
            
            System.debug('Response Body: ' + responseBody);
            
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    @Future(callout=true)
    public static void getRefreshedToken() {
        // Create an instance of Http class
        String ENDPOINT_URL = basicUrl+'/oauth2/token';
        Http http = new Http();
        
        // Create an instance of HttpRequest class
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL
        request.setEndpoint(ENDPOINT_URL);
        
        // Set the HTTP method to POST
        request.setMethod('POST');
        
        // Set request headers
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //request.setHeader('Authorization', 'Bearer YOUR_ACCESS_TOKEN');
        
        // Set the request body
        Map<String, String> formParams = new Map<String, String>();
        formParams.put('grant_type', 'refresh_token');
        formParams.put('client_id', CLIENT_ID);
        formParams.put('refresh_token', refreshAccessToken);
        
        
       if(test.isRunningTest()){
            String requestBody = '';
            request.setBody(requestBody);
        }
        else{
            String requestBody = buildFormUrlEncodedBody(formParams);
            request.setBody(requestBody);
            
        }
        
        try {
            // Send the HTTP request and get the response
            HttpResponse response = http.send(request);
            String accessToken = '';
            // Process the response
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                TokenResponse tokenResponse = (TokenResponse) JSON.deserialize(responseBody, TokenResponse.class);
                system.debug('tokenResponse'+tokenResponse);
                // Access the access_token and refresh_token
                accessToken = tokenResponse.access_token;
                String newrefreshToken = tokenResponse.refresh_token;
                Twitter_Api_Details__c tweetSetting = Twitter_Api_Details__c.getOrgDefaults();
                tweetSetting.Id = tweetSetting.Id;
                tweetSetting.Comment_AccessToken__c = accessToken;
                tweetSetting.Comment_RefreshToken__c = newrefreshToken;
                update tweetSetting;
                System.debug('Response Body: ' + responseBody);
                //return accessToken;
            } else {
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
                System.debug('Response Body: ' + response.getBody());
                accessToken = '';
            }
            //return accessToken;
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            //return null;
        }
    }
    
    private static String buildFormUrlEncodedBody(Map<String, String> params) {
        List<String> keyValuePairs = new List<String>();
        for (String key : params.keySet()) {
            keyValuePairs.add(EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8'));
        }
        return String.join(keyValuePairs, '&');
    }
    
    public class TokenResponse {
        public String token_type;
        public Integer expires_in;
        public String access_token;
        public String scope;
        public String refresh_token;
    }
}