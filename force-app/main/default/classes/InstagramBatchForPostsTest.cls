@isTest
public class InstagramBatchForPostsTest {
    private static Id caseRecordTypeId                                       = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    static testMethod void testme1(){
        
       
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Case Description';
        testCase.Post_Id__c = 'asdfghj';
        insert testCase;
        
        // Create a test Post_Comments__c record associated with the Case
        Post_Comments__c commentRecord = new Post_Comments__c();
        commentRecord.Comment_Id__c = 'TestCommentId';
        commentRecord.Comment__c = 'Test Comment';
        commentRecord.Post_Url__c = 'https://www.example.com/test-post-url';
        commentRecord.Post_comment_Time__c =string.valueof(Datetime.now());
        commentRecord.Case__c = testCase.Id;
        insert commentRecord; 
        
        Case caseRec = new Case();
        caseRec.Post_Id__c = '17841405793087218';
        caseRec.recordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c();
        postComment.Case__c= caserec.Id;
        postComment.Comment_Id__c = 'Post_Id__c';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=caseId])])';
        insert postComment;
        
        
      
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramPostCreationBatch obj = new InstagramPostCreationBatch();
        DataBase.executeBatch(obj); 
      
        Test.stopTest();
        
      
        
    }
}