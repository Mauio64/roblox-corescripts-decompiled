local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("getAllRemainingOlderMessages")

local getNewestWithNilPreviousMessageId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/getNewestWithNilPreviousMessageId")

local defineFastInt = game:DefineFastInt("AppChatMessageFetchRetryDelayMs", 500)
local function fetchNextBatch(object, callback, p2, p3, p4)
	if p3 <= p4 then
		v5:info("Max depth reached ({}), stopping recursive message fetching", p4)
		return Promise.resolve()
	end

	local chatAppReducer = object:getState().ChatAppReducer

	if not (chatAppReducer and chatAppReducer.Conversations) then
		v5:info("No conversations in state, stopping recursive message fetching")
		return Promise.resolve()
	end

	local conversation = chatAppReducer.Conversations[p2]

	if not conversation then
		v5:info("Conversation not found, stopping recursive message fetching")
		return Promise.resolve()
	end

	if conversation.fetchedOldestMessage then
		v5:info("Already fetched oldest message, stopping recursive message fetching")
		return Promise.resolve()
	end

	if AppChatNetworking.rodux.GetOlderMessages.getStatus(object:getState(), p2) == RoduxNetworking.Enum.NetworkStatus.Fetching then
		v5:info("Messages are currently being fetched, waiting before trying again")

		return Promise.delay(defineFastInt / 1000):andThen(function()
			return fetchNextBatch(object, callback, p2, p3, p4)
		end)
	end

	local v6 = getNewestWithNilPreviousMessageId(conversation.messages)
	v5:info("Fetching batch {} of older messages for conversation {}", p4, p2)

	return object:dispatch(callback(p2, v6, conversation.nextCursor)):andThen(function()
		v5:info("Fetched batch {}, continuing to fetch next batch", p4)
		return fetchNextBatch(object, callback, p2, p3, p4 + 1)
	end)
end

return function(p2, p3, p4)
	v5:info("Starting to fetch all remaining older messages for conversation {}", p3)
	return function(p5)
		return fetchNextBatch(p5, p2, p3, p4, 0):catch(function(p6)
			v5:warning("Error fetching all remaining older messages: {}", p6)
			return Promise.reject(p6)
		end)
	end
end
