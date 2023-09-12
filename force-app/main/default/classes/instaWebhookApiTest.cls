@isTest
private class instaWebhookApiTest {
    public static String WEB_TOKEN = 'EAAKJz6xiZC6gBAEQ7Ub3pazJxFazWFUXEkbp2Hlg0W0EmblRJVhrLLr1WUwL81hqfSxRXJJ8otiGZAyQ66onZBoRFTOqdjZBKioZA5iy55N0rxyZBulbw1XVgu6ktZA0b0vs6uZAFG7SodcyHayN2id8WAktoJejpdCcaTLF9NwV6FkTvizWzYBZC';
    @isTest
    static void testWebhookListener_Comments() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/instaGramAPI/V2/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"entry": [{"changes": [{"field": "comments", "value": {"id": "123", "text": "Test comment"}}]}]}');

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;
        instaWebhookApi.webhookListener();
        Test.stopTest();

        String responseMessage = res.responseBody.toString().substringAfter('"message":"').substringBefore('"}');
        System.assertEquals('Received', responseMessage);
    }

    @isTest
    static void testWebhookListener_Mentions() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/instaGramAPI/V2/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"entry": [{"changes": [{"field": "mentions", "value": {"media_id": "456", "comment_id": "789"}}]}]}');

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;
        instaWebhookApi.webhookListener();
        Test.stopTest();

        String responseMessage = res.responseBody.toString().substringAfter('"message":"').substringBefore('"}');
        System.assertEquals('Received', responseMessage);
    }

    @isTest
    static void testVerify() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/instaGramAPI/V2/';
        req.httpMethod = 'GET';
        req.params.put('hub.verify_token', instaWebhookApiTest.WEB_TOKEN);
        req.params.put('hub.challenge', '12345');

        Test.startTest();
        RestContext.request = req;
        RestContext.response = res;
        Integer challenge = instaWebhookApi.verify();
        Test.stopTest();

        System.assertEquals(12345, challenge);
    }
    
     @isTest
    	static void testGetTimeStamp() {
        Integer timeValue = 1630066655; 
        String formattedDateTime = instaWebhookApi.getTimeStamp(timeValue);
    }

}