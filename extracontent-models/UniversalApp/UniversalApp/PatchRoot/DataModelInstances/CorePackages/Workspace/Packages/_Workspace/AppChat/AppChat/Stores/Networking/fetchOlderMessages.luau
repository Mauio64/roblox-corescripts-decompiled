local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Promise = require(AppChatParent.Promise)
local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local ingestOlderMessages = require(AppChat.Stores.Ingestion.ingestOlderMessages)

local function fetchOlderMessages(s1: string) -- line: 27
	-- upvalues: GetConversationMessageListStore (copy), Promise (copy), AppChatNetworking (copy), ingestOlderMessages (copy)
	local v9 = GetConversationMessageListStore(false)
	local v10 = v9.getMetadata(s1, false)

	if v10 and (v10.isLoading or v10.fetchedOldest) then
		return Promise.resolve({
			response = nil,
			ingestedIds = {}
		})
	end

	local v11 = v10 and v10.nextPageCursor or nil

	v9.setLoading(s1, true)

	return AppChatNetworking.http.GetConversationMessages(nil, s1, v11):andThen(function(p1) -- line: 39
		-- upvalues: ingestOlderMessages (copy), s1 (copy)
		local v13 = p1 and p1.responseBody
		local v14 = if not v13 then {} else v13.messages or {}
		local v15 = if not v13 then nil else v13.next_cursor
		local v16 = ingestOlderMessages(s1, v14, v15)

		return {
			response = p1,
			ingestedIds = v16
		}
	end):catch(function(p2) -- line: 48
		-- upvalues: v9 (copy), s1 (copy), Promise (copy)
		v9.setLoading(s1, false)

		return Promise.reject(p2)
	end)
end

return fetchOlderMessages
