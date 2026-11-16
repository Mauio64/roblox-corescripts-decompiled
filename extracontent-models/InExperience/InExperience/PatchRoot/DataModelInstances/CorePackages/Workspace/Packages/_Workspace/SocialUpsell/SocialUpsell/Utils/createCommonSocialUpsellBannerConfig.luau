local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local Foundation = require(parent.Foundation)

require(SocialUpsell.Types)
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)

local isCompactUpsellBanner = require(script.Parent.isCompactUpsellBanner)

local ShieldCheck = Foundation.Enums.IconName.ShieldCheck
local SpeechBubbleAlignCenter = Foundation.Enums.IconName.SpeechBubbleAlignCenter

local function getBannerIcon(data)
	if data.image then
		return nil
	end

	if data.icon then
		return data.icon
	end

	if data.type == SocialUpsellType.FacialAgeEstimation then
		if isCompactUpsellBanner(data) then
			return ShieldCheck
		end

		return SpeechBubbleAlignCenter
	end

	if data.type == SocialUpsellType.ConversationFacialAgeEstimation then
	end

	return nil
end

return function(state)
	local icon

	if not state.image then
		if state.icon then
			icon = state.icon
		elseif state.type == SocialUpsellType.FacialAgeEstimation then
			if isCompactUpsellBanner(state) then
				icon = ShieldCheck
			else
				icon = SpeechBubbleAlignCenter
			end
		else
			local _ = state.type == SocialUpsellType.ConversationFacialAgeEstimation
		end
	end

	state.icon = icon
	return state
end
