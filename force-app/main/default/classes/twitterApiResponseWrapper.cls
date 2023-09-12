public class twitterApiResponseWrapper{
    public list<data> data{get;set;}
    public meta meta{get;set;}
    public class meta{
        public String oldest_id{get;set;}
        public Integer result_count{get;set;}
        public String newest_id{get;set;}
        public String next_token{get;set;}
        public String previous_token{get;set;}
    }
    public class data{
        public String text{get;set;}
        public list<String> edit_history_tweet_ids{get;set;}
        public String created_at{get;set;}
        public String id{get;set;}
        public String in_reply_to_user_id{get;set;}
        public String author_id{get;set;}
        
    }
}