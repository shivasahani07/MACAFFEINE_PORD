public class DuplicateCommentDeletionBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    List<Post_Comments__c> ExistingPostCommentRecords = new List<Post_Comments__c>();
    private static Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String origin = 'Instagram';
        String query = 'Select Comment__c,Comment_Id__c,case__c,Case__r.Post_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__c';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<Post_Comments__c> postCommentRecordsList) {
        for(Post_Comments__c postCommRec : postCommentRecordsList){
            ExistingPostCommentRecords.add(postCommRec);
        }
    }
    
    public void finish(Database.BatchableContext context){
        system.debug('ExistingPostCommentRecords'+ExistingPostCommentRecords.size());
        Map<String,Id> commentIdToPostCommentIdMap = new Map<String,Id>();
        for (Post_Comments__c caseRecord : ExistingPostCommentRecords) {
            commentIdToPostCommentIdMap.put(caseRecord.Comment_Id__c, caseRecord.Id);
        }
        
        List<Id> commentsToDelete = new List<Id>();
        for (Post_Comments__c commRecord : ExistingPostCommentRecords) {
            if (commRecord.Id != commentIdToPostCommentIdMap.get(commRecord.Comment_Id__c)) {
                commentsToDelete.add(commRecord.Id);
            }
        }
        system.debug('commentsToDelete'+commentsToDelete.size());
        if (!commentsToDelete.isEmpty()) {
            delete [SELECT Id FROM Post_Comments__c WHERE Id IN :commentsToDelete];
        }
    }
}