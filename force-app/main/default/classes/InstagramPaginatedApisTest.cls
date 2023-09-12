@isTest 
public class InstagramPaginatedApisTest {
    private static Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Social').getRecordTypeId();
    
    
    @isTest
    static void TestgetNextBatchOfPostsFromInsta(){
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
       
        Case caseRec = new Case();
        caseRec.Post_Id__c = '17841405793087218';
        caseRec.RecordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id; 
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=caseId])])';
        insert postComment;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramPaginatedApis.getNextBatchOfPostsFromInsta();
        Test.stopTest();
        
    }
    
    @isTest
    static void TestgetNextBatchOfMentionsFromInsta(){
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
       
        Case caseRec = new Case();
        caseRec.Post_Id__c = '17841405793087218';
        caseRec.RecordTypeId = caseRecordTypeId;
        caseRec.Origin = 'Instagram';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id; 
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=caseId])])';
        insert postComment;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramPaginatedApis.getNextBatchOfMentionsFromInsta();
        Test.stopTest();
        
    }
    
}