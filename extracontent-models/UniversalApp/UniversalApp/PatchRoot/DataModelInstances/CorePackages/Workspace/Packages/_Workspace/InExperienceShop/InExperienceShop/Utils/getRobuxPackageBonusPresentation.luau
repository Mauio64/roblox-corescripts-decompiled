local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)
require(InExperienceShop.Api.promoteBonusRobuxPackageToTopPicks)

local BonusPromotionEligibility = require(InExperienceShop.Api.BonusPromotionEligibility)

local function getRobuxPackageBonusPresentation(p1, b1: boolean?, p2) -- line: 19
	-- upvalues: BonusPromotionEligibility (copy)
	local bonusItemDetails = p1.bonusItemDetails

	if bonusItemDetails == nil then
		return {
			hasBonusItem = false,
			bonusItemThumbnail = nil
		}
	end

	if b1 == true or p2 == BonusPromotionEligibility.Ineligible then
		return {
			hasBonusItem = false,
			bonusItemThumbnail = nil
		}
	end

	local thumbnail = bonusItemDetails.thumbnail

	if thumbnail == nil then
		return {
			hasBonusItem = false,
			bonusItemThumbnail = nil
		}
	end

	return {
		hasBonusItem = true,
		bonusItemThumbnail = thumbnail
	}
end

return getRobuxPackageBonusPresentation
