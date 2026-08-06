local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

require(AvatarExperienceCommon.Enums.ItemTypeEnum)

local getTryOnItemComparisonData = require(script.Parent.getTryOnItemComparisonData)
local getShouldReplaceTryOn = require(script.Parent.getShouldReplaceTryOn)

function getFilteredTryOnItems(t1: {[any]: any}, t2: {[any]: any}) -- line: 8
	-- upvalues: getTryOnItemComparisonData (copy), getShouldReplaceTryOn (copy)
	local t3 = {}
	local t4 = {}
	local v8 = getTryOnItemComparisonData(t2)

	for v9, v10 in t1 do
		local v11 = getTryOnItemComparisonData(v10)

		if getShouldReplaceTryOn(v8, v11) then
			t4[v9] = v10
		else
			t3[v9] = v10
		end
	end

	return t3, t4
end

return getFilteredTryOnItems
