@isTest
public class DeleteOldPostCommentBatchTest {
    
    
    private static Id caseRecordTypeId                                       = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    static testMethod void testme1(){
        
        
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Case Description';
        testCase.Post_Id__c = 'asdfghj';
        testcase.Origin = 'Instagram';
        testCase.RecordTypeId = caseRecordTypeId;
        insert testCase;
        
        Post_Comments__c commentRecord = new Post_Comments__c();
        commentRecord.Comment_Id__c = 'TestCommentId';
        commentRecord.Comment__c = 'Test Comment';
        commentRecord.Post_Url__c = 'https://www.example.com/test-post-url';
        commentRecord.Post_comment_Time__c =string.valueof(Datetime.now());
        commentRecord.Case__c = testCase.Id;
        insert commentRecord; 
        
        Test.startTest();
        DeleteOldPostCommentsBatch obj = new DeleteOldPostCommentsBatch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}