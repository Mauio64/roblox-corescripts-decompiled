local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local Promise = require(AppChatParent.Promise)
local v6 = require(AppChat.Logger):new(script.Name)
local getNewestWithNilPreviousMessageId = require(AppChat.Components.ChatConversation.Utils.getNewestWithNilPreviousMessageId)

return function(p1: ((...any) -> ...any), s1: string) -- line: 11
	-- upvalues: v6 (copy), Promise (copy), AppChatNetworking (copy), RoduxNetworking (copy), getNewestWithNilPreviousMessageId (copy)
	v6:info("Maybe getting older messages for {}", s1)

	return function(p2) -- line: 13
		-- upvalues: Promise (copy), s1 (copy), AppChatNetworking (copy), RoduxNetworking (copy), v6 (copy), getNewestWithNilPreviousMessageId (copy), p1 (copy)
		local ChatAppReducer = p2:getState().ChatAppReducer

		if not ChatAppReducer or not ChatAppReducer.Conversations then
			return Promise.resolve()
		end

		local v12 = ChatAppReducer.Conversations[s1]
		local v13 = AppChatNetworking.rodux.GetOlderMessages.getStatus(p2:getState(), s1) == RoduxNetworking.Enum.NetworkStatus.Fetching

		if not v12 then
			v6:info("Canceling since conversation id {} is not in local state", s1)

			return Promise.resolve()
		end

		if v13 then
			v6:info("Canceling since we are already fetching older messages for conversation id {}", s1)

			return Promise.resolve()
		end

		if v12.fetchedOldestMessage then
			v6:info("Canceling since we have already fetched the oldest message for conversation id {}", s1)

			return Promise.resolve()
		end

		local v14 = getNewestWithNilPreviousMessageId(v12.messages)

		return p1(s1, v14, v12.nextCursor)
	end
end
