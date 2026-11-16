require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local TrustedContacts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/TrustedContacts")
local AppTabBarRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppTabBarRodux")
local conversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local useIsAppChatVerticallyConstrained = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/useIsAppChatVerticallyConstrained")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch

local refreshConversationUnfilteredThreadsDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/refreshConversationUnfilteredThreadsDetails")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local setTabBarVisibleFromChat = AppTabBarRodux.Thunks.SetTabBarVisibleFromChat

local ConversationOverlayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/ConversationOverlayTelemetry")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local AppTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/AppTelemetryLayer")

local trustedFriendsModalEntry = TrustedContacts.TrustedFriendsModalEntry

local FIntUnfilteredThreadsPvDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntUnfilteredThreadsPvDelayMs")

return function(props)
	local v5 = useIsAppChatVerticallyConstrained()
	local v6 = useDispatch()
	local v7 = useIsInExperience()
	local analyticsModalVariant = props.analyticsModalVariant
	local conversationId = props.conversationId

	local v8 = useTelemetry(AppTelemetryLayer.Context)
	React.useEffect(function()
		if analyticsModalVariant == nil then
			return
		end

		v8.emit(ConversationOverlayTelemetry.Events.ModalRendered, { modalVariant = analyticsModalVariant })
	end, { analyticsModalVariant })

	React.useEffect(function()
		v6(setTabBarVisibleFromChat(false))
		return function()
			v6(setTabBarVisibleFromChat(true))
		end
	end, { v6 })

	local v9 = React.useCallback(function()
		props.dismissModal()

		if conversationId ~= nil then
			Promise.delay(FIntUnfilteredThreadsPvDelayMs / 1000):andThen(function()
				v6(refreshConversationUnfilteredThreadsDetails(conversationId, v7))
			end)
		end
	end, { conversationId, v6, props.dismissModal, v7 })
	local v10 = React.useCallback(function()
		if analyticsModalVariant ~= nil then
			v8.emit(ConversationOverlayTelemetry.Events.ModalAction, {
				modalVariant = analyticsModalVariant,
				action = ModalTelemetry.Enums.ModalActions.Dismiss
			})
		end

		v9()
	end, { v9, v8, analyticsModalVariant })
	local v11 = React.useCallback(function()
		if analyticsModalVariant ~= nil then
			v8.emit(ConversationOverlayTelemetry.Events.ModalAction, {
				modalVariant = analyticsModalVariant,
				action = ModalTelemetry.Enums.ModalActions.PrimaryCta
			})
		end

		if props.onAcknowledged ~= nil then
			props.onAcknowledged()
		end
	end, { v8, analyticsModalVariant, props.onAcknowledged })

	return React.createElement(trustedFriendsModalEntry, {
		userId = props.userId,
		source = props.source,
		isVerticallyConstrained = v5,
		modalVariantOverride = props.modalVariantOverride,
		onRequestSent = props.onRequestSent,
		onRequestAccepted = props.onRequestAccepted,
		onAcknowledged = v11,
		onClosed = v10
	})
end
