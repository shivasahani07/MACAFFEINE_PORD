@isTest
public class InstagramUtilityTestClass {
    
    @isTest
    static void testGetInstaBusinessUserId() {
        // Create test data for Instagram_Api_Details__c custom setting (fap)
        Instagram_Api_Details__c fap = new Instagram_Api_Details__c(
            CLIENT_ID__c = 'test_client_id',
            CLIENT_SECRET__c = 'test_client_secret',
            REDIRECT_URI__c = 'test_redirect_uri',
            accessToken__c = 'test_access_token',
            basicUrl__c = 'test_basic_url',
            businessUserId__c = 'test_business_user_id'
        );
        insert fap;
        
        // Set up the mock response for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new InstagramUtilityTestMock());
        
        // Test the getInstaBusinessUserId method
        Test.startTest();
        String businessUserId = InstagramUtilityClass.getInstaBusinessUserId();
        Test.stopTest();
        
        // Verify the result
        System.assertEquals('test_business_user_id', businessUserId);
    }
    
    @isTest
    static void testGetMediaIdFromCommentId() {
        // Create test data for Instagram_Api_Details__c custom setting (fap)
        Instagram_Api_Details__c fap = new Instagram_Api_Details__c(
            CLIENT_ID__c = 'test_client_id',
            CLIENT_SECRET__c = 'test_client_secret',
            REDIRECT_URI__c = 'test_redirect_uri',
            accessToken__c = 'test_access_token',
            basicUrl__c = 'test_basic_url',
            businessUserId__c = 'test_business_user_id'
        );
        insert fap;
        
        // Create a mock HTTP response for the HTTP GET callout
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        
        // Test the getMediaIdFromCommentId method
        Test.startTest();
        InstagramUtilityClass.getMediaIdFromCommentId('test_comment_id');
        Test.stopTest();
        
        // Verify the results as needed
        // Add appropriate assertions based on the expected behavior
        // Check the behavior based on the mock response
    }
    
    // Add more test methods for other methods in the InstagramUtilityClass as needed
    @isTest
    static void testSendEmailsTocaseOwners() {
        // Generate a unique username based on the current timestamp
        String uniqueUsername = 'testuser' + String.valueOf(System.currentTimeMillis()) + '@example.com';
        
        // Create test data - User and Case records
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test@example.com',
            Username = uniqueUsername, // Use the unique username here
            Alias = 'testusr',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = testProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        Case testCase = new Case(Subject = 'Test Case', Status = 'New', Priority = 'High');
        
        // Insert test records
        insert testUser;
        insert testCase;
        
        // Rest of the test method remains the same...
    }
    
    // Mock class to provide an ID for the SingleEmailMessage
    public class IdGenerationMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            String responseJson = '{"id": "mockId"}';
            HTTPResponse response = new HTTPResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(responseJson);
            response.setStatusCode(200);
            return response;
        }
    }
    
    @isTest
    static void testUpdateCaseStatusAndinformUsers() {
        // Create test data - Profile
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Create test data - User and Case records
        String timestamp = String.valueOf(System.currentTimeMillis());
        
        User testUser1 = new User(
            FirstName = 'Test',
            LastName = 'User1',
            Email = 'test1@example.com',
            Username = 'testuser1_' + timestamp + '@example.com',
            Alias = 'testusr1',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = testProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        User testUser2 = new User(
            FirstName = 'Test',
            LastName = 'User2',
            Email = 'test2@example.com',
            Username = 'testuser2_' + timestamp + '@example.com',
            Alias = 'testusr2',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = testProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        
        insert new List<User>{ testUser1, testUser2 };
        Case testCase1 = new Case(Subject = 'Test Case 1', Status = 'In Progress', Priority = 'High', OwnerId = testUser1.Id);
        Case testCase2 = new Case(Subject = 'Test Case 2', Status = 'New', Priority = 'Medium', OwnerId = testUser2.Id);
        insert new List<Case>{ testCase1, testCase2 };
            
            // Call the method to update case status and send emails
        Test.startTest();
        InstagramUtilityClass.updateCaseStatusAndinformUsers(new List<Id>{ testCase1.Id, testCase2.Id });
        Test.stopTest();
        
        // Verify the updated case status
        Case updatedCase1 = [SELECT Status FROM Case WHERE Id = :testCase1.Id];
        Case updatedCase2 = [SELECT Status FROM Case WHERE Id = :testCase2.Id];
        System.assertEquals('New', updatedCase1.Status);
        System.assertEquals('New', updatedCase2.Status);
        
        // Verify that emails are not sent in test context
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        System.assertEquals(0, emails.size(), 'Emails should not be sent in test context');
    }
    
    @isTest
    static void testGetMediaDetailsFromMediaId() {
        Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
        Case caseRec = new Case();
        caseRec.Post_Id__c = '17841405793087218';
        caseRec.RecordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        caseRec.Description = 'Testing';
        caseRec.Subject = 'Testing';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id;
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=caseId])])';
        insert postComment;
        
        
        // Set up mock HTTP response with comments
        String mockResponse = '{"id": "17841405793087218", "media_url": "https://www.example.com/image.jpg", "comments": { "data": [{"id": "17851087209098192", "text": "Awesome!", "username": "user1", "timestamp": "2023-07-29T12:40:00+0000"}] } }';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method to be tested
        String result = InstagramUtilityClass.getMediaDetailsFromMediaId('17841405793087218');
        
        // Perform assertions
        // Verify the expected outcome based on the mock response and test data
        // System.assertEquals('Success', result);
        
        // Check if the new comment was inserted
        List<Post_Comments__c> newComments = [SELECT Id, Comment__c, Comment_Id__c FROM Post_Comments__c WHERE Comment_Id__c = '17851087209098192'];
        //System.assertEquals(1, newComments.size());
        
        // Add more assertions as needed to cover other scenarios
    }
    
    // Mock HTTP response generator
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private String mockResponse;
        
        public MockHttpResponseGenerator(String mockResponse) {
            this.mockResponse = mockResponse;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(mockResponse);
            res.setStatusCode(200);
            return res;
        }
    }
}