local parent = script.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local Enums = Foundation.Enums

local BadgeType = require(parent.Enums.BadgeType)

local GetFFlagIAPExperienceEnableBestValueBadge = require(parent.Flags.GetFFlagIAPExperienceEnableBestValueBadge)

local function getUpsellBadgeInfo(p, data)
	local text

	if p == BadgeType.Popular then
		text = data.Popular
	elseif p == BadgeType.LastPurchased then
		text = data.LastPurchased
	elseif p == BadgeType.ForYou then
		text = data.ForYouItem
	elseif p == BadgeType.BetterValue then
		text = data.BetterValue
	elseif p == BadgeType.BestValue and GetFFlagIAPExperienceEnableBestValueBadge() then
		text = data.BestValue
	end

	local icon

	if p == BadgeType.Popular then
		icon = Enums.IconName.Flame
	elseif p == BadgeType.ForYou then
		icon = Enums.IconName.CircleStar
	elseif p == BadgeType.BetterValue then
		icon = Enums.IconName.Tag
	elseif p == BadgeType.BestValue and GetFFlagIAPExperienceEnableBestValueBadge() then
		icon = Enums.IconName.Pig
	end

	return { text = text, icon = icon }
end

return getUpsellBadgeInfo
