local AppChat = script:FindFirstAncestor("AppChat")
local ReceivedMessages = require(AppChat.Conversations.Actions.ReceivedMessages)
local MessageModel = require(AppChat.Models.MessageModel)
local reportAnalyticsForNewMessages = require(AppChat.Utils.reportAnalyticsForNewMessages)
local FFlagAppChatNilGuardReceivedChatResponse = require(AppChat.Flags.FFlagAppChatNilGuardReceivedChatResponse)
local v6 = require(AppChat.Logger):new(script.Name)

return function(p1, p2, p3) -- line: 10
	-- upvalues: MessageModel (copy), reportAnalyticsForNewMessages (copy), FFlagAppChatNilGuardReceivedChatResponse (copy), v6 (copy), ReceivedMessages (copy)
	return function(p4) -- line: 11
		-- upvalues: MessageModel (copy), p2 (copy), p1 (copy), p3 (copy), reportAnalyticsForNewMessages (copy), FFlagAppChatNilGuardReceivedChatResponse (copy), v6 (copy), ReceivedMessages (copy)
		local v11 = MessageModel.fromSentChannelsApi(p2, p1, p3)

		if not v11 then
			return
		end

		reportAnalyticsForNewMessages(v11, p1)

		local v12 = p4:getState().ChatAppReducer.Conversations[p1]

		if FFlagAppChatNilGuardReceivedChatResponse and not v12 then
			v6:warning("Dropping ReceivedChatResponse because conversation {} is no longer in state", p1)

			return
		end

		if v12.messages:Length() > 0 then
			v11.previousMessageId = v12.messages:Last().id
		end

		p4:dispatch(ReceivedMessages(p1, { v11 }))
	end
end
