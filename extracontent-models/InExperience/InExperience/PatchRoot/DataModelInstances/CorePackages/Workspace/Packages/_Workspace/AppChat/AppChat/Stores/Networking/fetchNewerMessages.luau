local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)

local ingestNewerMessages = require(AppChat.Stores.Ingestion.ingestNewerMessages)

local function fetchNewerMessages(p: string)
	return AppChatNetworking.http.GetConversationMessages(nil, p, nil):andThen(function(response)
		local responseBody = response and response.responseBody
		local messages = responseBody and responseBody.messages or {}
		return {
			response = response,
			ingestedIds = ingestNewerMessages(p, messages)
		}
	end)
end

return fetchNewerMessages
