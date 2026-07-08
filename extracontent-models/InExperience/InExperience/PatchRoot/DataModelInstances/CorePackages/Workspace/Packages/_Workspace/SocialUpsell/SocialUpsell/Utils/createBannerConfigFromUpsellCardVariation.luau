local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local getDeepValue = require(SocialUpsellParent.SocialCommon).Utils.getDeepValue
local createCommonSocialUpsellBannerConfig = require(script.Parent.createCommonSocialUpsellBannerConfig)

require(SocialUpsell.Types)

local Constants = require(SocialUpsell.Constants)
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local SharedFlags = require(SocialUpsellParent.SharedFlags)
local FFlagAgeBasedUXHomepageVerificationBannerLockIcon = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerLockIcon
local FFlagAgeBasedUXHomepageVerificationBannerGreyButton = SharedFlags.FFlagAgeBasedUXHomepageVerificationBannerGreyButton
local t1 = {
	OpenFaeUpsell = Constants.UPSELL_BUTTON_ACTION.Primary,
	OpenFaeViewDetails = Constants.UPSELL_BUTTON_ACTION.Secondary,
	Dismiss = Constants.UPSELL_BUTTON_ACTION.Dismiss
}
local t2 = {
	Fae = SocialUpsellType.FacialAgeEstimation
}

local function getButtonAction(t3: {[any]: any}) -- line: 69
	-- upvalues: t1 (copy)
	if t3.action and t3.action.type then
		return t1[t3.action.type]
	end

	return nil
end

return function(t4: {[any]: any}, t5: {[any]: any}?) -- line: 76
	-- upvalues: t2 (copy), SocialUpsellType (copy), Constants (copy), t1 (copy), FFlagAgeBasedUXHomepageVerificationBannerGreyButton (copy), createCommonSocialUpsellBannerConfig (copy), getDeepValue (copy), FFlagAgeBasedUXHomepageVerificationBannerLockIcon (copy)
	local v16 = t2[t4.upsellCardType] or SocialUpsellType.Unknown
	local upsellCardV2Config = t4.upsellCardV2Config
	local t6 = {}
	local t7 = {}

	if upsellCardV2Config.label_items then
		for _, v21 in upsellCardV2Config.label_items do
			if v21.type == "Countdown" and v21.metadata and v21.metadata.countdown_text then
				table.insert(t6, {
					type = Constants.UPSELL_LABEL_ITEM_TYPE_COUNTDOWN,
					text = v21.metadata.countdown_text
				})
			end
		end
	end

	if upsellCardV2Config.buttons then
		for _, v23 in upsellCardV2Config.buttons do
			local v24 = if not v23.action or not v23.action.type then nil else t1[v23.action.type]

			if v24 then
				table.insert(t7, {
					text = v23.text,
					action = v24,
					variantOverride = if not FFlagAgeBasedUXHomepageVerificationBannerGreyButton or (not t5 or v24 ~= Constants.UPSELL_BUTTON_ACTION.Primary) then nil else t5.primaryButtonVariantOverride
				})
			end
		end
	end

	return createCommonSocialUpsellBannerConfig({
		type = v16,
		title = getDeepValue(upsellCardV2Config, "header.text"),
		body = getDeepValue(upsellCardV2Config, "body.text"),
		image = getDeepValue(upsellCardV2Config, "image"),
		isDismissable = getDeepValue(upsellCardV2Config, "dismissable"),
		labelItems = t6,
		buttons = t7,
		icon = if not FFlagAgeBasedUXHomepageVerificationBannerLockIcon or not t5 then nil else t5.iconOverride
	})
end
