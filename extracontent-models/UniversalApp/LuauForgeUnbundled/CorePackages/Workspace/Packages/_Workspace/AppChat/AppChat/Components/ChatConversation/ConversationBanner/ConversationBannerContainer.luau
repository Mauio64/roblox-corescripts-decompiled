local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local conversationTopModal = AppChatNetworking.Constants.ConversationTopModal
local conversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local ConversationTopModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationTopModalTelemetry")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local ConversationBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationBanner/ConversationBanner")

local v5 = {
	[conversationTopModal.AddTrustedConnection] = {
		onActivatedOverlayVariant = conversationOverlay.AddTrustedConnectionU18
	},
	[conversationTopModal.TrustedConnectionRequest] = {
		onActivatedOverlayVariant = conversationOverlay.TrustedConnectionRequestU18
	}
}

local v6 = {
	actionText = "PLACEHOLDER Action",
	bodyText = "PLACEHOLDER Body",
	onDismissed = function() end
}

local function ConversationBannerContainer(p2)
	local union = Cryo.Dictionary.union(v6, p2)
	local v7 = useNavigation()
	local v8 = v5[union.modalVariant]

	local v9 = useTelemetry(ChatDetailsTelemetryLayer.Context)
	local v10 = useGetConversationFromId(union.conversationId)
	local joined = if v10 and v10.participants then table.concat(v10.participants, ",") else nil

	local v11 = useGetOneToOneFriendIdFromConversationId(union.conversationId)
	React.useEffect(function()
		v9.emit(ConversationTopModalTelemetry.Events.ModalRendered, {
			modalVariant = union.modalVariant,
			modalContext = joined
		})
	end, { union.modalVariant })

	local v12 = React.useCallback(function()
		union.onDismissed()
		v9.emit(ConversationTopModalTelemetry.Events.ModalAction, {
			modalVariant = union.modalVariant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss,
			modalContext = joined
		})
	end, { union.onDismissed })

	local v13 = React.useCallback(function()
		if v8 then
			v7.navigate(EnumScreens.TrustedConnectionsUpsell, {
				userId = v11,
				modalVariant = v8.onActivatedOverlayVariant,
				conversationId = union.conversationId,
				isOverlay = true
			})
		end

		v9.emit(ConversationTopModalTelemetry.Events.ModalAction, {
			modalVariant = union.modalVariant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
			modalContext = joined
		})
	end, { v7, v8, v11 })

	if v8 then
		return React.createElement(ConversationBanner, {
			actionText = union.actionText,
			bodyText = union.bodyText,
			onDismissed = v12,
			onActivated = v13,
			layoutOrder = union.layoutOrder
		})
	end

	return nil
end

return React.memo(ConversationBannerContainer)
