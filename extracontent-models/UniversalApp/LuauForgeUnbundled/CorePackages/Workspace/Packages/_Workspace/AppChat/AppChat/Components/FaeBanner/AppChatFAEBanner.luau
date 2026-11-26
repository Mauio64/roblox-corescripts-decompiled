local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local createBannerConfigFromModalConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/createBannerConfigFromModalConfiguration")
local fetchChatMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchChatMetadata")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChatFAEBanner")
local useCallback = React.useCallback

local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialUpsell")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local upsellBanner = SocialUpsell.UpsellBanner

local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController

local upsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local upsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local chatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local conversationBottomModal = AppChatNetworking.Constants.ConversationBottomModal

local v6 = {
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = upsellEntrySurfaceType.PartyTab,
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = upsellEntrySurfaceType.PartyTab,
	[conversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = upsellEntrySurfaceType.PartyChatConversationUA,
	[conversationBottomModal.NudgeToBottomChatUpsell] = upsellEntrySurfaceType.PartyChatConversationUA
}

local v7 = {
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = upsellEntrySurfaceType.PartyTabInExperience,
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = upsellEntrySurfaceType.PartyTabInExperience,
	[conversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = upsellEntrySurfaceType.PartyChatConversationInExperience,
	[conversationBottomModal.NudgeToBottomChatUpsell] = upsellEntrySurfaceType.PartyChatConversationInExperience
}

local v8 = {
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = true,
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = true,
	[conversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = false,
	[conversationBottomModal.NudgeToBottomChatUpsell] = false
}

local v9 = {
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = "padding-x-medium padding-top-xxsmall padding-bottom-large align-x-center auto-y size-full-0",
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = "padding-x-medium padding-top-xxsmall padding-bottom-large align-x-center auto-y size-full-0",
	[conversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = "padding-large align-x-center auto-y size-full-0 stroke-standard stroke-default bg-shift-100",
	[conversationBottomModal.NudgeToBottomChatUpsell] = "padding-large align-x-center auto-y size-full-0 stroke-standard stroke-default bg-shift-100"
}

local function AppChatFAEBanner(props)
	local v10 = useDispatch()
	local v11 = useIsInExperience()
	local v12 = useCallback(function()
		v10(fetchChatMetadata())
	end, { v10, fetchChatMetadata })

	local modalConfiguration = props.modalConfiguration

	local v13 = if v11 then v7[modalConfiguration.modal_variant] else v6[modalConfiguration.modal_variant]

	local v14 = useSocialUpsellOverlayController(v11)
	local v15 = React.useCallback(function(p2)
		v10(startFacialAgeEstimation(
			SocialUpsell.Enums.SocialUpsellType.FacialAgeEstimation .. v13,
			v12,
			nil,
			v13,
			v11
		))
	end, { v10, v13, v11 })
	local v16 = React.useCallback(function(p2)
		v14.openSocialOverlay(SocialUpsell.Enums.SocialUpsellType.FacialAgeEstimation, {
			upsellEntrySurface = v13,
			upsellEntryComponent = upsellComponent.Banner,
			impressionId = p2
		})
	end, { v14.openSocialOverlay, v13 })

	local v17 = createBannerConfigFromModalConfiguration(modalConfiguration)

	local v18 = React.useCallback(function(p2)
		if not v17.isDismissable then
			v5:warning("attempt to call AppChatFAEBanner onDismiss not provided and banner is not dismissable")
		end
	end, {})
	local onDismiss = props.onDismiss or v18

	local v19 = v8[modalConfiguration.modal_variant]
	local v20 = v9[modalConfiguration.modal_variant]

	return React.createElement(Foundation.View, { tag = v20 }, {
		UpsellBanner = React.createElement(upsellBanner, {
			config = v17,
			isContained = v19,
			onPrimaryAction = v15,
			onSecondaryAction = v16,
			onDismiss = onDismiss,
			upsellEntrySurface = v13,
			upsellEntryComponent = upsellComponent.Banner,
			conversationId = props.conversationId
		})
	})
end

return React.memo(AppChatFAEBanner)
