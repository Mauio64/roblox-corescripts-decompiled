local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
require(AppChat.types)

local AppChatNetworking = require(parent.AppChatNetworking)
local ConversationBottomModal = AppChatNetworking.Constants.ConversationBottomModal
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local SocialExperiments = require(parent.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE

local ConversationModal = require(script.Parent.ConversationModal)
local AppChatFAEBanner = require(AppChat.Components.FaeBanner.AppChatFAEBanner)

local v = {
	shouldShowLegacyBottomModal = false,
	onHeightChanged = function(_) end
}

local function ConversationBottomModalContainer(p)
	local union = Cryo.Dictionary.union(v, p)

	local modalConfiguration = useSelector(function(p2)
		return getDeepValue2(p2, `ChatAppReducer.Modals.conversationBottomModals.{union.conversationId}`)
			or ModalConfiguration.default
	end)

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		union.onHeightChanged(p2.AbsoluteSize.Y)
	end, { union.onHeightChanged })
	local conversationBottomModal

	if not (union.shouldShowChatInputBar or not modalConfiguration or modalConfiguration.modal_variant == nil or modalConfiguration.modal_variant == ConversationBottomModal.None) then
		conversationBottomModal = React.createElement(AppChatFAEBanner, {
			modalConfiguration = modalConfiguration,
			conversationId = union.conversationId
		})
	end

	if FFlagTestDeviceForFAEUpsell and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	if not conversationBottomModal and union.shouldShowLegacyBottomModal then
		conversationBottomModal = React.createElement(ConversationModal, {
			bodyText = union.legacyBottomModalText
		})
	end

	return React.createElement(
		Foundation.View,
		{
			LayoutOrder = union.layoutOrder,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			tag = "auto-y size-full-0"
		},
		{ ConversationBottomModal = conversationBottomModal }
	)
end

return React.memo(ConversationBottomModalContainer)
