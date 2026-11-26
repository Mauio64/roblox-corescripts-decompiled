local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialUpsell")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local socialUpsellType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialUpsell").Enums.SocialUpsellType

local getDeepValue = SocialCommon.Utils.getDeepValue
local createCommonSocialUpsellBannerConfig = SocialUpsell.Utils.createCommonSocialUpsellBannerConfig

local constants = SocialUpsell.Constants

local chatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local conversationBottomModal = AppChatNetworking.Constants.ConversationBottomModal

local v5 = {
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = socialUpsellType.FacialAgeEstimation,
	[chatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = socialUpsellType.FacialAgeEstimation,
	[conversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = socialUpsellType.ConversationFacialAgeEstimation,
	[conversationBottomModal.NudgeToBottomChatUpsell] = socialUpsellType.ConversationFacialAgeEstimation
}

local v6 = {
	["open_fae_upsell"] = constants.UPSELL_BUTTON_ACTION.Primary,
	open_fae_view_details = constants.UPSELL_BUTTON_ACTION.Secondary,
	dismiss = constants.UPSELL_BUTTON_ACTION.Dismiss
}

local function getCountdownLabelItem(p2)
	local countdownLabelItem = nil
	local deepValue = getDeepValue(p2, "modal_layout.header.additional_content")

	if deepValue then
		local where = Cryo.List.findWhere(deepValue, function(p3): boolean
			return p3.type == AppChatNetworking.Constants.ModalContentType.Countdown
		end)

		countdownLabelItem = where
			and deepValue[where].text
			and {
				type = constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN,
				text = deepValue[where].text
			}
			or countdownLabelItem
	end

	return countdownLabelItem
end

local function getButtonAction(p2)
	if p2.action and p2.action.type then
		return v6[p2.action.type]
	end

	return nil
end

return function(p2)
	local v7 = v5[p2.modal_variant] or socialUpsellType.Unknown
	local countdownLabelItems = {}
	local deepValue = getDeepValue(p2, "modal_layout.buttons")
	local countdownLabelItem = getCountdownLabelItem(p2)

	if countdownLabelItem then
		table.insert(countdownLabelItems, countdownLabelItem)
	end

	local filterMap = Cryo.List.filterMap(deepValue, function(p3)
		local v8 = if p3.action and p3.action.type then v6[p3.action.type] else nil

		if v8 and p3.text then
			return { text = p3.text, action = v8 }
		end

		return nil
	end)

	return createCommonSocialUpsellBannerConfig({
		type = v7,
		title = getDeepValue(p2, "modal_layout.header.text"),
		body = getDeepValue(p2, "modal_layout.body.text"),
		isDismissable = getDeepValue(p2, "modal_layout.dismissible"),
		labelItems = countdownLabelItems,
		buttons = filterMap
	})
end
