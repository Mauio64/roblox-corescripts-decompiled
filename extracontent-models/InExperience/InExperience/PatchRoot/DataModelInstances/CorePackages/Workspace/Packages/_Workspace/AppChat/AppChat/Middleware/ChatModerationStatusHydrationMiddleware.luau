local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local UserLib = require(parent.UserLib)
local ClearUserSpecificData = UserLib.Actions.ClearUserSpecificData

local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local FFlagAppChatUseDataHydrationForChatTimeouts = require(AppChat.Flags.FFlagAppChatUseDataHydrationForChatTimeouts)

local function ChatModerationStatusHydrationMiddleware(callback, _)
	return function(data)
		local v = callback(data)

		if data.type == AppChatNetworking.rodux.GetChatModerationStatuses.Succeeded.name then
			local ids = data.postBody and data.postBody.ids or {}
			GetChatModerationStatusDataHydration(false).ingestResponse(data.responseBody, {
				includeUser = FFlagAppChatReactiveFeatureRestrictions or #ids == 0,
				conversationIds = ids
			})
			return v
		end

		if data.type == RemovedConversation.name and data.conversationId then
			GetChatModerationStatusDataHydration(false).setConversationStatusNone(data.conversationId)
			return v
		end

		if FFlagAppChatUseDataHydrationForChatTimeouts and data.type == ClearUserSpecificData.name then
			GetChatModerationStatusDataHydration(false).clear()
		end

		return v
	end
end

return ChatModerationStatusHydrationMiddleware
