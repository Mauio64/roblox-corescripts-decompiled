local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetChatModerationStatusDataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local getEffectiveChatTimeoutDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getEffectiveChatTimeoutDetails")
local getUserSendEligibilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUserSendEligibilityStatus")
local toTimeoutEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/toTimeoutEntry")

local FFlagAppChatEnforceTimeoutsOnUnfilteredChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnforceTimeoutsOnUnfilteredChat")
local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagShareSheetFriendsSort

local function isActiveTimeout(data, p2, p3)
	local v5

	if data == nil or data.status ~= "active" then
		v5 = false
	else
		v5 = p3 < data.endTimestamp
			or fFlagAppChatReactiveFeatureRestrictions and data.requiresAcknowledgement == true
	end

	if FFlagAppChatEnforceTimeoutsOnUnfilteredChat then
		return v5
	end

	return v5 and p2 ~= ConversationChannels.ModerationType.TrustedComms
end

local fn = fFlagShareSheetFriendsSort and function(p2, p3, p4)
	return getEffectiveChatTimeoutDetails(nil, toTimeoutEntry(p2), nil, p4).isTimedOut
end or isActiveTimeout

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

	if fFlagShareSheetFriendsSort then
		local v5 = getUserSendEligibilityStatus({
			currentTimestamp = data.currentTimestamp,
			isAvailable = data.isAvailable,
			scope = data.scope
		})

		if v5 ~= "eligible" then
			return v5
		end
	else
		local userStatus = data.timeoutStore.getUserStatus()
		local status = userStatus.status(data.scope)

		if status == DataHydration.DataStatus.NotReady then
			return "loading"
		end

		if status ~= DataHydration.DataStatus.Failed then
			local data2 = userStatus.data(data.scope)
			local moderationType = conversation.moderationType
			local currentTimestamp = data.currentTimestamp
			local v5

			if data2 == nil or data2.status ~= "active" then
				v5 = false
			else
				v5 = currentTimestamp < data2.endTimestamp
					or fFlagAppChatReactiveFeatureRestrictions and data2.requiresAcknowledgement == true
			end

			if not FFlagAppChatEnforceTimeoutsOnUnfilteredChat and v5 then
				v5 = moderationType ~= ConversationChannels.ModerationType.TrustedComms
			end

			if v5 then
				return "ineligible"
			end
		end
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
		or not fn(conversationStatus.data(data.scope), conversation.moderationType, data.currentTimestamp)
	then
		return "eligible"
	end

	return "ineligible"
end

return getConversationSendEligibilityStatus
