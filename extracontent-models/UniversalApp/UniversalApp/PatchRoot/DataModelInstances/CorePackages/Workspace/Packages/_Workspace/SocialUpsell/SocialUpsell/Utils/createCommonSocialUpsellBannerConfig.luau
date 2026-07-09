local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local Foundation = require(SocialUpsellParent.Foundation)

require(SocialUpsell.Types)

local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local isCompactUpsellBanner = require(script.Parent.isCompactUpsellBanner)
local ShieldCheck = Foundation.Enums.IconName.ShieldCheck
local SpeechBubbleAlignCenter = Foundation.Enums.IconName.SpeechBubbleAlignCenter

local function getBannerIcon(p1) -- line: 16
	-- upvalues: SocialUpsellType (copy), isCompactUpsellBanner (copy), ShieldCheck (copy), SpeechBubbleAlignCenter (copy)
	if p1.image then
		return nil
	end

	if p1.icon then
		return p1.icon
	end

	if p1.type == SocialUpsellType.FacialAgeEstimation then
		if isCompactUpsellBanner(p1) then
			return ShieldCheck
		end

		return SpeechBubbleAlignCenter
	end

	if p1.type == SocialUpsellType.ConversationFacialAgeEstimation then
		return nil
	end

	return nil
end

return function(p2) -- line: 32
	-- upvalues: SocialUpsellType (copy), isCompactUpsellBanner (copy), ShieldCheck (copy), SpeechBubbleAlignCenter (copy)
	p2.icon = if not p2.image then if not p2.icon then if p2.type ~= SocialUpsellType.FacialAgeEstimation then if p2.type ~= SocialUpsellType.ConversationFacialAgeEstimation then nil else nil else if not isCompactUpsellBanner(p2) then SpeechBubbleAlignCenter else ShieldCheck else p2.icon else nil

	return p2
end
