@isTest
public class InstagramPostCreationBatchTest {
    @isTest
    static void testBatchExecution() {
        RecordType caseRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Social' LIMIT 1];
        Instagram_Api_Details__c fap = new Instagram_Api_Details__c();
        fap.CLIENT_ID__c='bccbckbcewbcje';
        fap.CLIENT_SECRET__c='cbewciuewcw cweu ciw cwucw';
        fap.REDIRECT_URI__c='bcewcbwecwueicwc c iwcw';
        fap.accessToken__c='bxiueqbcubce ccwebcw cuew';
        fap.basicUrl__c='bcwiuecewucwcuew cew cw cweuc';
        fap.businessUserId__c='bcew ciwu ce ce cuec';
        fap.next_Pagination_Post_Token__c='ncencencienciencnecne';
        fap.next_Pagination_Mention_Token__c='uebfbbcuebcebcucbeubcuecue';
        fap.next_pagination_hashtag_Token__c='jciece ci c e ce c';
        fap.HashTag__c='ubcebwcubcuewcubcuewbcbew'; 
        insert fap;
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