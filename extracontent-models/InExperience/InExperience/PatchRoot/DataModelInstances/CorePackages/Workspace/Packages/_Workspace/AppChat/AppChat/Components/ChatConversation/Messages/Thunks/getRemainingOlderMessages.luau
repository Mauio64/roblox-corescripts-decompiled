local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local Promise = require(parent.Promise)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local getNewestWithNilPreviousMessageId = require(AppChat.Components.ChatConversation.Utils.getNewestWithNilPreviousMessageId)

return function(callback, p: string)
	v:info("Maybe getting older messages for {}", p)
	return function(object)
		local chatAppReducer = object:getState().ChatAppReducer

		if not (chatAppReducer and chatAppReducer.Conversations) then
			return Promise.resolve()
		end

		local conversation = chatAppReducer.Conversations[p]

		local v2 = AppChatNetworking.rodux.GetOlderMessages.getStatus(object:getState(), p) == RoduxNetworking.Enum.NetworkStatus.Fetching

		if not conversation then
			v:info("Canceling since conversation id {} is not in local state", p)
			return Promise.resolve()
		end

		if v2 then
			v:info("Canceling since we are already fetching older messages for conversation id {}", p)
			return Promise.resolve()
		end

		if not conversation.fetchedOldestMessage then
			return callback(p, getNewestWithNilPreviousMessageId(conversation.messages), conversation.nextCursor)
		end

		v:info("Canceling since we have already fetched the oldest message for conversation id {}", p)

		return Promise.resolve()
	end
end
