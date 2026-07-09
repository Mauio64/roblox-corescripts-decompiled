local SocialTabState = script:FindFirstAncestor("SocialTabState")
local dependencies = require(SocialTabState.dependencies)
local Rodux = dependencies.Rodux
local AppChatNetworking = dependencies.AppChatNetworking
local GetUnreadConversationCount = require(SocialTabState.Requests.GetUnreadConversationCount)

return Rodux.createReducer(0, {
	[GetUnreadConversationCount.Succeeded.name] = function(p1, p2) -- line: 11
		if p2.responseBody and p2.responseBody.count then
			return p2.responseBody.count
		end

		return p1
	end,
	[AppChatNetworking.rodux.GetConversationMetadata.Succeeded.name] = function(p3, p4) -- line: 18
		if p4.responseBody and p4.responseBody.global_unread_count then
			return p4.responseBody.global_unread_count
		end

		return p3
	end,
	[AppChatNetworking.rodux.ClearGlobalUnreadCount.Succeeded.name] = function(p5, p6) -- line: 26
		if p6.responseBody and p6.responseBody.status == "success" then
			return 0
		end

		return p5
	end
})
