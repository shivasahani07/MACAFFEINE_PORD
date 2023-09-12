@isTest
private class TestMetaWebhookListener {
    
    @testSetup
    static void setupData() {
        Meta_App_Credentials__c live = new Meta_App_Credentials__c();
        live.Access_Token__c='EAAKJz6xiZC6gBO2KIGlCVpLdEshQfphFxZAEsohWvd4tQ7Oz0l3XEa2Cl7P9V4KlKLF9IpAuXeBzh7YobZC7NCBTLcAuiMEwxMcFSvsaIGzwDh83Hz0dWAZCtpy8jQecKnMZAKziJZBfhHLx0LEWdxXP3LQ23SHcZCNZCcsLXUZCu3kq0ZCVo3T7IesseOZB';
        live.App_Secret__c='c35b532f78fa602cc906d82f83d6ba848j88';
        live.Name='live';
        live.Page_Name__c='Test Salesforce Integration';
        live.Webhook_Token__c='EAAKJz6xiZC6gBAEQ7Ub3pazJxFazWFUXEkbp2Hlg0W0EmblRJVhrLLr1WUwL81hqfSxRXJJ8otiGZAyQ66onZBoRFTOqdjZBKioZA5iy55N0rxyZBulbw1XVgu6ktZA0b0vs6uZAFG7SodcyHayN2id8WAktoJejpdCcaTLF9NwV6FkTvizWzYBZXUNUU';
        live.Source__c='Facebook';
        live.SObject_Record_Type__c='Social';
        live.Owner_Type__c='User';
        live.Owner_Type__c= UserInfo.getUserName();
        insert live;
    }
    
    @isTest
    static void testVerify() {
        //MetaWebhookListener.WEB_TOKEN = 'Your_Test_Web_Token';
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/webhooklistener';
        request.addParameter('hub.verify_token','EAAKJz6xiZC6gBAEQ7Ub3pazJxFazWFUXEkbp2Hlg0W0EmblRJVhrLLr1WUwL81hqfSxRXJJ8otiGZAyQ66onZBoRFTOqdjZBKioZA5iy55N0rxyZBulbw1XVgu6ktZA0b0vs6uZAFG7SodcyHayN2id8WAktoJejpdCcaTLF9NwV6FkTvizWzYBZC' );
        request.addParameter('hub.challenge', '12345');
        RestContext.request = request;
        Integer challenge = MetaWebhookListener.verify();
        // System.assertEquals(12345, challenge);
    }
    
    
    @isTest
    static void testWebhookListener_NewPost() {
        // Test the webhookListener method for a new post scenario
        
        String requestBody = generateNewPostRequestBody(); // Replace this with your actual test data
        string fornewPost='{"entry":[{"id":"103319499517877","time":1690800614,"changes":[{"value":{"from_c":{"id":"103319499517877","name":"Test Salesforce Integration"},"message":"Hi Test post from facebook","post_id":"103319499517877_106857975834754","created_time":1690800612,"item":"status","published":1,"verb":"add"},"field":"feed"}]}],"object":"page"}';
        FBFeedNotificationWrapper.parse(fornewPost);
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/webhooklistener';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(fornewPost);
        
        
        RestResponse response = new RestResponse();
        
        RestContext.request = request;
        RestContext.response = response;
        
        MetaWebhookListener.webhookListener();
        Test.stopTest();
        
        // Assert the response to check if it's as expected
        //stem.assertEquals('application/json', res.getHeader('Content-Type'));
        String responseBody = response.responseBody.toString();
        MetaWebhookListener.ResponseWrapper responseWrapper = (MetaWebhookListener.ResponseWrapper) JSON.deserialize(responseBody, MetaWebhookListener.ResponseWrapper.class);
        //stem.assertEquals('Received', responseWrapper.message);
        // Add more assertions as needed for other response properties
    }
    
    @isTest
    static void testWebhookListener_EditPost() {
        // Test the webhookListener method for a new post scenario
        //insert case with comment id;
        Case existingPost = new Case(
            Type_of_Post__c = 'Post',
            Origin = 'Facebook',
            Subject = 'Existing post',
            Post_Id__c = '103319499517877_106857975834754',
            Description = 'This is an existing post.',
            //RecordTypeId = '0126D000003Koa9QAC' ,// Use the test Record Type Id
            OwnerId = UserInfo.getUserId()
        );
        insert existingPost;
        
        string forEditPost = '{"entry":[{"id":"103319499517877","time_c":1690800614,"changes":[{"value":{"from_c":{"id":"103319499517877","name":"Test Salesforce Integration"},"message":"Hi Test post from facebook","post_id":"103319499517877_106857975834754","created_time":1690800612,"item":"status","published":1,"verb":"edited"},"field":"feed"}]}],"object":"page"}';
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/webhooklistener';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(forEditPost);
        
        RestResponse response = new RestResponse();
        
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        MetaWebhookListener.webhookListener();
        Test.stopTest();
        
    }
    
    @isTest
    static void testWebhookListener_EditComment() {
        // Test the webhookListener method for a new post scenario
        //insert case with comment id;
        Case existingPost = new Case(
            Type_of_Post__c = 'Post',
            Origin = 'Facebook',
            Subject = 'Existing post',
            Post_Id__c = '103319499517877_106857975834754',
            Description = 'This is an existing post.',
            //RecordTypeId = '0126D000003Koa9QAC' ,// Use the test Record Type Id
            OwnerId = UserInfo.getUserId()
            
        );
        insert existingPost;
        Post_Comments__c postComments = new Post_Comments__c();
        postComments.Comment_Id__c='106857975834754_1454793368707778';
        postComments.Comment__c='Hii im test';
        postComments.Case__c=existingPost.id;
        postComments.Post_comment_Time__c='20202';
        insert postComments;
        
        Post_Comments__c postComments2 = new Post_Comments__c();
        postComments2.Comment_Id__c='103319499517877_10685797583';
        postComments2.Comment__c='Hii im test';
        postComments2.Case__c=existingPost.id;
        postComments2.Post_comment_Time__c='20202';
        insert postComments2;
        
        string forEditComment = '{"entry":[{"id":"103319499517877","time":1690801083,"changes":[{"value":{"from_c":{"id":"103319499517877","name":"Test Salesforce Integration"},"post":{"status_type":"mobile_status_update","is_published":true,"updated_time":"2023-07-31T10:58:01+0000","permalink_url":"https://www.facebook.com/permalink.php?story_fbid=pfbid0fh2SCJ4hew2qzPji14prQgm58E6F9ciD8Kpdpn5ojE6JgZaPYjsSM148LbnZwv57l&id=100095316540397","promotion_status":"inactive","id":"103319499517877_106857975834754"},"message":"Comment","post_id":"103319499517877_106857975834754","comment_id":"106857975834754_1454793368707778","created_time":1690801081,"item":"comment","parent_id":"82828828282882","verb":"edited"},"field":"feed"},{"value":{"from_c":{"id":"103319499517877","name":"Test Salesforce Integration"},"post":{"status_type":"mobile_status_update","is_published":true,"updated_time":"2023-07-31T10:58:01+0000","permalink_url":"https://www.facebook.com/permalink.php?story_fbid=pfbid0fh2SCJ4hew2qzPji14prQgm58E6F9ciD8Kpdpn5ojE6JgZaPYjsSM148LbnZwv57l&id=100095316540397","promotion_status":"inactive","id":"103319499517877_106857975834754"},"message":"Comment","post_id":"103319499517877_106857975834754","comment_id":"106857975834754_1454793368707778","created_time":1690801081,"item":"comment","parent_id":"103319499517877_106857975834754","verb":"edited"},"field":"feed"}]}],"object":"page"}}';
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/webhooklistener';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(forEditComment);
        
        RestResponse response = new RestResponse();
        
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        MetaWebhookListener.webhookListener();
        Test.stopTest();
        
    }
    
    @isTest
    static void testWebhookListener_NewComment() {
        
        
        
        // Test the webhookListener method for a new post scenario
        //insert case with comment id;
        Case existingPost = new Case(
            Type_of_Post__c = 'Post',
            Origin = 'Facebook',
            Subject = 'Existing post',
            Post_Id__c = '103319499517877_106857975834754',
            Description = 'This is an existing post.',
            //RecordTypeId = '0126D000003Koa9QAC' ,// Use the test Record Type Id
            OwnerId = UserInfo.getUserId()
        );
        

        insert existingPost;
        
        Case existingPost2 = new Case(
            Type_of_Post__c = 'Post',
            Origin = 'Facebook',
            Subject = 'Existing post',
            Post_Id__c = '107238405785525_125216783987687',
            Description = 'This is an existing post.',
            //RecordTypeId = '0126D000003Koa9QAC' ,// Use the test Record Type Id
            OwnerId = UserInfo.getUserId()
        );
        insert existingPost2;
        
        Post_Comments__c postComments = new Post_Comments__c();
        postComments.Comment_Id__c='82828828282882';
        postComments.Comment__c='Hii im test';
        postComments.Case__c=existingPost.id;
        postComments.Post_comment_Time__c='20202';
        insert postComments;
        
        
        string forNewComment = '{"entry":[{"id":"107238405785525","time_c":1691478064,"changes":[{"value":{"from_c":{"id":"6822112471146374","name":"Shiva Sahani"},"post":{"status_type":"added_video","is_published":true,"updated_time":"2023-08-08T07:01:00+0000","permalink_url":"https://www.facebook.com/letshyphen/posts/125216783987687","promotion_status":"ineligible","id":"107238405785525_125216783987687"},"post_id":"107238405785525_125216783987687","video":"https://scontent.fblr2-2.fna.fbcdn.net/v/t42.4659-2/366008949_24383724284609742_5777682958004971354_n.mp4?_nc_cat=111&ccb=1-7&_nc_sid=73e57b&_nc_ohc=8S4T4M2cBegAX85pa6I&_nc_ht=scontent.fblr2-2.fna&oh=00_AfD3QU-TdhhT9QC4VMEvZIKpn0FIcuhnJGRA4_CWyCKJMA&oe=64D21034","comment_id":"125216783987687_2018220215208649","created_time":1691478060,"item":"comment","parent_id":"107238405785525_125216783987687","verb":"add"},"field":"feed"}]}],"object_c":"page"}}}}';
        
        
        FBPageCommentWrapper.parse(forNewComment);
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/webhooklistener';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(forNewComment);
        
        RestResponse response = new RestResponse();
        
        RestContext.request = request;
        RestContext.response = response;
        
        MetaWebhookListener.webhookListener();
        
        Test.startTest();
       
        forNewComment = '{"entry":[{"id":"107238405785525","time_c":1691478064,"changes":[{"value":{"from_c":{"id":"6822112471146374","name":"Shiva Sahani"},"post":{"status_type":"added_video","is_published":true,"updated_time":"2023-08-08T07:01:00+0000","permalink_url":"https://www.facebook.com/letshyphen/posts/125216783987687","promotion_status":"ineligible","id":"107238405785525_125216783987687"},"post_id":"107238405785525_125216783987687","video":"https://scontent.fblr2-2.fna.fbcdn.net/v/t42.4659-2/366008949_24383724284609742_5777682958004971354_n.mp4?_nc_cat=111&ccb=1-7&_nc_sid=73e57b&_nc_ohc=8S4T4M2cBegAX85pa6I&_nc_ht=scontent.fblr2-2.fna&oh=00_AfD3QU-TdhhT9QC4VMEvZIKpn0FIcuhnJGRA4_CWyCKJMA&oe=64D21034","comment_id":"125216783987687_2018220215208649","created_time":1691478060,"item":"comment","parent_id":"82828828282882","verb":"add"},"field":"feed"}]}],"object_c":"page"}}}}';
        request.requestBody = Blob.valueOf(forNewComment);
        MetaWebhookListener.webhookListener();
        Test.stopTest();
        
        
    }
    
    
    
    @isTest
    static void testWebhookListener_Mention() {
        // Test the webhookListener method for a new post scenario
        //insert case with comment id;
        Case existingPost = new Case(
            Type_of_Post__c = 'Post',
            Origin = 'Facebook',
            Subject = 'Existing post',
            Post_Id__c = '103319499517877_106857975834754',
            Description = 'This is an existing post.',
            // = '0126D000003Koa9QAC' ,// Use the test Record Type Id
            OwnerId = UserInfo.getUserId()
        );
        insert existingPost;
        
        
        string forMeniton = '{"entry":[{"id":"103319499517877","time_c":1690801125,"changes":[{"value":{"from_c":{"id":"103319499517877","name":"Test Salesforce Integration"},"post":{"status_type":"mobile_status_update","is_published":true,"updated_time":"2023-07-31T10:58:43+0000","permalink_url":"https://www.facebook.com/permalink.php?story_fbid=pfbid0fh2SCJ4hew2qzPji14prQgm58E6F9ciD8Kpdpn5ojE6JgZaPYjsSM148LbnZwv57l&id=100095316540397","promotion_status":"inactive","id":"103319499517877_106857975834754"},"message":"Test Salesforce Integration - tagging you","post_id":"103319499517877_106857975834754","comment_id":"106857975834754_155043260896517","created_time":1690801123,"item":"post","parent_id":"103319499517877_106857975834754","verb":"add"},"field":"mention"}]}],"object":"page"}';
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/webhooklistener';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(forMeniton);
        
        RestResponse response = new RestResponse();
        
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        MetaWebhookListener.webhookListener();
        Test.stopTest();
        
    }
    
    
    
    @isTest
    static void testProcessMassage(){
        Case existingPost = new Case(
            Type_of_Post__c = 'Post',
            Origin = 'Facebook',
            Subject = 'Existing post',
            Post_Id__c = '6307588752695992',
            Description = 'This is an existing post.',
            // = '0126D000003Koa9QAC' ,// Use the test Record Type Id
            OwnerId = UserInfo.getUserId()
        );
        insert existingPost;
        
        Post_Comments__c postComments = new Post_Comments__c();
        postComments.Comment_Id__c='6307588752695992';
        postComments.Comment__c='Hii im test';
        postComments.Case__c=existingPost.id;
        postComments.Post_comment_Time__c='20202';
        insert postComments;
        
        string newMessageAttch='{"object_c":"page","entry":[{"id":"103319499517877","time_c":1691598609924,"messaging":[{"sender":{"id":"6307588752695992"},"recipient":{"id":"103319499517877"},"timestamp":1691598609225,"message":{"mid":"m_l4tBfpHRQ_L3tetQEWpKUDkXdhsCETFtIVCp_p1na0c9mm3N8baoaHboUb9Bjk3iQSdFbeHP25kHVKV3RSfbeA","attachments":[{"type":"image","payload":{"url":"https://scontent.xx.fbcdn.net/v/t1.15752-9/364441076_960022621777348_1490944164088415253_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=58c789&_nc_ohc=QqeJl-OaQioAX9T6gzM&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_AdRQ6wfoZC2Rj5SYwFsNZy_CKt-V5rhaMH3tlXhgW-I5NQ&oe=64FB25BC"}},{"type":"image","payload":{"url":"https://scontent.xx.fbcdn.net/v/t1.15752-9/363807297_306623695274269_2814077906410852488_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=58c789&_nc_ohc=lhzSQHvnavkAX-05Qyz&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_AdR6e8CcB2nRAv5NkF3bQ7-NymrekwTquZqAjadkmRsrsg&oe=64FB236F"}}]}}]}]}}';
        FBPageCommentWrapper.parse(newMessageAttch);
        FBMessageWrapper.parse(newMessageAttch);
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/webhooklistener';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(newMessageAttch);
        
        
        RestResponse response = new RestResponse();
        
        RestContext.request = request;
        RestContext.response = response;
        
        MetaWebhookListener.webhookListener();
        
        Test.startTest();
       
        newMessageAttch = '{"object_c":"page","entry":[{"id":"103319499517877","time_c":1691739155189,"messaging":[{"sender":{"id":"6307588752695992"},"recipient":{"id":"103319499517877"},"timestamp":1691739154822,"message":{"mid":"m_xi0pIwRizxp1N7KJVz9bLTkXdhsCETFtIVCp_p1na0dZP_uK8tdISKG9S2pnd2CoHm1AYkHm-FSqakn2-XHTLQ","text":"Hello","reply_to":{"mid":"m_Dw0Jd5Gf4gtnAhqYfHjJVDkXdhsCETFtIVCp_p1na0eiKpmMI6JnqAM0epyYSirECLeuGBIlhXDd8EYdOEEpOg"}}}]}]}}';
        request.requestBody = Blob.valueOf(newMessageAttch);
        MetaWebhookListener.webhookListener();
        Test.stopTest();
        
    }
    
    // Define other test methods for different scenarios (edit post, new comment, etc.)
    
    private static String generateNewPostRequestBody() {
        string fornewPost='{"entry":[{"id":"103319499517877","time":1690800614,"changes":[{"value":{"from":{"id":"103319499517877","name":"Test Salesforce Integration"},"message":"Hi Test post from facebook","post_id":"103319499517877_106857975834754","created_time":1690800612,"item":"status","published":1,"verb":"add"},"field":"feed"}]}],"object":"page"}';
        return fornewPost;
    }
    
    
    
    
}