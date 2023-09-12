@isTest
public class CaseTriggerHandlerTest {

    @isTest
    public static void testAssignCaseUsingRoundRobin() {
        // Test data setup
        List<Case> caseList = new List<Case>();
        // Add test cases to the caseList, make sure to set the Origin field appropriately.

        // Create Queue groups and add GroupMembers as needed for test coverage
        Group emailsQueue = new Group(Name='Emails Team',DeveloperName = 'Emails_Team', Type = 'Queue');
        Group socialQueue = new Group(Name='Social Media Team',DeveloperName = 'Social_Media_Team', Type = 'Queue');
        //insert new List<Group>{emailsQueue, socialQueue};

        // Create Case_Round_Robin_Assignment__c records and assign user indexes
        Case_Round_Robin_Assignment__c emailsCRR = new Case_Round_Robin_Assignment__c(Name = 'Emails_Team', User_Index__c = 0);
        Case_Round_Robin_Assignment__c socialCRR = new Case_Round_Robin_Assignment__c(Name = 'Social_Media_Team', User_Index__c = 0);
        insert new List<Case_Round_Robin_Assignment__c>{emailsCRR, socialCRR};

        // Call the method to be tested
        Case objcase= new Case();
        objcase.Subject='Test Subject';
        objcase.Status ='Open';
        objcase.Origin ='Email';
        objcase.Ticket_Source__c='Email';
        objcase.SuppliedEmail ='prashik.lokhande@techilaservices.com';
        insert objcase;
        caseList.add(objcase);
        Test.startTest();
        //CaseTriggerHandler.assignCaseUsingRoundRobin(caseList);
        Test.stopTest();
    }
     @isTest
    public static void testCaseSecond() {
        List<Case> caseList = new List<Case>();
        // Call the method to be tested
        Case objcase= new Case();
        objcase.Subject='New customer message on';
        objcase.Status ='Open';
        objcase.Origin ='Email';
        objcase.Ticket_Source__c='Email';
        objcase.SuppliedEmail ='prashik.lokhande@techilaservices.com';
        objcase.Description = 'Email:prashik.lokhande@techilaservices.com';
        insert objcase;
        CaseTriggerHandler.isEmail('prashik.lokhande@techilaservices.com');
        caseList.add(objcase);
        Test.startTest();
        //CaseTriggerHandler.assignCaseUsingRoundRobin(caseList);
        Test.stopTest();
    }
}