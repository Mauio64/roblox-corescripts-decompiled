local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("getRemainingOlderMessages")

local getNewestWithNilPreviousMessageId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/getNewestWithNilPreviousMessageId")

return function(callback, p2)
	v5:info("Maybe getting older messages for {}", p2)
	return function(object)
		local chatAppReducer = object:getState().ChatAppReducer

		if not (chatAppReducer and chatAppReducer.Conversations) then
			return Promise.resolve()
		end

		local conversation = chatAppReducer.Conversations[p2]

		local v6 = AppChatNetworking.rodux.GetOlderMessages.getStatus(object:getState(), p2) == RoduxNetworking.Enum.NetworkStatus.Fetching

		if not conversation then
			v5:info("Canceling since conversation id {} is not in local state", p2)
			return Promise.resolve()
		end

		if v6 then
			v5:info("Canceling since we are already fetching older messages for conversation id {}", p2)
			return Promise.resolve()
		end

		if conversation.fetchedOldestMessage then
			v5:info("Canceling since we have already fetched the oldest message for conversation id {}", p2)

			return Promise.resolve()
		end

		return callback(p2, getNewestWithNilPreviousMessageId(conversation.messages), conversation.nextCursor)
	end
end
