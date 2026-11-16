local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local SocialCommon = require(parent.SocialCommon)

local getDeepValue = SocialCommon.Utils.getDeepValue
local createCommonSocialUpsellBannerConfig = require(script.Parent.createCommonSocialUpsellBannerConfig)

require(SocialUpsell.Types)
local Constants = require(SocialUpsell.Constants)
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local SharedFlags = require(parent.SharedFlags)
local FFlagAgeBasedUXHomepageVerificationBannerLockIcon = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerLockIcon

local FFlagAgeBasedUXHomepageVerificationBannerGreyButton = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerGreyButton

local v = {
	["OpenFaeUpsell"] = Constants.UPSELL_BUTTON_ACTION.Primary,
	OpenFaeViewDetails = Constants.UPSELL_BUTTON_ACTION.Secondary,
	Dismiss = Constants.UPSELL_BUTTON_ACTION.Dismiss
}

local v2 = { Fae = SocialUpsellType.FacialAgeEstimation }

local function getButtonAction(button) -- 1 equivalent call inferred from this helper
	if button.action and button.action.type then
		return v[button.action.type]
	end

	return nil
end

return function(p, p2)
	local v3 = v2[p.upsellCardType] or SocialUpsellType.Unknown
	local upsellCardV2Config = p.upsellCardV2Config

	local labelItems = {}
	local buttons = {}

	if upsellCardV2Config.label_items then
		for _, label_item in upsellCardV2Config.label_items do
			if label_item.type == "Countdown" and label_item.metadata and label_item.metadata.countdown_text then
				table.insert(labelItems, {
					type = Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN,
					text = label_item.metadata.countdown_text
				})
			end
		end
	end

	if upsellCardV2Config.buttons then
		for _, button in upsellCardV2Config.buttons do
			local buttonAction = getButtonAction(button) -- inferred equivalent call

			if not buttonAction then
				continue
			end

			local v4 = { text = button.text, action = buttonAction, variantOverride = 0 }
			local variantOverride

			if
				FFlagAgeBasedUXHomepageVerificationBannerGreyButton
				and p2
				and buttonAction == Constants.UPSELL_BUTTON_ACTION.Primary
			then
				variantOverride = p2.primaryButtonVariantOverride
			end

			v4.variantOverride = variantOverride
			table.insert(buttons, v4)
		end
	end

	local v4 = {
		type = v3,
		title = getDeepValue(upsellCardV2Config, "header.text"),
		body = getDeepValue(upsellCardV2Config, "body.text"),
		image = getDeepValue(upsellCardV2Config, "image"),
		isDismissable = getDeepValue(upsellCardV2Config, "dismissable"),
		labelItems = labelItems,
		buttons = buttons,
		icon = 0
	}
	local icon

	if FFlagAgeBasedUXHomepageVerificationBannerLockIcon and p2 then
		icon = p2.iconOverride
	end

	v4.icon = icon
	return createCommonSocialUpsellBannerConfig(v4)
end
