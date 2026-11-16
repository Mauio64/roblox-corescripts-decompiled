local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local SocialCommon = require(parent.SocialCommon)
local SocialUpsell = require(parent.SocialUpsell)
local AppChatNetworking = require(parent.AppChatNetworking)
local SocialUpsell2 = require(parent.SocialUpsell)
local SocialUpsellType = SocialUpsell2.Enums.SocialUpsellType

local getDeepValue = SocialCommon.Utils.getDeepValue
local createCommonSocialUpsellBannerConfig = SocialUpsell.Utils.createCommonSocialUpsellBannerConfig

local Constants = SocialUpsell.Constants

local ChatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local ConversationBottomModal = AppChatNetworking.Constants.ConversationBottomModal

local v = {
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = SocialUpsellType.FacialAgeEstimation,
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = SocialUpsellType.FacialAgeEstimation,
	[ConversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = SocialUpsellType.ConversationFacialAgeEstimation,
	[ConversationBottomModal.NudgeToBottomChatUpsell] = SocialUpsellType.ConversationFacialAgeEstimation
}

local v2 = {
	["open_fae_upsell"] = Constants.UPSELL_BUTTON_ACTION.Primary,
	open_fae_view_details = Constants.UPSELL_BUTTON_ACTION.Secondary,
	dismiss = Constants.UPSELL_BUTTON_ACTION.Dismiss
}

local function getCountdownLabelItem(p)
	local countdownLabelItem = nil
	local deepValue = getDeepValue(p, "modal_layout.header.additional_content")

	if deepValue then
		local where = Cryo.List.findWhere(deepValue, function(p2): boolean
			return p2.type == AppChatNetworking.Constants.ModalContentType.Countdown
		end)

		countdownLabelItem = where
			and deepValue[where].text
			and { type = Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN, text = deepValue[where].text }
			or countdownLabelItem
	end

	return countdownLabelItem
end

local function getButtonAction(p) -- 1 equivalent call inferred from this helper
	if p.action and p.action.type then
		return v2[p.action.type]
	end

	return nil
end

return function(p)
	local v3 = v[p.modal_variant] or SocialUpsellType.Unknown
	local countdownLabelItems = {}
	local deepValue = getDeepValue(p, "modal_layout.buttons")
	local countdownLabelItem = getCountdownLabelItem(p)

	if countdownLabelItem then
		table.insert(countdownLabelItems, countdownLabelItem)
	end

	local filterMap = Cryo.List.filterMap(deepValue, function(p2)
		local buttonAction = getButtonAction(p2) -- inferred equivalent call

		if buttonAction and p2.text then
			return { text = p2.text, action = buttonAction }
		end

		return nil
	end)

	return createCommonSocialUpsellBannerConfig({
		type = v3,
		title = getDeepValue(p, "modal_layout.header.text"),
		body = getDeepValue(p, "modal_layout.body.text"),
		isDismissable = getDeepValue(p, "modal_layout.dismissible"),
		labelItems = countdownLabelItems,
		buttons = filterMap
	})
end
