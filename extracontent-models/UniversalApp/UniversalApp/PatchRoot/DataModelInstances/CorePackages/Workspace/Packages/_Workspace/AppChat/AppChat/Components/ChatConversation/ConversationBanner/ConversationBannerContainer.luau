local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)

require(AppChat.types)

local ConversationTopModal = AppChatNetworking.Constants.ConversationTopModal
local ConversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local EnumScreens = require(AppChat.EnumScreens)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ConversationTopModalTelemetry = require(script.Parent.Parent.ConversationTopModalTelemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)

require(AppChat.Models.ConversationChannels)

local ConversationBanner = require(script.Parent.ConversationBanner)
local t1 = {
	[ConversationTopModal.AddTrustedConnection] = {
		onActivatedOverlayVariant = ConversationOverlay.AddTrustedConnectionU18
	},
	[ConversationTopModal.TrustedConnectionRequest] = {
		onActivatedOverlayVariant = ConversationOverlay.TrustedConnectionRequestU18
	}
}
local t2 = {
	actionText = "PLACEHOLDER Action",
	bodyText = "PLACEHOLDER Body",
	onDismissed = function() -- line: 53
	end
}

local function ConversationBannerContainer(t3: {[any]: any}) -- line: 56
	-- upvalues: Cryo (copy), t2 (copy), useNavigation (copy), t1 (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), useGetConversationFromId (copy), React (copy), ConversationTopModalTelemetry (copy), ModalTelemetry (copy), EnumScreens (copy), ConversationBanner (copy)
	local v20 = Cryo.Dictionary.union(t2, t3)
	local v21 = useNavigation()
	local v22 = t1[v20.modalVariant]
	local u23 = nil
	local v24 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v25 = useGetConversationFromId(v20.conversationId)

	if v25 and v25.participants then
		u23 = table.concat(v25.participants, ",")
	end

	React.useEffect(function() -- line: 66
		-- upvalues: v24 (copy), ConversationTopModalTelemetry (copy), v20 (copy), u23 (ref)
		v24.emit(ConversationTopModalTelemetry.Events.ModalRendered, {
			modalVariant = v20.modalVariant,
			modalContext = u23
		})
	end, { v20.modalVariant })

	local v26 = React.useCallback(function() -- line: 73
		-- upvalues: v20 (copy), v24 (copy), ConversationTopModalTelemetry (copy), ModalTelemetry (copy), u23 (ref)
		v20.onDismissed()
		v24.emit(ConversationTopModalTelemetry.Events.ModalAction, {
			modalVariant = v20.modalVariant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss,
			modalContext = u23
		})
	end, { v20.onDismissed })
	local v27 = React.useCallback(function() -- line: 82
		-- upvalues: v22 (copy), v21 (copy), EnumScreens (copy), v20 (copy), v24 (copy), ConversationTopModalTelemetry (copy), ModalTelemetry (copy), u23 (ref)
		if v22 then
			v21.navigate(EnumScreens.TrustedConnectionsUpsell, {
				isOverlay = true,
				modalVariant = v22.onActivatedOverlayVariant,
				conversationId = v20.conversationId
			})
		end

		v24.emit(ConversationTopModalTelemetry.Events.ModalAction, {
			modalVariant = v20.modalVariant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
			modalContext = u23
		})
	end, {
		v21,
		v22
	})

	if v22 then
		return React.createElement(ConversationBanner, {
			actionText = v20.actionText,
			bodyText = v20.bodyText,
			onDismissed = v26,
			onActivated = v27,
			layoutOrder = v20.layoutOrder
		})
	end

	return nil
end

return React.memo(ConversationBannerContainer)
