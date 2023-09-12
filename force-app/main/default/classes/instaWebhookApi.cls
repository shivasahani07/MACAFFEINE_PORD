@RestResource(urlMapping='/instaGramAPI/V2/*')
global without sharing class instaWebhookApi {
    static String WEB_TOKEN = 'EAAKJz6xiZC6gBAEQ7Ub3pazJxFazWFUXEkbp2Hlg0W0EmblRJVhrLLr1WUwL81hqfSxRXJJ8otiGZAyQ66onZBoRFTOqdjZBKioZA5iy55N0rxyZBulbw1XVgu6ktZA0b0vs6uZAFG7SodcyHayN2id8WAktoJejpdCcaTLF9NwV6FkTvizWzYBZC';
    @HttpPost
    global static void webhookListener(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String requestBody = req.requestBody.toString();
        System.debug('--- WEBHOOK requestBody' +requestBody);
        try{
            if(requestBody != null) {
                requestBody = requestBody.replace('"object"','"object_c"');
                requestBody = requestBody.replace('"time"','"time_c"');
                requestBody = requestBody.replace('"from"','"from_c"');
                
                Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(requestBody);
                system.debug('responseMap--->'+responseMap);
                if(responseMap != null && responseMap.containsKey('entry')) {
                    List<Object> changesList = (List<Object>)((Map<String, Object>)(((List<Object>)responseMap.get('entry'))[0])).get('changes');
                    if(changesList != null && !changesList.isEmpty() && ((Map<String,Object>)changesList[0]).containsKey('field')) {
                        Map<String,Object> change = (Map<String,Object>)changesList[0];
                        if(change.get('field') == 'comments') {
                            newPostRequest(requestBody);
                        }else if(change.get('field') == 'mentions') {
                            processMention(change);
                        }
                    }
                }
            }
        }catch(Exception e) {
            System.debug('--- Exception'+ e.getMessage());
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new ResponseWrapper('Received', WEB_TOKEN)));
    }
    
    private static void newPostRequest(String requestBody) {
        system.debug('postNotification Coming here');
        List<Case> postCaseList = new List<Case>();
        InstaNotificationWrapper postNotification = (InstaNotificationWrapper) JSON.deserialize(requestBody, InstaNotificationWrapper.class);
        if(postNotification != null) {
            Integer timeStamp;
            String entryId , message;
            for(InstaNotificationWrapper.cls_entry entry: postNotification.entry) {
                timeStamp = entry.time_c; //TODO convert this to readable format
                for(InstaNotificationWrapper.cls_changes change: entry.changes) {
                    system.debug('post_id==>'+change.value);
                    InstagramAuthHelper.getAllDetailsOfComments(change.value.id);
                    Case postCase = new Case(Origin = 'Instagram',Created_Time__c = getTimeStamp(timeStamp), Subject= 'New Comments that you are tagged in.', Post_Id__c = change.value.id, Description = change.value.text,Type='Comments',Mention__c='utilitarian_labs');
                    postCaseList.add(postCase);
                }
            }
            if(!postCaseList.isEmpty()) {
                System.debug('--- creating case: '+postCaseList);
                try{
                    Database.insert(postCaseList, false);
                }catch(DMLException e){
                    System.debug('--- e.Message:'+e.getMessage());
                }
            }
        }
    }
    
    private static void processMention(Map<String,Object> responseMap) {
        Map<String, Object> fbMentionObject = (Map<String, Object>) responseMap.get('value');
        system.debug('fbMentionObject-->'+fbMentionObject);
        system.debug('fbMentionObject-------->'+fbMentionObject.get('comment_id'));
        system.debug('fbMentionObject-------->'+fbMentionObject.get('media_id'));
        
        if(fbMentionObject != null) {
            system.debug('fbMentionObject--->'+fbMentionObject);
            InstagramAuthHelper.getAllDetailsOfMedia(String.valueOf(fbMentionObject.get('media_id')));
        }
    }
   
    public class ResponseWrapper {
        String message;
        String token;
        public ResponseWrapper(String message, String token) { 
            this.message = message;
            this.token = token;
        }
    }
    
    @HttpGet
    global static Integer verify() {
        System.debug('--- params '+RestContext.request.params);
        String token = RestContext.request.params.get('hub.verify_token');
        Integer challenge = Integer.valueOf(RestContext.request.params.get('hub.challenge'));
        if(token == WEB_TOKEN) {
            return challenge;
        }
        return null;
    }
    
    global static string getTimeStamp(integer timeValue) {
        // Unix timestamp to be converted
        Integer unixTimestamp = timeValue;
        
        // Convert Unix timestamp to Datetime
        Datetime dateTimeValue = Datetime.newInstance(unixTimestamp * 1000L);
        
        // Convert the Datetime to a formatted string if needed
        String formattedDateTime = dateTimeValue.format('yyyy-MM-dd HH:mm:ss');
        System.debug('Converted Datetime: ' + formattedDateTime);
        return  formattedDateTime;
    }
    
}