local HttpService = game:GetService("HttpService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local Constants = require(AppChat.Constants)
local Conversation = require(AppChat.Models.Conversation)
local EnumScreens = require(AppChat.EnumScreens)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local OverlayTypes = require(AppChat.Stores.GetOverlayStore.OverlayTypes)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local getConversationConsentUpdate = require(script.Parent.getConversationConsentUpdate)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatEnableU13ChatOptIn = SharedFlags.FFlagAppChatEnableU13ChatOptIn

local SharedFlags2 = require(parent.SharedFlags)
local FFlagFriendsChatEnableConversationConsent = SharedFlags2.FFlagFriendsChatEnableConversationConsent
local normalizeConversationForTelemetry = require(script.Parent.normalizeConversationForTelemetry)

local function deriveModalVariant(shouldShowU13ChatOptIn: boolean, shouldShowOSA: boolean) -- 1 equivalent call inferred from this helper
	if shouldShowU13ChatOptIn then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	if shouldShowOSA then
		return Constants.OptInVariant.OsaContextCard
	end

	return nil
end

local function deriveSquadModalVariant(shouldShowOSA: boolean, shouldShowU13ChatOptIn: boolean, conversationType: string?) -- 1 equivalent call inferred from this helper
	if shouldShowOSA then
		return Constants.OptInVariant.OsaContextCard
	end

	if
		FFlagAppChatEnableU13ChatOptIn
		and shouldShowU13ChatOptIn
		and conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	return nil
end

local function showOsaOverlay(conversationId: string, impressionId: string?, modalVariant: string?, conversationType: string?, callback, callback2, p)
	local overlayStore = GetOverlayStore(false)

	overlayStore.showOverlay(OverlayTypes.GroupOSADialog, {
		conversationId = conversationId,
		impressionId = impressionId,
		modalVariant = modalVariant,
		onJoin = function()
			if FFlagFriendsChatEnableConversationConsent then
				local conversationConsentUpdate = getConversationConsentUpdate(modalVariant)

				local v = conversationConsentUpdate
					and GetConversationStore(false).getConversation(conversationId, false)

				if v then
					GetConversationStore(false).upsertConversation(
						Cryo.Dictionary.join(v, {
							[conversationConsentUpdate.field] = conversationConsentUpdate.value
						}),
						false
					)
				end
			end

			overlayStore.dismissOverlay()

			if callback then
				callback(conversationId)
			else
				p.navigate(EnumScreens.ChatConversation, {
					conversationId = conversationId,
					isNavigatedFromGroupOSAJoin = true
				})
			end
		end,
		onDecline = function()
			if conversationId and conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
				GetConversationStore(false).removeConversation(conversationId)
				callback2(RemovedConversation(conversationId))
			end

			overlayStore.dismissOverlay()
		end
	})
end

local function activateConversation(data, p, callback, p2, current)
	if not data.hasConversation then
		return
	end

	local conversationId = data.conversationId
	local conversation = p.getConversation(conversationId, false)

	if conversation == nil then
		return
	end

	local v = nil

	local modalVariant = deriveModalVariant(data.shouldShowU13ChatOptIn, data.shouldShowOSA) -- inferred equivalent call

	if modalVariant then
		v = HttpService:GenerateGUID(false)
		showOsaOverlay(conversationId, v, modalVariant, data.conversationType, data.onActivated and function(p3: string)
			local conversation2 = p.getConversation(p3, false)

			if conversation2 then
				data.onActivated(conversation2)
			end
		end or nil, callback, p2)
	elseif data.onActivated then
		data.onActivated(conversation)
	end

	if data.fireClickEvent then
		data.fireClickEvent(normalizeConversationForTelemetry(conversation), current, v)
	end
end

local function activateSquad(data, p: string, flag: boolean, callback, p2)
	if flag then
		p = data.conversationId
	end

	if data.hasConversation then
		local modalVariant = deriveSquadModalVariant( -- inferred equivalent call
			data.shouldShowOSA,
			data.shouldShowU13ChatOptIn,
			data.conversationType
		)

		if modalVariant then
			showOsaOverlay(
				p,
				HttpService:GenerateGUID(false),
				modalVariant,
				data.conversationType,
				data.onSquadJoinButtonActivated,
				callback,
				p2
			)

			return
		end
	end

	if data.onSquadJoinButtonActivated then
		data.onSquadJoinButtonActivated(p)
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

	local v = useNavigation()
	local v2 = useDispatch()
	local conversationStore = GetConversationStore(false)

	local onActivated2 = React.useCallback(function()
		activateConversation({
			conversationId = conversationId,
			hasConversation = hasConversation,
			shouldShowOSA = shouldShowOSA,
			shouldShowU13ChatOptIn = shouldShowU13ChatOptIn,
			conversationType = conversationType,
			onActivated = onActivated,
			fireClickEvent = fireClickEvent
		}, conversationStore, v2, v, ref.current)
	end, {
		hasConversation,
		conversationId,
		conversationType,
		shouldShowOSA,
		shouldShowU13ChatOptIn,
		onActivated,
		fireClickEvent,
		v2,
		v,
		conversationStore
	})

	local onSquadActivated = React.useCallback(function(p: string)
		activateSquad({
			conversationId = conversationId,
			hasConversation = hasConversation,
			shouldShowOSA = shouldShowOSA,
			shouldShowU13ChatOptIn = shouldShowU13ChatOptIn,
			conversationType = conversationType,
			onSquadJoinButtonActivated = onSquadJoinButtonActivated
		}, p, false, v2, v)
	end, {
		hasConversation,
		conversationId,
		conversationType,
		shouldShowOSA,
		shouldShowU13ChatOptIn,
		onSquadJoinButtonActivated,
		v2,
		v,
		conversationStore.getConversation
	})

	local onActivated3 = React.useCallback(function()
		if getCurrentOptions == nil then
			return
		end

		activateConversation(getCurrentOptions(), conversationStore, v2, v, ref.current)
	end, { v2, v, conversationStore, getCurrentOptions })

	local onSquadActivated2 = React.useCallback(function(p: string)
		if getCurrentOptions == nil then
			return
		end

		activateSquad(getCurrentOptions(), p, true, v2, v)
	end, { v2, v, getCurrentOptions })

	if getCurrentOptions == nil then
		return { onActivated = onActivated2, onSquadActivated = onSquadActivated }
	end

	return { onActivated = onActivated3, onSquadActivated = onSquadActivated2 }
end

return useConversationRowActivation
