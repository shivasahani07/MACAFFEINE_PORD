@isTest
public class ManageBatchTestClass {
    @isTest
    static void testBatchExecution() {
        RecordType caseRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Instagram' LIMIT 1];
        List<Post_Comments__c> PostCommentsList = new List<Post_Comments__c>();
        Case testCase = new Case(
            Subject = 'Test Case',
            Origin = 'Instagram',
            RecordTypeId = caseRecordType.Id,
            Post_Id__c = '17841405793087218'
        );
        insert testCase;
        
        for(integer i=0 ; i <= 52 ; i++){
            Post_Comments__c testComment = new Post_Comments__c(Case__c = testCase.Id,Comment__c = 'Test comment',Comment_Id__c = 'test_comment_id_123');    
            PostCommentsList.add(testComment);
        }
        
        insert PostCommentsList;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        DuplicateCommentDeletionBatch batch = new DuplicateCommentDeletionBatch();
        Database.executeBatch(batch);
        
        DuplicateCaseDeletionBatch  batch2 = new DuplicateCaseDeletionBatch();
        Database.executeBatch(batch2);
        
        BatchToManageCommentsSize  batch3 = new BatchToManageCommentsSize();
        Database.executeBatch(batch3);
        
        Test.stopTest();
        
    }
}