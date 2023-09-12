@istest
public class SchedularClassTestClasses {
    @istest
    public static void  scheduleHashtag() {
        Test.StartTest();
        ScheduleInstagramBatchForHashTags sh1 = new ScheduleInstagramBatchForHashTags();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    @istest
    public static void  schedulePosts() {
        Test.StartTest();
        ScheduleInstagramBatchForPosts sh1 = new ScheduleInstagramBatchForPosts();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    @istest
    public static void  scheduleMentions() {
        Test.StartTest();
        ScheduleInstagramBatchForMentions sh1 = new ScheduleInstagramBatchForMentions();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
}