local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetChatModerationStatusDataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local getEffectiveChatTimeoutDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getEffectiveChatTimeoutDetails")
local getUserSendEligibilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUserSendEligibilityStatus")
local toTimeoutEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/toTimeoutEntry")

local function isConversationPending(p2)
	return p2.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending or useIsUserPending(p2)
end

local function getConversationSendEligibilityStatus(data)
	local conversation = data.conversation

	if
		not data.isAvailable
		or not data.isGroupChatEnabled and conversation.conversationType == "MultiUserConversation"
		or (conversation.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending or useIsUserPending(conversation))
	then
		return "ineligible"
	end

	local v5 = getUserSendEligibilityStatus({
		currentTimestamp = data.currentTimestamp,
		isAvailable = data.isAvailable,
		scope = data.scope
	})

	if v5 ~= "eligible" then
		return v5
	end

	if conversation.source == "friends" then
		return "eligible"
	end

	local conversationStatus = data.timeoutStore.getConversationStatus(conversation.id)
	local status = conversationStatus.status(data.scope)

	if not data.allowConversationStatusLoading and status == DataHydration.DataStatus.NotReady then
		return "loading"
	end

	if
		status == DataHydration.DataStatus.Failed
		or not getEffectiveChatTimeoutDetails(nil, toTimeoutEntry(conversationStatus.data(data.scope)), nil, data.currentTimestamp).isTimedOut
	then
		return "eligible"
	end

	return "ineligible"
end

return getConversationSendEligibilityStatus
