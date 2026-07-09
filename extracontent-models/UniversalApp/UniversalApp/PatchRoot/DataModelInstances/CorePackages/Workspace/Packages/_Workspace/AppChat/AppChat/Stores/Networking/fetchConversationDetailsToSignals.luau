local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local getResponseBody = require(AppChat.Stores.Ingestion.getResponseBody)
local ingestConversationListPage = require(AppChat.Stores.Ingestion.ingestConversationListPage)

local function fetchConversationDetailsToSignals(s1: string) -- line: 22
	-- upvalues: AppChatNetworking (copy), GetConversationStore (copy), getResponseBody (copy), ingestConversationListPage (copy)
	return AppChatNetworking.http.GetConversations(nil, s1):andThen(function(p1) -- line: 26
		-- upvalues: GetConversationStore (copy), getResponseBody (copy), ingestConversationListPage (copy)
		local v10 = GetConversationStore(false)
		local v11 = getResponseBody(p1)

		ingestConversationListPage.ingestConversationResponses(v10, v11)

		return p1
	end)
end

return fetchConversationDetailsToSignals
