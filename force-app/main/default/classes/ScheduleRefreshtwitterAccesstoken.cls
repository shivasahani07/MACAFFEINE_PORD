public class ScheduleRefreshtwitterAccesstoken implements schedulable {
    public void execute(SchedulableContext sc){
       TwitterAuthentication.getRefreshedToken();
    }

}