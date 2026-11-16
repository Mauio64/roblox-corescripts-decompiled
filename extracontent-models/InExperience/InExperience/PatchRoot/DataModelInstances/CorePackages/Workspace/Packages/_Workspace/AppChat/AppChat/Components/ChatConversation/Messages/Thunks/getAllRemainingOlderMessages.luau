local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local Promise = require(parent.Promise)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local getNewestWithNilPreviousMessageId = require(AppChat.Components.ChatConversation.Utils.getNewestWithNilPreviousMessageId)

local defineFastInt = game:DefineFastInt("AppChatMessageFetchRetryDelayMs", 500)
local function fetchNextBatch(object, callback, p: string, p2: number, p3: number)
	if p2 <= p3 then
		v:info("Max depth reached ({}), stopping recursive message fetching", p3)
		return Promise.resolve()
	end

	local chatAppReducer = object:getState().ChatAppReducer

	if not (chatAppReducer and chatAppReducer.Conversations) then
		v:info("No conversations in state, stopping recursive message fetching")
		return Promise.resolve()
	end

	local conversation = chatAppReducer.Conversations[p]

	if not conversation then
		v:info("Conversation not found, stopping recursive message fetching")
		return Promise.resolve()
	end

	if conversation.fetchedOldestMessage then
		v:info("Already fetched oldest message, stopping recursive message fetching")
		return Promise.resolve()
	end

	if AppChatNetworking.rodux.GetOlderMessages.getStatus(object:getState(), p) == RoduxNetworking.Enum.NetworkStatus.Fetching then
		v:info("Messages are currently being fetched, waiting before trying again")

		return Promise.delay(defineFastInt / 1000):andThen(function()
			return fetchNextBatch(object, callback, p, p2, p3)
		end)
	end

	local newestWithNilPreviousMessageId = getNewestWithNilPreviousMessageId(conversation.messages)
	v:info("Fetching batch {} of older messages for conversation {}", p3, p)

	return object:dispatch(callback(p, newestWithNilPreviousMessageId, conversation.nextCursor)):andThen(function()
		v:info("Fetched batch {}, continuing to fetch next batch", p3)
		return fetchNextBatch(object, callback, p, p2, p3 + 1)
	end)
end

return function(callback, p: string, p2: number)
	v:info("Starting to fetch all remaining older messages for conversation {}", p)
	return function(p3)
		return fetchNextBatch(p3, callback, p, p2, 0):catch(function(p4)
			v:warning("Error fetching all remaining older messages: {}", p4)
			return Promise.reject(p4)
		end)
	end
end
