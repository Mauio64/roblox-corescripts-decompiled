return function(p1) -- line: 1
	return {
		profile = p1.fromString("www:users/{userId}/profile?friendshipSourceType={sourceType|}"),
		group = p1.fromString("www:communities/{groupId}/{groupName|}#!/about"),
		forumComment = p1.fromString("www:communities/{groupId}#!/forums/{categoryId}/post/{postId}/comment/{commentId}"),
		friends = p1.fromString("www:users/{userId}/friends"),
		inventory = p1.fromString("www:users/{userId}/inventory"),
		search = p1.fromString("www:search/users?{keyword}"),
		profileWithFriendshipSourceType = p1.fromString("www:users/{userId}/profile?friendshipSourceType={sourceType}"),
		followers = p1.fromString("www:users/{userId}/friends#!/followers"),
		following = p1.fromString("www:users/{userId}/friends#!/following"),
		report = function(p2) -- line: 15
			-- upvalues: p1 (copy)
			return p1.fromString("www:abusereport/embedded/chat?id={userId}&{actionName}&{conversationId}&{redirecturl}")({
				actionName = "chat",
				userId = p2.userId,
				conversationId = p2.conversationId,
				redirecturl = p1.fromString("www:home")()
			})
		end,
		appsflyer = function(p3) -- line: 28
			-- upvalues: p1 (copy)
			local v4 = p1.fromString("mobilenav:profile?userId={userId}&friendshipSourceType={sourceType}")(p3)
			local v5 = p1.fromString("www:users/{userId}/profile?friendshipSourceType={sourceType}")(p3)

			return p1.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = v4,
				webUrl = v5
			})
		end
	}
end
