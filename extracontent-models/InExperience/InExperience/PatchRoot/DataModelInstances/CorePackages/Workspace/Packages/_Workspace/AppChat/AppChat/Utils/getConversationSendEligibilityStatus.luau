local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local DataHydration = require(AppChatParent.DataHydration)

require(AppChatParent.Signals)

local ConversationChannels = require(AppChat.Models.ConversationChannels)

require(AppChat.Stores.GetChatModerationStatusDataHydration)
require(AppChat.Stores.GetConversationStore)

local useIsUserPending = require(AppChat.Hooks.useIsUserPending)

local function isActiveTimeout(p1, s1: string?, n1: number) -- line: 31
	-- upvalues: ConversationChannels (copy)
	return p1 ~= nil and (p1.status == "active" and (n1 < p1.endTimestamp and s1 ~= ConversationChannels.ModerationType.TrustedComms))
end
local function isConversationPending(p2) -- line: 42
	-- upvalues: ConversationChannels (copy), useIsUserPending (copy)
	return p2.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending or useIsUserPending(p2)
end
local function getConversationSendEligibilityStatus(t1: {[any]: any}) -- line: 47
	-- upvalues: ConversationChannels (copy), useIsUserPending (copy), DataHydration (copy)
	local conversation = t1.conversation

	if not t1.isAvailable then
		return "ineligible"
	end

	if not t1.isGroupChatEnabled and conversation.conversationType == "MultiUserConversation" then
		return "ineligible"
	end

	if conversation.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending or useIsUserPending(conversation) then
		return "ineligible"
	end

	local v15 = t1.timeoutStore.getUserStatus()
	local v16 = v15.status(t1.scope)

	if v16 == DataHydration.DataStatus.NotReady then
		return "loading"
	end

	if v16 ~= DataHydration.DataStatus.Failed then
		local v17 = v15.data(t1.scope)
		local moderationType = conversation.moderationType
		local currentTimestamp = t1.currentTimestamp

		if v17 ~= nil and (v17.status == "active" and (currentTimestamp < v17.endTimestamp and moderationType ~= ConversationChannels.ModerationType.TrustedComms)) then
			return "ineligible"
		end
	end

	if conversation.source == "friends" then
		return "eligible"
	end

	local v20 = t1.timeoutStore.getConversationStatus(conversation.id)
	local v21 = v20.status(t1.scope)

	if not t1.allowConversationStatusLoading and v21 == DataHydration.DataStatus.NotReady then
		return "loading"
	end

	if v21 ~= DataHydration.DataStatus.Failed then
		local v22 = v20.data(t1.scope)
		local moderationType = conversation.moderationType
		local currentTimestamp = t1.currentTimestamp

		if v22 ~= nil and (v22.status == "active" and (currentTimestamp < v22.endTimestamp and moderationType ~= ConversationChannels.ModerationType.TrustedComms)) then
			return "ineligible"
		end
	end

	return "eligible"
end

return getConversationSendEligibilityStatus
