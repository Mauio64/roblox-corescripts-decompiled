local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialCommon").Utils.getDeepValue
local createCommonSocialUpsellBannerConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/createCommonSocialUpsellBannerConfig")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants")
local SocialUpsellType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags")
local fFlagAgeBasedUXHomepageVerificationBannerLockIcon = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerLockIcon

local fFlagAgeBasedUXHomepageVerificationBannerGreyButton = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerGreyButton

local v5 = {
	["OpenFaeUpsell"] = Constants.UPSELL_BUTTON_ACTION.Primary,
	OpenFaeViewDetails = Constants.UPSELL_BUTTON_ACTION.Secondary,
	Dismiss = Constants.UPSELL_BUTTON_ACTION.Dismiss
}

local v6 = { Fae = SocialUpsellType.FacialAgeEstimation }

local function getButtonAction(p2)
	if p2.action and p2.action.type then
		return v5[p2.action.type]
	end

	return nil
end

return function(p2, p3)
	local v7 = v6[p2.upsellCardType] or SocialUpsellType.Unknown
	local upsellCardV2Config = p2.upsellCardV2Config

	local v8 = {}
	local v9 = {}

	if upsellCardV2Config.label_items then
		for k, label_item in upsellCardV2Config.label_items do
			if
				label_item.type == "Countdown"
				and label_item.metadata
				and label_item.metadata.countdown_text
			then
				table.insert(v8, {
					type = Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN,
					text = label_item.metadata.countdown_text
				})
			end
		end
	end

	if upsellCardV2Config.buttons then
		for k, button in upsellCardV2Config.buttons do
			local v10 = if button.action and button.action.type then v5[button.action.type] else nil

			if not v10 then
				continue
			end

			local v11 = { text = button.text, action = v10, variantOverride = 0 }

			local v12 = if fFlagAgeBasedUXHomepageVerificationBannerGreyButton and p3 and v10 == Constants.UPSELL_BUTTON_ACTION.Primary then p3.primaryButtonVariantOverride else nil
			v11.variantOverride = v12
			table.insert(v9, v11)
		end
	end

	local v11 = {
		type = v7,
		title = getDeepValue(upsellCardV2Config, "header.text"),
		body = getDeepValue(upsellCardV2Config, "body.text"),
		image = getDeepValue(upsellCardV2Config, "image"),
		isDismissable = getDeepValue(upsellCardV2Config, "dismissable"),
		labelItems = v8,
		buttons = v9,
		icon = 0
	}

	local v12 = if fFlagAgeBasedUXHomepageVerificationBannerLockIcon and p3 then p3.iconOverride else nil
	v11.icon = v12
	return createCommonSocialUpsellBannerConfig(v11)
end
