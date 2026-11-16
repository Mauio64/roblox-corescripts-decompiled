local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)

local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local getResponseBody = require(AppChat.Stores.Ingestion.getResponseBody)
local ingestConversationListPage = require(AppChat.Stores.Ingestion.ingestConversationListPage)

local function fetchConversationDetailsToSignals(p: string)
	return AppChatNetworking.http.GetConversations(nil, p):andThen(function(p2)
		local conversationStore = GetConversationStore(false)
		local responseBody = getResponseBody(p2)
		ingestConversationListPage.ingestConversationResponses(conversationStore, responseBody)
		return p2
	end)
end

return fetchConversationDetailsToSignals
