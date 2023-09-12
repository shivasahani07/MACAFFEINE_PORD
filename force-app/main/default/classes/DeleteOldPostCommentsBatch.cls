public class DeleteOldPostCommentsBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    private static Instagram_Api_Details__c fap = Instagram_Api_Details__c.getInstance();
    private static final String CLIENT_ID                                    = fap.CLIENT_ID__c;
    private static String CLIENT_SECRET                                      = fap.CLIENT_SECRET__c;
    private static String REDIRECT_URI                                       = fap.REDIRECT_URI__c;
    private static String accessToken                                        = fap.accessToken__c;
    private static String basicUrl                                           = fap.basicUrl__c;
    private static String businessUserId                                     = fap.businessUserId__c;
    private static List<case> existingCaseList                               = new List<case> ();
    private static List<case> insertedCaseList                               = new List<case>();
    private static List<Post_Comments__c> postCommentList                    = new List<Post_Comments__c>();
    private static List<Post_Comments__c> postCommentListToBeUpdated         = new List<Post_Comments__c>();
    private static List<Id> caseIdsToBeUpdated                               = new List<Id>();
    private static map<String,List<Post_Comments__c>> commentsOnPostByPostId = new map<String,List<Post_Comments__c>>();
    private static map<String,String> caseIdByPostId                         = new map<String,String>();
    private static map<String,String> postCommentIdByPostId                  = new map<String,String>();
    private static map<String,String> caseIdByPostCommentId                  = new map<String,String>();
    List<String> casePostIds                                                 = new List<String>();
    List<Case> ExistingCaseRecords                                           = new List<Case>();
    List<Post_Comments__c> ExistingPostCommRecords                           = new  List<Post_Comments__c>();
    //Getting the record Type Id
    private static Id caseRecordTypeId                                       = Schema.SObjectType.case.getRecordTypeInfosByName().get('Instagram').getRecordTypeId();
    
    public Database.QueryLocator start(Database.BatchableContext context) {
       	ExistingCaseRecords = [Select id,subject,Description,Caption__c,Post_Id__c from case where recordTypeId = :caseRecordTypeId and Origin = 'Instagram' and Deletion_Batch_executed__c = false];
        String query = 'Select Comment__c,Comment_Id__c,case__c,Case__r.Post_Id__c,Commented_By__c,Post_Url__c,Post_comment_Time__c from Post_Comments__c where case__c IN :ExistingCaseRecords ORDER BY Post_comment_Time__c DESC';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<Post_Comments__c> postCommentsList) {
        try {
            List<String> caseToBeUpdated = new List<String>();
            system.debug('postCommentsList'+postCommentsList.size());
            system.debug('ExistingCaseRecords'+ExistingCaseRecords.size());
            List<Id> commentsToDelete = new List<Id>();
            for(Post_Comments__c postCommRec : postCommentsList){
                if(commentsOnPostByPostId.containsKey(postCommRec.Case__c)){
                    commentsOnPostByPostId.get(postCommRec.Case__c).add(postCommRec);
                }else{
                    list<Post_Comments__c> postCommNewList = new list<Post_Comments__c>();
                    postCommNewList.add(postCommRec);
                    commentsOnPostByPostId.put(postCommRec.Case__c,postCommNewList);
                }
            }
            
            for(String keyalue : commentsOnPostByPostId.keyset()){
                caseToBeUpdated.add(keyalue);
                if(commentsOnPostByPostId.get(keyalue).size() > 50){
                    system.debug('commentsOnPostByPostId'+commentsOnPostByPostId.get(keyalue).size());  
                    for (Integer i = 50; i < commentsOnPostByPostId.get(keyalue).size(); i++) {
                        commentsToDelete.add(commentsOnPostByPostId.get(keyalue)[i].Id);
                    }
                }
            }
            system.debug('caseToBeUpdated'+caseToBeUpdated);
            List<Case> caseListToBeUpdated = [Select id , Deletion_Batch_executed__c from case where id in :caseToBeUpdated];
            for(Case casRec : caseListToBeUpdated){
                casRec.Deletion_Batch_executed__c = true;
            }
            update caseListToBeUpdated;
            database.delete(commentsToDelete);
            system.debug('commentsToDelete=======>'+commentsToDelete.size());
        }catch(exception e){
            
        }
        
    }
    
    public void finish(Database.BatchableContext context) {
        
    }
}