local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Enums = require(ParentParentParent.Foundation).Enums
local BadgeType = require(ParentParent.Enums.BadgeType)
local GetFFlagIAPExperienceEnableBestValueBadge = require(ParentParent.Flags.GetFFlagIAPExperienceEnableBestValueBadge)

local function getUpsellBadgeInfo(p1, t1: {[any]: any}) -- line: 24
	-- upvalues: BadgeType (copy), GetFFlagIAPExperienceEnableBestValueBadge (copy), Enums (copy)
	local v9 = if p1 ~= BadgeType.Popular then if p1 ~= BadgeType.LastPurchased then if p1 ~= BadgeType.ForYou then if p1 ~= BadgeType.BetterValue then if p1 ~= BadgeType.BestValue or not GetFFlagIAPExperienceEnableBestValueBadge() then nil else t1.BestValue else t1.BetterValue else t1.ForYouItem else t1.LastPurchased else t1.Popular
	local v10 = if p1 ~= BadgeType.Popular then if p1 ~= BadgeType.ForYou then if p1 ~= BadgeType.BetterValue then if p1 ~= BadgeType.BestValue or not GetFFlagIAPExperienceEnableBestValueBadge() then nil else Enums.IconName.Pig else Enums.IconName.Tag else Enums.IconName.CircleStar else Enums.IconName.Flame

	return {
		text = v9,
		icon = v10
	}
end

return getUpsellBadgeInfo
