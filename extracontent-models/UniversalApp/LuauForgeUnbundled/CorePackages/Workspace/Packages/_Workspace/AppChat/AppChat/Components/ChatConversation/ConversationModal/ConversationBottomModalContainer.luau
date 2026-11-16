local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local conversationBottomModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking").Constants.ConversationBottomModal
local ModalConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ModalConfiguration")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local SocialExperiments = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments")
local fFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE

local ConversationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationModal/ConversationModal")
local AppChatFAEBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/FaeBanner/AppChatFAEBanner")

local v5 = {
	shouldShowLegacyBottomModal = false,
	onHeightChanged = function(p2) end
}

local function ConversationBottomModalContainer(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local v6 = useSelector(function(p3)
		return getDeepValue2(p3, `ChatAppReducer.Modals.conversationBottomModals.{union.conversationId}`)
			or ModalConfiguration.default
	end)

	local v7 = React.useCallback(function(p3)
		union.onHeightChanged(p3.AbsoluteSize.Y)
	end, { union.onHeightChanged })
	local v8

	if not (union.shouldShowChatInputBar or not v6 or v6.modal_variant == nil or v6.modal_variant == conversationBottomModal.None) then
		v8 = React.createElement(AppChatFAEBanner, {
			modalConfiguration = v6,
			conversationId = union.conversationId
		})
	end

	if fFlagTestDeviceForFAEUpsell and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	if not v8 and union.shouldShowLegacyBottomModal then
		v8 = React.createElement(ConversationModal, { bodyText = union.legacyBottomModalText })
	end

	return React.createElement(
		Foundation.View,
		{
			LayoutOrder = union.layoutOrder,
			onAbsoluteSizeChanged = v7,
			tag = "auto-y size-full-0"
		},
		{ ConversationBottomModal = v8 }
	)
end

return React.memo(ConversationBottomModalContainer)
