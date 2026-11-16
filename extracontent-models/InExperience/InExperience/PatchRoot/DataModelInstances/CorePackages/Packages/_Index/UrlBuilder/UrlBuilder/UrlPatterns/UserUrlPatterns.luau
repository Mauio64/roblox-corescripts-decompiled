return function(p)
	return {
		profile = p.fromString("www:users/{userId}/profile?friendshipSourceType={sourceType|}"),
		group = p.fromString("www:communities/{groupId}/{groupName|}#!/about"),
		forumComment = p.fromString("www:communities/{groupId}#!/forums/{categoryId}/post/{postId}/comment/{commentId}"),
		friends = p.fromString("www:users/{userId}/friends"),
		inventory = p.fromString("www:users/{userId}/inventory"),
		search = p.fromString("www:search/users?{keyword}"),
		profileWithFriendshipSourceType = p.fromString("www:users/{userId}/profile?friendshipSourceType={sourceType}"),
		followers = p.fromString("www:users/{userId}/friends#!/followers"),
		following = p.fromString("www:users/{userId}/friends#!/following"),
		report = function(p2)
			return p.fromString("www:abusereport/embedded/chat?id={userId}&{actionName}&{conversationId}&{redirecturl}")({
				userId = p2.userId,
				conversationId = p2.conversationId,
				actionName = "chat",
				redirecturl = p.fromString("www:home")()
			})
		end,
		appsflyer = function(p2)
			local mobileUrl = p.fromString("mobilenav:profile?userId={userId}&friendshipSourceType={sourceType}")(p2)
			local webUrl = p.fromString("www:users/{userId}/profile?friendshipSourceType={sourceType}")(p2)
			return p.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = mobileUrl,
				webUrl = webUrl
			})
		end
	}
end
