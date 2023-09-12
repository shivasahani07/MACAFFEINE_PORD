public class TaskTriggerHandler {
    
    Public Static Void createCaseRecord(List<Task> taskList){
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id,Case> conIDCaseMap= new Map<Id,Case>();
        List<Case> updatedCaseList = new List<Case>();
        for(Task objTask:taskList){ 
            if(objTask.WhoId!=null){
                Schema.SObjectType idType = objTask.WhoId.getSObjectType();    // Check the ID type against specific SObject types
                if (idType == Schema.Contact.SObjectType) {
                   contactIdSet.add(objTask.WhoId);
                }   
            } 
        }
        Map<id,Contact> conEmailMap = new Map<id,Contact>();
        List<Contact> conList = [SELECT Id,Email,(SELECT Id,Subject,CreatedDate  FROM Cases Order by CreatedDate DESC LIMIT 1) FROM Contact WHERE ID IN:contactIdSet];
        for(Contact objCon:conList){
            conEmailMap.put(objCon.Id, objCon);
            if(objCon.Cases.size() > 0){
                conIDCaseMap.put(objCon.Id, objCon.Cases[0]);
            }else{
                conIDCaseMap.put(objCon.Id, null);
            }   
        }    
        for(Task objTask : taskList){  
            if(objTask.WhoId!= null && (conIDCaseMap.get(objTask.WhoId)== null || (conIDCaseMap.get(objTask.WhoId)!= null 
               && conIDCaseMap.get(objTask.WhoId).CreatedDate.addDays(7) <System.today()))){
                   Case objCase = new Case();
                   objCase.Subject =objTask.Subject;
                   objCase.Priority ='High';
                   objCase.ContactId = objTask.WhoId;
                   objCase.Status = 'New';
                   objCase.Origin = 'Connect';
                   objCase.Brand__c	='Hyphen';
                   if(conEmailMap.get(objTask.WhoId)!=null && conEmailMap.get(objTask.WhoId).Email!=null){
                   objCase.SuppliedEmail = conEmailMap.get(objTask.WhoId).Email;
                   }
                   updatedCaseList.add(objCase);
               }
            else{
                if(conIDCaseMap!=null && conIDCaseMap.get(objTask.WhoId)!=null){
                conIDCaseMap.get(objTask.WhoId).Status='Open';
                updatedCaseList.add(conIDCaseMap.get(objTask.WhoId));
                }
                
            }
        }
        if(updatedCaseList!=null && updatedCaseList.size()>0){
            upsert updatedCaseList;
        }
    }
}