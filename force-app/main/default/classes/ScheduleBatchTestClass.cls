@istest
public class ScheduleBatchTestClass {
 @istest
    public static void  ManageDuplicates() {
        Test.StartTest();
        ScheduleBatchForRemovingDuplicates sh1 = new ScheduleBatchForRemovingDuplicates();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
}