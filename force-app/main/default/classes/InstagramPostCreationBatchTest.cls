@isTest
public class InstagramPostCreationBatchTest {
     @isTest
    static void testBatchExecution() {
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
        // Start the batch process
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramPostCreationBatch batch = new InstagramPostCreationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Perform assertions to verify the expected results
        // For example, check if the inserted Case records and Post_Comments__c records are as expected
    }

}