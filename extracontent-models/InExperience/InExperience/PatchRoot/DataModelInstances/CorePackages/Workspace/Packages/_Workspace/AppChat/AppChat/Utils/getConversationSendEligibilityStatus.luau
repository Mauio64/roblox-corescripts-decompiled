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

	local userSendEligibilityStatus = getUserSendEligibilityStatus({
		currentTimestamp = data.currentTimestamp,
		isAvailable = data.isAvailable,
		scope = data.scope
	})

	if userSendEligibilityStatus ~= "eligible" then
		return userSendEligibilityStatus
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
		or not getEffectiveChatTimeoutDetails(
			nil,
			toTimeoutEntry(conversationStatus.data(data.scope)),
			nil,
			data.currentTimestamp
		).isTimedOut
	then
		return "eligible"
	end

	return "ineligible"
end

return getConversationSendEligibilityStatus
