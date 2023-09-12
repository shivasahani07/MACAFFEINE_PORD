@istest
public class SchedulegetAlltwitemthodTest {
    @istest
    public static void  AllRecentTweetsFromTwitterTest() {
        Test.StartTest();
        SchedulegetAllRecentTweetsFromTwitter sh1 = new SchedulegetAllRecentTweetsFromTwitter();      
        String sch = '0 30 * * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    
    @istest
    public static void  AllTweetsFromTimeLineTest() {
        Test.StartTest();
        SchedulegetAllTweetsFromTimeLine sh1 = new SchedulegetAllTweetsFromTimeLine();      
        String sch = '0 30 * * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    
    @istest
    public static void  AllMentionsFromTimeLineTest() {
        Test.StartTest();
        SchedulegetAllMentionsFromTimeLine sh1 = new SchedulegetAllMentionsFromTimeLine();      
        String sch = '0 30 * * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    
    @istest
    public static void  scheduleRefreshAccessToken() {
        Test.StartTest();
        ScheduleRefreshtwitterAccesstoken sh1 = new ScheduleRefreshtwitterAccesstoken();      
        String sch = '0 30 * * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
}