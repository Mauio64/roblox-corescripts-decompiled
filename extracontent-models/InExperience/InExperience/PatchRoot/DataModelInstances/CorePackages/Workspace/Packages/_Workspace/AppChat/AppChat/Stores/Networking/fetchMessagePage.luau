local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)

local ingestMessagePage = require(AppChat.Stores.Ingestion.ingestMessagePage)

local function fetchMessagePage(p: string, p2: string?)
	return AppChatNetworking.http.GetConversationMessages(nil, p, p2):andThen(function(response)
		local responseBody = response and response.responseBody
		local messages = responseBody and responseBody.messages or {}
		return { response = response, ingestedIds = ingestMessagePage(p, messages) }
	end)
end

return fetchMessagePage
