local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)

local function ChatModerationStatusHydrationMiddleware(p1: ((...any) -> ...any), _) -- line: 11
	-- upvalues: AppChatNetworking (copy), GetChatModerationStatusDataHydration (copy), RemovedConversation (copy)
	return function(p3) -- line: 12
		-- upvalues: p1 (copy), AppChatNetworking (copy), GetChatModerationStatusDataHydration (copy), RemovedConversation (copy)
		local v10 = p1(p3)

		if p3.type == AppChatNetworking.rodux.GetChatModerationStatuses.Succeeded.name then
			local v11 = if not p3.postBody then {} else p3.postBody.ids or {}

			GetChatModerationStatusDataHydration(false).ingestResponse(p3.responseBody, {
				includeUser = #v11 == 0,
				conversationIds = v11
			})

			return v10
		end

		if p3.type == RemovedConversation.name and p3.conversationId then
			GetChatModerationStatusDataHydration(false).setConversationStatusNone(p3.conversationId)
		end

		return v10
	end
end

return ChatModerationStatusHydrationMiddleware
