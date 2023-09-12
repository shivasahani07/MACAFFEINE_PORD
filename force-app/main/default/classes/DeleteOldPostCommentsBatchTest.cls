@isTest
public class DeleteOldPostCommentsBatchTest {
    @isTest static void testBatch() {
        // Create test Case records
        List<Case> testCases = new List<Case>();
        for (Integer i = 0; i < 2; i++) { // Create enough cases to cover one batch
            testCases.add(new Case(Status = 'New', 
                                   Subject = 'Test Case',
                                   Description = 'Test Case Description',
                                   Post_Id__c = 'asdfghj',
                                   Origin = 'Instagram'));
        }
        insert testCases;

        // Create test Post_Comments__c records associated with the test Case records
        List<Post_Comments__c> testComments = new List<Post_Comments__c>();
        for (Case testCase : testCases) {
            for (Integer i = 0; i < 70; i++) {
                testComments.add(new Post_Comments__c(Case__c = testCase.Id));
            }
        }
        insert testComments;

        Test.startTest();

        // Instantiate and execute the batch class
        DeleteOldPostCommentsBatch batchClass = new DeleteOldPostCommentsBatch();
        Database.executeBatch(batchClass);

        Test.stopTest();

        // Query to verify that only 50 comments remain for each Case
        List<Case> updatedCases = [SELECT Id, (SELECT Id FROM Post_Comments__r) FROM Case WHERE Id IN :testCases];

        // Verify that only 50 comments remain for each Case
        for (Case updatedCase : updatedCases) {
            System.assertEquals(50, updatedCase.Post_Comments__r.size(), 'More than 50 comments remain for Case');
        }
    }

}