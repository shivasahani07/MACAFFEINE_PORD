({
    doInit : function(component, event, helper) {
        debugger;
        var recId = component.get("v.recordId");
        var action = component.get("c.getCaseDetails");
        action.setParams({
            recordId: recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var serverresponse = response.getReturnValue();
                component.set("v.tweetDescription",serverresponse[0].postCaption);
                component.set("v.tweetReply",serverresponse[0].comment);
                component.set("v.urlToPost",serverresponse[0].PostUrl);
            }else{
                
            }
        });
        $A.enqueueAction(action);    
    },
    replyToTweet : function(component) {
        debugger;
        component.set("v.showSpinner",true);
        var recId = component.get("v.recordId");
        var replyMessage = component.get("v.tweetReply");
        var tweetId  = component.get("v.tweetId");
        var action = component.get("c.replyToTweetOnTwittter");
        action.setParams({
            "recordId" : recId ,
            "textMessage" : replyMessage 
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner",false);
                component.set("v.isModalOpen", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Reply posted to twitter',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
})