local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Foundation")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")
local SocialUpsellType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")

local isCompactUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/isCompactUpsellBanner")

local shieldCheck = Foundation.Enums.IconName.ShieldCheck
local speechBubbleAlignCenter = Foundation.Enums.IconName.SpeechBubbleAlignCenter

local function getBannerIcon(data)
	if data.image then
		return nil
	end

	if data.icon then
		return data.icon
	end

	if data.type == SocialUpsellType.FacialAgeEstimation then
		if isCompactUpsellBanner(data) then
			return shieldCheck
		end

		return speechBubbleAlignCenter
	end

	if data.type == SocialUpsellType.ConversationFacialAgeEstimation then
	end

	return nil
end

return function(state)
	local v5

	if not state.image then
		if state.icon then
			v5 = state.icon
		elseif state.type == SocialUpsellType.FacialAgeEstimation then
			v5 = if isCompactUpsellBanner(state) then shieldCheck else speechBubbleAlignCenter
		else
			local v6 = state.type == SocialUpsellType.ConversationFacialAgeEstimation
		end
	end

	state.icon = v5
	return state
end
