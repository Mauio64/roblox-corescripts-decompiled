local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
require(AppChat.types)

local AppChatNetworking = require(parent.AppChatNetworking)
local React = require(parent.React)
local TrustedContacts = require(parent.TrustedContacts)
local AppTabBarRodux = require(parent.AppTabBarRodux)
local ConversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local useIsAppChatVerticallyConstrained = require(AppChat.App.Hooks.useIsAppChatVerticallyConstrained)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local refreshConversationUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshConversationUnfilteredThreadsDetails)
local Promise = require(parent.Promise)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)

local SetTabBarVisibleFromChat = AppTabBarRodux.Thunks.SetTabBarVisibleFromChat

local ConversationOverlayTelemetry = require(AppChat.Components.ChatConversation.PartialModal.ConversationOverlayTelemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local AppTelemetryLayer = require(AppChat.Telemetry.Layers.AppTelemetryLayer)

local TrustedFriendsModalEntry = TrustedContacts.TrustedFriendsModalEntry

local FIntUnfilteredThreadsPvDelayMs = require(AppChat.Flags.FIntUnfilteredThreadsPvDelayMs)

return function(props)
	local isVerticallyConstrained = useIsAppChatVerticallyConstrained()
	local v = useDispatch()
	local v2 = useIsInExperience()
	local analyticsModalVariant = props.analyticsModalVariant
	local conversationId = props.conversationId

	local v3 = useTelemetry(AppTelemetryLayer.Context)
	React.useEffect(function()
		if analyticsModalVariant == nil then
			return
		end

		v3.emit(ConversationOverlayTelemetry.Events.ModalRendered, {
			modalVariant = analyticsModalVariant
		})
	end, { analyticsModalVariant })

	React.useEffect(function()
		v(SetTabBarVisibleFromChat(false))
		return function()
			v(SetTabBarVisibleFromChat(true))
		end
	end, { v })

	local v4 = React.useCallback(function()
		props.dismissModal()

		if conversationId ~= nil then
			Promise.delay(FIntUnfilteredThreadsPvDelayMs / 1000):andThen(function()
				v(refreshConversationUnfilteredThreadsDetails(conversationId, v2))
			end)
		end
	end, { conversationId, v, props.dismissModal, v2 })
	local onClosed = React.useCallback(function()
		if analyticsModalVariant ~= nil then
			v3.emit(ConversationOverlayTelemetry.Events.ModalAction, {
				modalVariant = analyticsModalVariant,
				action = ModalTelemetry.Enums.ModalActions.Dismiss
			})
		end

		v4()
	end, { v4, v3, analyticsModalVariant })
	local onAcknowledged = React.useCallback(function()
		if analyticsModalVariant ~= nil then
			v3.emit(ConversationOverlayTelemetry.Events.ModalAction, {
				modalVariant = analyticsModalVariant,
				action = ModalTelemetry.Enums.ModalActions.PrimaryCta
			})
		end

		if props.onAcknowledged ~= nil then
			props.onAcknowledged()
		end
	end, { v3, analyticsModalVariant, props.onAcknowledged })

	return React.createElement(TrustedFriendsModalEntry, {
		userId = props.userId,
		source = props.source,
		isVerticallyConstrained = isVerticallyConstrained,
		modalVariantOverride = props.modalVariantOverride,
		onRequestSent = props.onRequestSent,
		onRequestAccepted = props.onRequestAccepted,
		onAcknowledged = onAcknowledged,
		onClosed = onClosed
	})
end
