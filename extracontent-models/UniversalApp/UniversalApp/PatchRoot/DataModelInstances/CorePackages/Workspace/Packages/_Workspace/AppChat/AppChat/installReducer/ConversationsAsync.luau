local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Rodux = require(AppChatParent.Rodux)
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local ReceivedLatestMessages = require(AppChat.Conversations.Actions.ReceivedLatestMessages)
local ReceivedOldestConversation = require(AppChat.Conversations.Actions.ReceivedOldestConversation)
local ReceivedPageConversations = require(AppChat.Conversations.Actions.ReceivedPageConversations)
local RequestLatestMessages = require(AppChat.Conversations.Actions.RequestLatestMessages)
local RequestPageConversations = require(AppChat.Conversations.Actions.RequestPageConversations)
local Immutable = require(AppChatParent.AppCommonLib).Immutable

return Rodux.createReducer({}, {
	[RequestPageConversations.name] = function(p1, _) -- line: 19
		-- upvalues: Immutable (copy)
		return Immutable.JoinDictionaries(p1, {
			pageConversationsIsFetching = true
		})
	end,
	[ReceivedPageConversations.name] = function(p3, _) -- line: 24
		-- upvalues: Immutable (copy)
		return Immutable.JoinDictionaries(p3, {
			pageConversationsIsFetching = false
		})
	end,
	[RequestLatestMessages.name] = function(p5, _) -- line: 29
		-- upvalues: Immutable (copy)
		return Immutable.JoinDictionaries(p5, {
			latestMessagesIsFetching = true
		})
	end,
	[ReceivedLatestMessages.name] = function(p7, _) -- line: 34
		-- upvalues: Immutable (copy)
		return Immutable.JoinDictionaries(p7, {
			latestMessagesIsFetching = false
		})
	end,
	[ReceivedOldestConversation.name] = function(p9, _) -- line: 39
		-- upvalues: Immutable (copy)
		return Immutable.JoinDictionaries(p9, {
			oldestConversationIsFetched = true
		})
	end,
	[NetworkingChat.GetUserConversations.Succeeded.name] = function(p11, p12) -- line: 44
		-- upvalues: Immutable (copy)
		if #p12.responseBody < p12.queryArgs.pageSize then
			return Immutable.JoinDictionaries(p11, {
				oldestConversationIsFetched = true
			})
		end

		return p11
	end,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = function(p13, p14) -- line: 50
		-- upvalues: Immutable (copy)
		local next_cursor = p14.responseBody.next_cursor

		if next_cursor == nil or next_cursor == "" then
			return Immutable.JoinDictionaries(p13, {
				oldestConversationIsFetched = true
			})
		end

		return p13
	end
})
