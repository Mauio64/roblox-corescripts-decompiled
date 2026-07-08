local CollectionViews = script:FindFirstAncestor("CollectionViews")
local calculateSpacePerItem = require(CollectionViews.calculateSpacePerItem)

local function calculateCarouselSpacingMetrics(n1: number, n2: number, n3: number, n4: number, n5: number, n6: number) -- line: 14
	-- upvalues: calculateSpacePerItem (copy)
	if n2 <= 0 then
		return {
			effectiveWidth = 0,
			stride = 0,
			renderedItemWidth = 0,
			renderedGap = 0,
			containerWidth = n1
		}
	end

	local v10 = n1 - n4 - n5 * n6
	local v11 = calculateSpacePerItem(n2, n3)
	local v12 = math.floor(v10 / n2 + 0.5) - v11.gapOffsetPerItem
	local v13 = math.floor(v11.adjustedGap + 0.5)

	return {
		containerWidth = n1,
		effectiveWidth = v10,
		stride = v12 + v13,
		renderedItemWidth = v12,
		renderedGap = v13
	}
end

return calculateCarouselSpacingMetrics
