local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local ingestMessagePage = require(AppChat.Stores.Ingestion.ingestMessagePage)

local function fetchMessagePage(s1: string, s2: string?) -- line: 20
	-- upvalues: AppChatNetworking (copy), ingestMessagePage (copy)
	return AppChatNetworking.http.GetConversationMessages(nil, s1, s2):andThen(function(p1) -- line: 21
		-- upvalues: ingestMessagePage (copy), s1 (copy)
		local v9 = p1 and p1.responseBody
		local v10 = if not v9 then {} else v9.messages or {}
		local v11 = ingestMessagePage(s1, v10)

		return {
			response = p1,
			ingestedIds = v11
		}
	end)
end

return fetchMessagePage
