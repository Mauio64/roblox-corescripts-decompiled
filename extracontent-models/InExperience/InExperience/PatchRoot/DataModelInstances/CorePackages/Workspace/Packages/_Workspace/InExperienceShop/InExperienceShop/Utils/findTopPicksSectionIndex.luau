local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)
local FFlagIdentifyTopPicksByCategoryType = require(InExperienceShop.Flags.FFlagIdentifyTopPicksByCategoryType)

local function findTopPicksSectionIndex(items)
	for k, item in items do
		if FFlagIdentifyTopPicksByCategoryType then
			if item.categoryType == Constants.TOP_PICKS_CATEGORY_TYPE then
				return k
			end

			if item.categoryType ~= nil then
				continue
			end
		end

		if string.lower(item.name) == "top picks" then
			return k
		end
	end

	return nil
end

return findTopPicksSectionIndex
