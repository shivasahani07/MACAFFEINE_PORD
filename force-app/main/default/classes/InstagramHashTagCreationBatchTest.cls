@isTest
public class InstagramHashTagCreationBatchTest {
  @isTest
    static void testBatchExecution() {
        // Create test data
        RecordType caseRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Instagram' LIMIT 1];

        // Create a test case record
        Case testCase = new Case(
            Subject = 'Test Case',
            Origin = 'Instagram',
            RecordTypeId = caseRecordType.Id,
            Post_Id__c = '17841405793087218'
        );
        insert testCase;
        
       	Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= testCase.Id;
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=caseId])])';
        insert postComment;

        // Start the test
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramHashTagCreationBatch batch = new InstagramHashTagCreationBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Perform assertions based on the expected behavior
        // For example, you can query and assert the inserted/updated records
       // List<Case> casesWithHashTag = [SELECT Id, HashTags__c FROM Case WHERE Id = :testCase.Id];
       
    }

}