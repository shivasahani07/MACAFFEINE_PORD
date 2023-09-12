@isTest
public class TaskTriggerHandlerTest {

    @isTest
    public static void testCreateCaseRecord() {
        // Test data setup
        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        insert testContact;

        Task testTask1 = new Task();
        testTask1.Subject = 'Test Task 1';
        testTask1.WhoId = testContact.Id;
        insert testTask1;

        Task testTask2 = new Task();
        testTask2.Subject = 'Test Task 2';
        testTask2.WhoId = testContact.Id;
        insert testTask2;
    }
}