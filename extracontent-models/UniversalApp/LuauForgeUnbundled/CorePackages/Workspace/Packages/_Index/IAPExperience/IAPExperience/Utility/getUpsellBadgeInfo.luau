local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Enums

local BadgeType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/BadgeType")

local GetFFlagIAPExperienceEnableBestValueBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFFlagIAPExperienceEnableBestValueBadge")

local function getUpsellBadgeInfo(p2, data)
	local v5

	if p2 == BadgeType.Popular then
		v5 = data.Popular
	elseif p2 == BadgeType.LastPurchased then
		v5 = data.LastPurchased
	elseif p2 == BadgeType.ForYou then
		v5 = data.ForYouItem
	elseif p2 == BadgeType.BetterValue then
		v5 = data.BetterValue
	elseif p2 == BadgeType.BestValue and GetFFlagIAPExperienceEnableBestValueBadge() then
		v5 = data.BestValue
	end

	local v6

	if p2 == BadgeType.Popular then
		v6 = enums.IconName.Flame
	elseif p2 == BadgeType.ForYou then
		v6 = enums.IconName.CircleStar
	elseif p2 == BadgeType.BetterValue then
		v6 = enums.IconName.Tag
	elseif p2 == BadgeType.BestValue and GetFFlagIAPExperienceEnableBestValueBadge() then
		v6 = enums.IconName.Pig
	end

	return { text = v5, icon = v6 }
end

return getUpsellBadgeInfo
