local ReceivedMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedMessages")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local reportAnalyticsForNewMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/reportAnalyticsForNewMessages")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ReceivedChatResponse")

return function(p2, p3, p4)
	return function(object)
		local v6 = MessageModel.fromSentChannelsApi(p3, p2, p4)

		if not v6 then
			return
		end

		reportAnalyticsForNewMessages(v6, p2)

		local conversation = object:getState().ChatAppReducer.Conversations[p2]

		if not conversation then
			v5:warning("Dropping ReceivedChatResponse because conversation {} is no longer in state", p2)

			return
		end

		if conversation.messages:Length() > 0 then
			v6.previousMessageId = conversation.messages:Last().id
		end

		object:dispatch(ReceivedMessages(p2, { v6 }))
	end
end
