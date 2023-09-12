trigger CaseTrigger on Case (before insert,after update,before update) {
    if (trigger.isBefore && trigger.isInsert){
        CaseTriggerHandler.assignCaseUsingRoundRobin(Trigger.New);
        CaseTriggerHandler.updateCasePriority(Trigger.New);
        CaseTriggerHandler.updateCaseContact(Trigger.New);
    }
    if (trigger.isBefore && trigger.isUpdate){
        CaseTriggerHandler.assignCaseUsingRoundRobin(Trigger.New);
       // CaseTriggerHandler.updateCasePriority(Trigger.New);
    }
}