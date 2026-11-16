local AppChat = script:FindFirstAncestor("AppChat")

local ReceivedMessages = require(AppChat.Conversations.Actions.ReceivedMessages)
local MessageModel = require(AppChat.Models.MessageModel)
local reportAnalyticsForNewMessages = require(AppChat.Utils.reportAnalyticsForNewMessages)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

return function(p, p2, p3)
	return function(object)
		local v2 = MessageModel.fromSentChannelsApi(p2, p, p3)

		if not v2 then
			return
		end

		reportAnalyticsForNewMessages(v2, p)

		local conversation = object:getState().ChatAppReducer.Conversations[p]

		if not conversation then
			v:warning("Dropping ReceivedChatResponse because conversation {} is no longer in state", p)

			return
		end

		if conversation.messages:Length() > 0 then
			v2.previousMessageId = conversation.messages:Last().id
		end

		object:dispatch(ReceivedMessages(p, { v2 }))
	end
end
