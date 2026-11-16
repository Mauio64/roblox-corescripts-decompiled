local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)

local function hasOfferEligibleCategory(items): boolean
	for _, item in items do
		if item.id ~= Constants.HOME_CATEGORY_ID and item.name ~= Constants.ROBUX_CATEGORY_NAME then
			return true
		end
	end

	return false
end

return hasOfferEligibleCategory
