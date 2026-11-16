local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local GetOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore")
local OverlayTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore/OverlayTypes")
local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local getConversationConsentUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/getConversationConsentUpdate")

local fFlagAppChatEnableU13ChatOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableU13ChatOptIn

local fFlagFriendsChatEnableConversationConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagFriendsChatEnableConversationConsent
local normalizeConversationForTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/normalizeConversationForTelemetry")

local function deriveModalVariant(p2, p3)
	if p2 then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	if p3 then
		return Constants.OptInVariant.OsaContextCard
	end

	return nil
end

local function deriveSquadModalVariant(p2, p3, p4)
	if p2 then
		return Constants.OptInVariant.OsaContextCard
	end

	if fFlagAppChatEnableU13ChatOptIn and p3 and p4 == Conversation.Type.MULTI_USER_CONVERSATION then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	return nil
end

local function showOsaOverlay(p2, p3, p4, conversationType, callback, callback2, p5)
	local v5 = GetOverlayStore(false)

	v5.showOverlay(OverlayTypes.GroupOSADialog, {
		conversationId = p2,
		impressionId = p3,
		modalVariant = p4,
		onJoin = function()
			if fFlagFriendsChatEnableConversationConsent then
				local v6 = getConversationConsentUpdate(p4)

				local v7 = v6 and GetConversationStore(false).getConversation(p2, false)

				if v7 then
					GetConversationStore(false).upsertConversation(
						Cryo.Dictionary.join(v7, { [v6.field] = v6.value }),
						false
					)
				end
			end

			v5.dismissOverlay()

			if callback then
				callback(p2)
			else
				p5.navigate(EnumScreens.ChatConversation, {
					conversationId = p2,
					isNavigatedFromGroupOSAJoin = true
				})
			end
		end,
		onDecline = function()
			if p2 and conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
				GetConversationStore(false).removeConversation(p2)
				callback2(RemovedConversation(p2))
			end

			v5.dismissOverlay()
		end
	})
end

local function activateConversation(data, p2, p3, p4, current)
	if not data.hasConversation then
		return
	end

	local conversationId = data.conversationId
	local conversation = p2.getConversation(conversationId, false)

	if conversation == nil then
		return
	end

	local v5 = nil

	local shouldShowU13ChatOptIn = data.shouldShowU13ChatOptIn
	local shouldShowOSA = data.shouldShowOSA
	local v6

	if shouldShowU13ChatOptIn then
		v6 = Constants.OptInVariant.ChatOptInInfoCard
	elseif shouldShowOSA then
		v6 = Constants.OptInVariant.OsaContextCard
	end

	if v6 then
		v5 = HttpService:GenerateGUID(false)
		showOsaOverlay(conversationId, v5, v6, data.conversationType, data.onActivated and function(p5)
			local conversation2 = p2.getConversation(p5, false)

			if conversation2 then
				data.onActivated(conversation2)
			end
		end or nil, p3, p4)
	elseif data.onActivated then
		data.onActivated(conversation)
	end

	if data.fireClickEvent then
		data.fireClickEvent(normalizeConversationForTelemetry(conversation), current, v5)
	end
end

local function activateSquad(data, p2, p3, p4, p5)
	if p3 then
		p2 = data.conversationId
	end

	if data.hasConversation then
		local shouldShowOSA = data.shouldShowOSA
		local shouldShowU13ChatOptIn = data.shouldShowU13ChatOptIn
		local conversationType = data.conversationType
		local v5

		if shouldShowOSA then
			v5 = Constants.OptInVariant.OsaContextCard
		elseif
			fFlagAppChatEnableU13ChatOptIn
			and shouldShowU13ChatOptIn
			and conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		then
			v5 = Constants.OptInVariant.ChatOptInInfoCard
		end

		if v5 then
			showOsaOverlay(
				p2,
				HttpService:GenerateGUID(false),
				v5,
				data.conversationType,
				data.onSquadJoinButtonActivated,
				p4,
				p5
			)

			return
		end
	end

	if data.onSquadJoinButtonActivated then
		data.onSquadJoinButtonActivated(p2)
	end
end

local function useConversationRowActivation(data)
	local getCurrentOptions = data.getCurrentOptions
	local conversationId = data.conversationId
	local hasConversation = data.hasConversation
	local shouldShowOSA = data.shouldShowOSA
	local shouldShowU13ChatOptIn = data.shouldShowU13ChatOptIn
	local conversationType = data.conversationType
	local onActivated = data.onActivated
	local onSquadJoinButtonActivated = data.onSquadJoinButtonActivated
	local fireClickEvent = data.fireClickEvent
	local telemetry = data.telemetry
	local ref = React.useRef(telemetry)
	ref.current = telemetry

	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = GetConversationStore(false)

	local v8 = React.useCallback(function()
		activateConversation({
			conversationId = conversationId,
			hasConversation = hasConversation,
			shouldShowOSA = shouldShowOSA,
			shouldShowU13ChatOptIn = shouldShowU13ChatOptIn,
			conversationType = conversationType,
			onActivated = onActivated,
			fireClickEvent = fireClickEvent
		}, v7, v6, v5, ref.current)
	end, {
		hasConversation,
		conversationId,
		conversationType,
		shouldShowOSA,
		shouldShowU13ChatOptIn,
		onActivated,
		fireClickEvent,
		v6,
		v5,
		v7
	})

	local v9 = React.useCallback(function(p2)
		activateSquad({
			conversationId = conversationId,
			hasConversation = hasConversation,
			shouldShowOSA = shouldShowOSA,
			shouldShowU13ChatOptIn = shouldShowU13ChatOptIn,
			conversationType = conversationType,
			onSquadJoinButtonActivated = onSquadJoinButtonActivated
		}, p2, false, v6, v5)
	end, {
		hasConversation,
		conversationId,
		conversationType,
		shouldShowOSA,
		shouldShowU13ChatOptIn,
		onSquadJoinButtonActivated,
		v6,
		v5,
		v7.getConversation
	})

	local v10 = React.useCallback(function()
		if getCurrentOptions == nil then
			return
		end

		activateConversation(getCurrentOptions(), v7, v6, v5, ref.current)
	end, { v6, v5, v7, getCurrentOptions })

	local v11 = React.useCallback(function(p2)
		if getCurrentOptions == nil then
			return
		end

		activateSquad(getCurrentOptions(), p2, true, v6, v5)
	end, { v6, v5, getCurrentOptions })

	if getCurrentOptions == nil then
		return { onActivated = v8, onSquadActivated = v9 }
	end

	return { onActivated = v10, onSquadActivated = v11 }
end

return useConversationRowActivation
