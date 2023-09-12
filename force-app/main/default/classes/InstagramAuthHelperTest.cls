@isTest
public class InstagramAuthHelperTest {
    private static Id caseRecordTypeId                  = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    /*static testmethod void testsample(){  
        Case caseRec = new Case();
        caseRec.Post_Id__c = 'tweetId';
        insert caserec;
        
        Post_Comments__c postComment = new Post_Comments__c(); 
        postComment.Case__c= caserec.Id;
        postComment.Comment_Id__c = 'commentId';
        postComment.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=caseId])])';
        insert postComment;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramAuthHelper.getAllPostsFromInstaForUserId();
        Test.stopTest();
    }*/
    static testmethod void testsample2(){  
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
        
        //String mockResponseJson = '{"data": [{"Id": "12345", "username": "testuser", "caption": "Test caption", "permalink": "https://www.instagram.com/p/12345", "timestamp": "2023-08-04T12:34:56+0000", "comments": {"data": [{"Id": "c1", "username": "user1", "text": "Comment 1", "replies": []}, {"Id": "c2", "username": "user2", "text": "Comment 2", "replies": [{"text": "Reply to Comment 2", "username": "user3", "timestamp": "2023-08-04T12:35:00+0000"}]}]}}]}';
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramAuthHelper.getAllPostsFromInstaForUserId();
        Test.stopTest();
    }
    
    static testmethod void getHashtagIdFromInsta_test(){  
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramAuthHelper.getHashtagIdFromInsta('INSTA');
        Test.stopTest();
    }
    
    static testmethod void getPostDetailsByHashTagId_test(){  
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        InstagramAuthHelper.getPostDetailsByHashTagId('INSTA');
        Test.stopTest();
    }
    
    
    @isTest
    static void testGetAllMentionsFromInstaForUserId() {
        String mockResponseJson = '{"data": [{"Id": "12345", "username": "testuser", "caption": "Test caption", "permalink": "https://www.instagram.com/p/12345", "timestamp": "2023-08-04T12:34:56+0000", "comments": {"data": [{"Id": "c1", "username": "user1", "text": "Comment 1", "replies": []}, {"Id": "c2", "username": "user2", "text": "Comment 2", "replies": [{"text": "Reply to Comment 2", "username": "user3", "timestamp": "2023-08-04T12:35:00+0000"}]}]}}]}';
        Test.setMock(HttpCalloutMock.class, new InstagramAuthHelperTestMockTest());
        Case testCase = new Case(
            Subject = 'Test Case',
            Description = 'Test description',
            Post_Id__c = '12345',
            Origin = 'Instagram',
            recordtypeId = caseRecordTypeId // Make sure to use an actual Record Type Id
        );
        insert testCase;
        
        Test.startTest();
        InstagramAuthHelper.getAllMentionsFromInstaForUserId();
        Test.stopTest();
        
    }
}