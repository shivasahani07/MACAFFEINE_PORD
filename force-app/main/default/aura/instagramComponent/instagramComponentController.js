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
                console.log(serverresponse);
                var serverresponse = response.getReturnValue();
                component.set("v.tweetDescription",serverresponse[0].postCaption);
                component.set("v.urlToPost",serverresponse[0].PostUrl);
                component.set("v.typeOfPost",serverresponse[0].postType);
                component.set("v.relatedCommentList",serverresponse);
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },
    replyToTweet : function(component) {
        debugger;
        component.set("v.showSpinner",true);
        
        var replyMessage = component.get("v.tweetReply");
        var tweetId  = component.get("v.tweetId");
        var action = component.get("c.sendReplyToTheTweet");
        action.setParams({
            "tweetId" : tweetId ,
            "message" : replyMessage 
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
    refreshFeed : function(component, event, helper) {
        debugger;
        
        component.set("v.showSpinner",true);
        var recId = component.get("v.recordId");
        var action = component.get("c.getUpdatedComments");
        action.setParams({
            recordId: recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log(serverresponse);
                var serverresponse = response.getReturnValue();
                component.set("v.tweetDescription",serverresponse[0].postCaption);
                component.set("v.urlToPost",serverresponse[0].PostUrl);
                component.set("v.typeOfPost",serverresponse[0].postType);
                component.set("v.relatedCommentList",serverresponse);
                component.set("v.showSpinner",false);
            }else{
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action); 
        
    },
    openModel : function(component, event, helper) {
        debugger;
        var comment       = event.getSource().get('v.value');
        var commentedBy   = event.getSource().get('v.name');
        var commentId     = event.getSource().get('v.title');
        component.set("v.selectedCommentId",commentId);
        component.set("v.selectedCommentValue",comment);
        component.set("v.selectedCommentRepliedBy",commentedBy);
        component.set("v.isModalOpen",true);
    },
    closeModel : function(component, event, helper) {
        debugger;
        component.set("v.isModalOpen",false);
        component.set("v.showReplies",false);
    },
    postComment : function(component, event, helper) {
        debugger;
        component.set("v.spinner",true);
        var commentId      = component.get("v.selectedCommentId");
        var commentMessage = component.get("v.replyMessage");
        
        var action         = component.get("c.replyToComment");
        action.setParams({
            commentId: commentId,
            commentMessage : commentMessage
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.spinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The comment has been posted successfully!!"
                });
                toastEvent.fire();
                component.set("v.isModalOpen",false);
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },
    
    viewCommentReplies : function(component, event, helper) {
        debugger;
        component.set("v.spinner",true);
        var comment       = event.getSource().get('v.value');
        var commentedBy   = event.getSource().get('v.name');
        var commentId     = event.getSource().get('v.title');
        component.set("v.selectedCommentId",commentId);
        component.set("v.selectedCommentValue",comment);
        component.set("v.selectedCommentRepliedBy",commentedBy);
        
        var action         = component.get("c.getRepliesDetails");
        action.setParams({
            commentId: commentId,
         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var serverresponse = response.getReturnValue();
                if(serverresponse.length > 0){
                    component.set("v.relatedReplyList",serverresponse);
                    component.set("v.showReplies",true);
                    component.set("v.spinner",false);    
                }else{
                    component.set("v.relatedReplyList",[]);
                    component.set("v.showReplies",true);
                    component.set("v.spinner",false);  
                }
                
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },
})