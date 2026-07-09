local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent

require(AvatarExperienceCatalogParent.AvatarExperienceCommon)

local getTryOnItemComparisonData = require(AvatarExperienceCatalog.Utils.TryOns.getTryOnItemComparisonData)
local getShouldReplaceTryOn = require(AvatarExperienceCatalog.Utils.TryOns.getShouldReplaceTryOn)

function getFilteredTryOnItems(t1: {[any]: any}, t2: {[any]: any}) -- line: 9
	-- upvalues: getTryOnItemComparisonData (copy), getShouldReplaceTryOn (copy)
	local t3 = {}
	local t4 = {}
	local v9 = getTryOnItemComparisonData(t2)

	for v10, v11 in t1 do
		local v12 = getTryOnItemComparisonData(v11)

		if getShouldReplaceTryOn(v9, v12) then
			t4[v10] = v11
		else
			t3[v10] = v11
		end
	end

	return t3, t4
end

return getFilteredTryOnItems
