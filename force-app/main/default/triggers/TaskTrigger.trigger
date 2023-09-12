trigger TaskTrigger on Task (before insert) {

    if(Trigger.IsBefore && Trigger.IsInsert){
        TaskTriggerHandler.createCaseRecord(Trigger.New);
    }
}