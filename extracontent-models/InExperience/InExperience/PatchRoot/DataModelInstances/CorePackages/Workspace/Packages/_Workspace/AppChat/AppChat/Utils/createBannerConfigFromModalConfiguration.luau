local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local SocialCommon = require(Parent.SocialCommon)
local SocialUpsell = require(Parent.SocialUpsell)
local AppChatNetworking = require(Parent.AppChatNetworking)
local SocialUpsellType = require(Parent.SocialUpsell).Enums.SocialUpsellType
local getDeepValue = SocialCommon.Utils.getDeepValue
local createCommonSocialUpsellBannerConfig = SocialUpsell.Utils.createCommonSocialUpsellBannerConfig
local Constants = SocialUpsell.Constants
local ChatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local ConversationBottomModal = AppChatNetworking.Constants.ConversationBottomModal
local t1 = {
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal] = SocialUpsellType.FacialAgeEstimation,
	[ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal] = SocialUpsellType.FacialAgeEstimation,
	[ConversationBottomModal.ConversationBottomAgeVerificationRequiredModal] = SocialUpsellType.ConversationFacialAgeEstimation,
	[ConversationBottomModal.NudgeToBottomChatUpsell] = SocialUpsellType.ConversationFacialAgeEstimation
}
local t2 = {
	open_fae_upsell = Constants.UPSELL_BUTTON_ACTION.Primary,
	open_fae_view_details = Constants.UPSELL_BUTTON_ACTION.Secondary,
	dismiss = Constants.UPSELL_BUTTON_ACTION.Dismiss
}

local function getCountdownLabelItem(p1) -- line: 44
	-- upvalues: getDeepValue (copy), Cryo (copy), AppChatNetworking (copy), Constants (copy)
	local t3 = nil
	local v18 = getDeepValue(p1, "modal_layout.header.additional_content")

	if v18 then
		local v19 = Cryo.List.findWhere(v18, function(p2) -- line: 48
			-- upvalues: AppChatNetworking (copy)
			return p2.type == AppChatNetworking.Constants.ModalContentType.Countdown
		end)

		if v19 and v18[v19].text then
			t3 = {
				type = Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN,
				text = v18[v19].text
			}
		end
	end

	return t3
end
local function getButtonAction(p3) -- line: 62
	-- upvalues: t2 (copy)
	if p3.action and p3.action.type then
		return t2[p3.action.type]
	end

	return nil
end

return function(p4) -- line: 69
	-- upvalues: t1 (copy), SocialUpsellType (copy), getDeepValue (copy), getCountdownLabelItem (copy), Cryo (copy), t2 (copy), createCommonSocialUpsellBannerConfig (copy)
	local v22 = t1[p4.modal_variant] or SocialUpsellType.Unknown
	local t4 = {}
	local v24 = getDeepValue(p4, "modal_layout.buttons")
	local v25 = getCountdownLabelItem(p4)

	if v25 then
		table.insert(t4, v25)
	end

	local v26 = Cryo.List.filterMap(v24, function(p5) -- line: 79
		-- upvalues: t2 (copy)
		local v29 = if not p5.action or not p5.action.type then nil else t2[p5.action.type]

		if v29 and p5.text then
			return {
				text = p5.text,
				action = v29
			}
		end

		return nil
	end)

	return createCommonSocialUpsellBannerConfig({
		type = v22,
		title = getDeepValue(p4, "modal_layout.header.text"),
		body = getDeepValue(p4, "modal_layout.body.text"),
		isDismissable = getDeepValue(p4, "modal_layout.dismissible"),
		labelItems = t4,
		buttons = v26
	})
end
