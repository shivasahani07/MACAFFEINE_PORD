/* Test Class name : twitterApisTest
* created Date     : 29/07/2023
* Created By       : shubham kumar
* Last Modfied By  : shubham kumar
* Descritpion      : This class schedule the api from twitter to get all recent tweets from the timelines.
*/
public class SchedulegetAllRecentTweetsFromTwitter implements schedulable {
    public void execute(SchedulableContext sc){
        TwitterPaginationBatches.getAdditionalRecentTweets();
    }

}