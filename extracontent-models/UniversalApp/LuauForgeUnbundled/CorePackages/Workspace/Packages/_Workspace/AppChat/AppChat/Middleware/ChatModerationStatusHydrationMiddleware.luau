local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local clearUserSpecificData = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Actions.ClearUserSpecificData

local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local GetChatModerationStatusDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetChatModerationStatusDataHydration")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions
local FFlagAppChatUseDataHydrationForChatTimeouts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseDataHydrationForChatTimeouts")

local function ChatModerationStatusHydrationMiddleware(callback, p2)
	return function(data)
		local v5 = callback(data)

		if data.type == AppChatNetworking.rodux.GetChatModerationStatuses.Succeeded.name then
			local ids = data.postBody and data.postBody.ids or {}
			GetChatModerationStatusDataHydration(false).ingestResponse(data.responseBody, {
				includeUser = fFlagAppChatReactiveFeatureRestrictions or #ids == 0,
				conversationIds = ids
			})
			return v5
		end

		if data.type == RemovedConversation.name and data.conversationId then
			GetChatModerationStatusDataHydration(false).setConversationStatusNone(data.conversationId)
			return v5
		end

		if FFlagAppChatUseDataHydrationForChatTimeouts and data.type == clearUserSpecificData.name then
			GetChatModerationStatusDataHydration(false).clear()
		end

		return v5
	end
end

return ChatModerationStatusHydrationMiddleware
