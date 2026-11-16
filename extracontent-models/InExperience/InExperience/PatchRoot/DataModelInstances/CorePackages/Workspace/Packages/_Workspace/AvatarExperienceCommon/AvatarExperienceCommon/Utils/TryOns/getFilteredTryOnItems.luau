local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

require(AvatarExperienceCommon.Parent.AvatarExperienceModel)

local getTryOnItemComparisonData = require(script.Parent.getTryOnItemComparisonData)
local getShouldReplaceTryOn = require(script.Parent.getShouldReplaceTryOn)

function getFilteredTryOnItems(items, p)
	local tryOnItemComparisonData = getTryOnItemComparisonData(p)
	local result = {}
	local result2 = {}

	for k, item in items do
		if getShouldReplaceTryOn(tryOnItemComparisonData, (getTryOnItemComparisonData(item))) then
			result[k] = item
		else
			result2[k] = item
		end
	end

	return result2, result
end

return getFilteredTryOnItems
