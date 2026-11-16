local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)
require(InExperienceShop.Api.promoteBonusRobuxPackageToTopPicks)
local BonusPromotionEligibility = require(InExperienceShop.Api.BonusPromotionEligibility)

local function getRobuxPackageBonusPresentation(p, flag: boolean?, p2)
	local bonusItemDetails = p.bonusItemDetails

	if bonusItemDetails == nil or (flag == true or p2 == BonusPromotionEligibility.Ineligible) then
		return { hasBonusItem = false, bonusItemThumbnail = nil }
	end

	local thumbnail = bonusItemDetails.thumbnail

	if thumbnail == nil then
		return { hasBonusItem = false, bonusItemThumbnail = nil }
	end

	return { hasBonusItem = true, bonusItemThumbnail = thumbnail }
end

return getRobuxPackageBonusPresentation
