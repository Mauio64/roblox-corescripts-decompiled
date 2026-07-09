local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local ingestNewerMessages = require(AppChat.Stores.Ingestion.ingestNewerMessages)

local function fetchNewerMessages(s1: string) -- line: 24
	-- upvalues: AppChatNetworking (copy), ingestNewerMessages (copy)
	return AppChatNetworking.http.GetConversationMessages(nil, s1, nil):andThen(function(p1) -- line: 25
		-- upvalues: ingestNewerMessages (copy), s1 (copy)
		local v8 = p1 and p1.responseBody
		local v9 = if not v8 then {} else v8.messages or {}
		local v10 = ingestNewerMessages(s1, v9)

		return {
			response = p1,
			ingestedIds = v10
		}
	end)
end

return fetchNewerMessages
