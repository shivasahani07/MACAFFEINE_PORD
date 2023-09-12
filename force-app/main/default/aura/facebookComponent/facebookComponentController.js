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
                component.set("v.tweetDescription",serverresponse.description);
                /* component.set("v.filteredCommentList", serverresponse); */
                component.set("v.relatedCommentList",serverresponse.commentWrapperList);
                component.set("v.rawList",serverresponse.commentWrapperList);
                /* component.set("v.totalPages", Math.ceil(response.getReturnValue().length / component.get("v.pageSize"))); */
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },

    handleSearch: function(component, event, helper) {
        debugger;
        var searchKeyword = event.currentTarget.value;
        
        /* if(searchKeyword && searchKeyword.length < 2)
            return; */

        var data = component.get("v.rawList");
        searchKeyword = searchKeyword.toLowerCase();
        var filteredData = data.filter(item => {
            debugger;
            const { comment, CommentedBy } = item;
            const lowerCaseName = comment ? comment.toLowerCase() : '';
            const lowerCaseBy = CommentedBy ? CommentedBy.toLowerCase() : '';
            // Debugging statement
            //console.log("Item Name:", lowerCaseName);
            return lowerCaseName.includes(searchKeyword) || lowerCaseBy.includes(searchKeyword);
        });
        //var filteredData = data.filter(item => item.comment.toLowerCase().includes(searchKeyword.toLowerCase()));
        component.set("v.relatedCommentList",filteredData);
        /* component.set("v.filteredCommentList", filteredData); */
    },
    
    /* changePage: function(component, event, helper) {
        var page = event.currentTarget.dataset.page;
        component.set("v.currentPage", page);
    }, */

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
    openModel : function(component, event, helper) {
        debugger;
        var comment       = event.getSource().get('v.value');
        var commentedBy   = event.getSource().get('v.name');
        var commentId     = event.getSource().get('v.title');
        var parentId      = event.getSource().get('v.variant');
        
        component.set("v.parentCommentId",parentId);
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
        var parentSFID     = component.get("v.parentCommentId");
        var action         = component.get("c.postCommentToFB");
        action.setParams({
            commentId: commentId,
            commentText : commentMessage,
            parentSfId : parentSFID,
            caseId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The comment has been posted successfully!!"
                });
                toastEvent.fire();
                component.set("v.replyMessage","");
                component.set("v.isModalOpen",false);
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Something went wrong!"
                });
                toastEvent.fire();
            }
            component.set("v.spinner",false);
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