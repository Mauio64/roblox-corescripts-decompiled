local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
require(parent.Signals)

local ConversationChannels = require(AppChat.Models.ConversationChannels)
require(AppChat.Stores.GetChatModerationStatusDataHydration)
require(AppChat.Stores.GetConversationStore)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local getEffectiveChatTimeoutDetails = require(AppChat.Utils.getEffectiveChatTimeoutDetails)
local getUserSendEligibilityStatus = require(AppChat.Utils.getUserSendEligibilityStatus)
local toTimeoutEntry = require(AppChat.Utils.toTimeoutEntry)

local FFlagAppChatEnforceTimeoutsOnUnfilteredChat = require(AppChat.Flags.FFlagAppChatEnforceTimeoutsOnUnfilteredChat)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local SharedFlags2 = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags2.FFlagShareSheetFriendsSort

local function isActiveTimeout(data, p: string?, p2: number)
	local v

	if data == nil or data.status ~= "active" then
		v = false
	else
		v = p2 < data.endTimestamp or FFlagAppChatReactiveFeatureRestrictions and data.requiresAcknowledgement == true
	end

	if FFlagAppChatEnforceTimeoutsOnUnfilteredChat then
		return v
	end

	return v and p ~= ConversationChannels.ModerationType.TrustedComms
end

local fn = FFlagShareSheetFriendsSort and function(p, _, p2)
	return getEffectiveChatTimeoutDetails(nil, toTimeoutEntry(p), nil, p2).isTimedOut
end or isActiveTimeout

local function isConversationPending(conversation) -- 1 equivalent call inferred from this helper
	return conversation.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending
		or useIsUserPending(conversation)
end

local function getConversationSendEligibilityStatus(data)
	local conversation = data.conversation

	if
		not data.isAvailable
		or not data.isGroupChatEnabled and conversation.conversationType == "MultiUserConversation"
		or isConversationPending(conversation) -- inferred equivalent call
	then
		return "ineligible"
	end

	if FFlagShareSheetFriendsSort then
		local userSendEligibilityStatus = getUserSendEligibilityStatus({
			currentTimestamp = data.currentTimestamp,
			isAvailable = data.isAvailable,
			scope = data.scope
		})

		if userSendEligibilityStatus ~= "eligible" then
			return userSendEligibilityStatus
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
			local v

			if data2 == nil or data2.status ~= "active" then
				v = false
			else
				v = currentTimestamp < data2.endTimestamp
					or FFlagAppChatReactiveFeatureRestrictions and data2.requiresAcknowledgement == true
			end

			if not FFlagAppChatEnforceTimeoutsOnUnfilteredChat and v then
				v = moderationType ~= ConversationChannels.ModerationType.TrustedComms
			end

			if v then
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
