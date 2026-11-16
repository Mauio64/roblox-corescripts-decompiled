local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Promise = require(parent.Promise)

local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local ingestOlderMessages = require(AppChat.Stores.Ingestion.ingestOlderMessages)

local function fetchOlderMessages(p: string)
	local conversationMessageListStore = GetConversationMessageListStore(false)
	local metadata = conversationMessageListStore.getMetadata(p, false)

	if metadata and (metadata.isLoading or metadata.fetchedOldest) then
		return Promise.resolve({ response = nil, ingestedIds = {} })
	end

	local nextPageCursor = metadata and metadata.nextPageCursor or nil
	conversationMessageListStore.setLoading(p, true)

	return AppChatNetworking.http.GetConversationMessages(nil, p, nextPageCursor):andThen(function(response)
		local responseBody = response and response.responseBody
		local messages = responseBody and responseBody.messages or {}
		local v

		if responseBody then
			v = responseBody.next_cursor
		end

		return {
			response = response,
			ingestedIds = ingestOlderMessages(p, messages, v)
		}
	end):catch(function(p2)
		conversationMessageListStore.setLoading(p, false)
		return Promise.reject(p2)
	end)
end

return fetchOlderMessages
