local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
require(AppChat.types)
local ConversationTopModal = AppChatNetworking.Constants.ConversationTopModal
local ConversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local EnumScreens = require(AppChat.EnumScreens)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ConversationTopModalTelemetry = require(script.Parent.Parent.ConversationTopModalTelemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
require(AppChat.Models.ConversationChannels)

local ConversationBanner = require(script.Parent.ConversationBanner)

local v = {
	[ConversationTopModal.AddTrustedConnection] = {
		onActivatedOverlayVariant = ConversationOverlay.AddTrustedConnectionU18
	},
	[ConversationTopModal.TrustedConnectionRequest] = {
		onActivatedOverlayVariant = ConversationOverlay.TrustedConnectionRequestU18
	}
}

local v2 = {
	actionText = "PLACEHOLDER Action",
	bodyText = "PLACEHOLDER Body",
	onDismissed = function() end
}

local function ConversationBannerContainer(p)
	local union = Cryo.Dictionary.union(v2, p)
	local v3 = useNavigation()
	local v4 = v[union.modalVariant]

	local v5 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v6 = useGetConversationFromId(union.conversationId)
	local joined

	if v6 and v6.participants then
		joined = table.concat(v6.participants, ",")
	else
		joined = nil
	end

	local userId = useGetOneToOneFriendIdFromConversationId(union.conversationId)
	React.useEffect(function()
		v5.emit(ConversationTopModalTelemetry.Events.ModalRendered, {
			modalVariant = union.modalVariant,
			modalContext = joined
		})
	end, { union.modalVariant })

	local onDismissed = React.useCallback(function()
		union.onDismissed()
		v5.emit(ConversationTopModalTelemetry.Events.ModalAction, {
			modalVariant = union.modalVariant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss,
			modalContext = joined
		})
	end, { union.onDismissed })

	local onActivated = React.useCallback(function()
		if v4 then
			v3.navigate(EnumScreens.TrustedConnectionsUpsell, {
				userId = userId,
				modalVariant = v4.onActivatedOverlayVariant,
				conversationId = union.conversationId,
				isOverlay = true
			})
		end

		v5.emit(ConversationTopModalTelemetry.Events.ModalAction, {
			modalVariant = union.modalVariant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
			modalContext = joined
		})
	end, { v3, v4, userId })

	if v4 then
		return React.createElement(ConversationBanner, {
			actionText = union.actionText,
			bodyText = union.bodyText,
			onDismissed = onDismissed,
			onActivated = onActivated,
			layoutOrder = union.layoutOrder
		})
	end

	return nil
end

return React.memo(ConversationBannerContainer)
