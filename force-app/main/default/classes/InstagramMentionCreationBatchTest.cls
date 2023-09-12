@isTest
public class InstagramMentionCreationBatchTest {
     @isTest
    static void testBatchExecution() {
        // Create test data
        RecordType caseRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Instagram' LIMIT 1];

        Case testCase = new Case(
            Subject = 'Test Case',
            Origin = 'Instagram',
            RecordTypeId = caseRecordType.Id,
            Post_Id__c = '17841405793087218'
        );
        insert testCase;

        Post_Comments__c testComment = new Post_Comments__c(
            Case__c = testCase.Id,
            Comment__c = 'Test comment',
            Comment_Id__c = 'test_comment_id_123'
        );
        insert testComment;

        // Start the test
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramMentionCreationBatch batch = new InstagramMentionCreationBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Perform assertions based on the expected behavior
        // For example, you can query and assert the inserted/updated records
        List<Post_Comments__c> postComments = [SELECT Id, Comment_Id__c, Commented_By__c FROM Post_Comments__c];
        List<Case> cases = [SELECT Id, Post_Id__c FROM Case];
       
    }


}