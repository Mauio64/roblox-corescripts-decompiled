local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local createBannerConfigFromModalConfiguration = require(AppChat.Utils.createBannerConfigFromModalConfiguration)
local fetchChatMetadata = require(AppChat.Conversations.Thunks.fetchChatMetadata)

local React = require(parent.React)
require(AppChat.types)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local useCallback = React.useCallback

local SocialUpsell = require(parent.SocialUpsell)
local Foundation = require(parent.Foundation)

local UpsellBanner = SocialUpsell.UpsellBanner

local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController

local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local ChatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local ConversationBottomModal = AppChatNetworking.Constants.ConversationBottomModal

local v2 = {
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = UpsellEntrySurfaceType.PartyTab,
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = UpsellEntrySurfaceType.PartyTab,
	[ConversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = UpsellEntrySurfaceType.PartyChatConversationUA,
	[ConversationBottomModal.NudgeToBottomChatUpsell] = UpsellEntrySurfaceType.PartyChatConversationUA
}

local v3 = {
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = UpsellEntrySurfaceType.PartyTabInExperience,
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = UpsellEntrySurfaceType.PartyTabInExperience,
	[ConversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = UpsellEntrySurfaceType.PartyChatConversationInExperience,
	[ConversationBottomModal.NudgeToBottomChatUpsell] = UpsellEntrySurfaceType.PartyChatConversationInExperience
}

local v4 = {
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = true,
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = true,
	[ConversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = false,
	[ConversationBottomModal.NudgeToBottomChatUpsell] = false
}

local v5 = {
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = "padding-x-medium padding-top-xxsmall padding-bottom-large align-x-center auto-y size-full-0",
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = "padding-x-medium padding-top-xxsmall padding-bottom-large align-x-center auto-y size-full-0",
	[ConversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = "padding-large align-x-center auto-y size-full-0 stroke-standard stroke-default bg-shift-100",
	[ConversationBottomModal.NudgeToBottomChatUpsell] = "padding-large align-x-center auto-y size-full-0 stroke-standard stroke-default bg-shift-100"
}

local function AppChatFAEBanner(props)
	local v6 = useDispatch()
	local v7 = useIsInExperience()
	local v8 = useCallback(function()
		v6(fetchChatMetadata())
	end, { v6, fetchChatMetadata })

	local modalConfiguration = props.modalConfiguration
	local upsellEntrySurface

	if v7 then
		upsellEntrySurface = v3[modalConfiguration.modal_variant]
	else
		upsellEntrySurface = v2[modalConfiguration.modal_variant]
	end

	local v9 = useSocialUpsellOverlayController(v7)
	local onPrimaryAction = React.useCallback(function(_: string)
		v6(startFacialAgeEstimation(
			SocialUpsell.Enums.SocialUpsellType.FacialAgeEstimation .. upsellEntrySurface,
			v8,
			nil,
			upsellEntrySurface,
			v7
		))
	end, { v6, upsellEntrySurface, v7 })
	local onSecondaryAction = React.useCallback(function(impressionId: string)
		v9.openSocialOverlay(SocialUpsell.Enums.SocialUpsellType.FacialAgeEstimation, {
			upsellEntrySurface = upsellEntrySurface,
			upsellEntryComponent = UpsellComponent.Banner,
			impressionId = impressionId
		})
	end, { v9.openSocialOverlay, upsellEntrySurface })

	local bannerConfigFromModalConfiguration = createBannerConfigFromModalConfiguration(modalConfiguration)

	local v10 = React.useCallback(function(_: string)
		if not bannerConfigFromModalConfiguration.isDismissable then
			v:warning("attempt to call AppChatFAEBanner onDismiss not provided and banner is not dismissable")
		end
	end, {})
	local onDismiss = props.onDismiss or v10

	local isContained = v4[modalConfiguration.modal_variant]
	local tag = v5[modalConfiguration.modal_variant]

	return React.createElement(Foundation.View, { tag = tag }, {
		UpsellBanner = React.createElement(UpsellBanner, {
			config = bannerConfigFromModalConfiguration,
			isContained = isContained,
			onPrimaryAction = onPrimaryAction,
			onSecondaryAction = onSecondaryAction,
			onDismiss = onDismiss,
			upsellEntrySurface = upsellEntrySurface,
			upsellEntryComponent = UpsellComponent.Banner,
			conversationId = props.conversationId
		})
	})
end

return React.memo(AppChatFAEBanner)
