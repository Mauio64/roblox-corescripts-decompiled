local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)

require(AppChat.types)

local ConversationBottomModal = require(AppChatParent.AppChatNetworking).Constants.ConversationBottomModal
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local SocialExperiments = require(AppChatParent.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE
local FFlagEnableAEGIS2AppChatConversationBanner = require(AppChatParent.SharedFlags).FFlagEnableAEGIS2AppChatConversationBanner
local FFlagAppChatNudgeToChatUpsellEnabled = require(AppChat.Flags.FFlagAppChatNudgeToChatUpsellEnabled)
local ConversationModal = require(script.Parent.ConversationModal)
local AppChatFAEBanner = require(AppChat.Components.FaeBanner.AppChatFAEBanner)
local t1 = {
	shouldShowLegacyBottomModal = false,
	onHeightChanged = function(_) -- line: 38
	end
}

local function ConversationBottomModalContainer(t2: {[any]: any}) -- line: 41
	-- upvalues: Cryo (copy), t1 (copy), useSelector (copy), getDeepValue2 (copy), ModalConfiguration (copy), React (copy), FFlagEnableAEGIS2AppChatConversationBanner (copy), FFlagAppChatNudgeToChatUpsellEnabled (copy), ConversationBottomModal (copy), AppChatFAEBanner (copy), FFlagTestDeviceForFAEUpsell (copy), deviceMeetsRequirementsForFAE (copy), ConversationModal (copy), Foundation (copy)
	local v21 = Cryo.Dictionary.union(t1, t2)
	local v22 = useSelector(function(p2) -- line: 45
		-- upvalues: getDeepValue2 (copy), v21 (copy), ModalConfiguration (copy)
		return getDeepValue2(p2, `ChatAppReducer.Modals.conversationBottomModals.{ v21.conversationId }`) or ModalConfiguration.default
	end)
	local v23 = React.useCallback(function(p3) -- line: 50
		-- upvalues: v21 (copy)
		v21.onHeightChanged(p3.AbsoluteSize.Y)
	end, { v21.onHeightChanged })
	local v24 = nil

	if (FFlagEnableAEGIS2AppChatConversationBanner or FFlagAppChatNudgeToChatUpsellEnabled) and (not v21.shouldShowChatInputBar and v22 and v22.modal_variant ~= nil and v22.modal_variant ~= ConversationBottomModal.None) then
		v24 = React.createElement(AppChatFAEBanner, {
			modalConfiguration = v22,
			conversationId = v21.conversationId
		})
	end

	if FFlagTestDeviceForFAEUpsell and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	if not v24 and v21.shouldShowLegacyBottomModal then
		v24 = React.createElement(ConversationModal, {
			bodyText = v21.legacyBottomModalText
		})
	end

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0",
		LayoutOrder = v21.layoutOrder,
		onAbsoluteSizeChanged = v23
	}, {
		ConversationBottomModal = v24
	})
end

return React.memo(ConversationBottomModalContainer)
