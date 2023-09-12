public class ScheduleBatchForRemovingDuplicates  implements schedulable{
    public void execute(SchedulableContext sc){
        DuplicateCommentDeletionBatch DuplicateComments = new DuplicateCommentDeletionBatch();
        Database.executeBatch(DuplicateComments);
        
        DuplicateCaseDeletionBatch DuplicateCases       = new DuplicateCaseDeletionBatch();
        Database.executeBatch(DuplicateComments);
        
        BatchToManageCommentsSize CasesWithHighComments     = new BatchToManageCommentsSize();
        Database.executeBatch(CasesWithHighComments);
    }
}