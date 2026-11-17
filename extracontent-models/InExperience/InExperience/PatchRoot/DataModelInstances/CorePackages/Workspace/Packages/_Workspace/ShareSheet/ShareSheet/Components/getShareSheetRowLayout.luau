local parent = script:FindFirstAncestor("ShareSheet").Parent

require(parent.AppComposition)
local CollectionViews = require(parent.CollectionViews)

local function getShareSheetRowLayout(p: number, data, p2, p3: number)
	local margin = data.margin
	local gutter = data.gutter
	local v = p2 ~= Enum.DisplaySize.Small and 0 or data.carouselPeek
	local v2 = v > 0 and 1 or 0
	local numColumns = CollectionViews.calculateNumColumns(p3, gutter, 1, 1e999, p - 2 * margin - v)
	local itemWidth = CollectionViews.calculateItemWidth(numColumns, gutter, margin, p, 0, v)
	local v3 = math.floor(itemWidth)
	local v4 = math.round((itemWidth - v3) * numColumns)

	return {
		margin = margin,
		gap = gutter,
		visibleTileCount = numColumns + v2,
		maxTileCount = v > 0 and 1e999 or numColumns,
		getTileWidth = function(p4: number)
			if p4 <= v4 then
				return v3 + 1
			end

			return v3
		end,
		isScrollingEnabled = function(p4: number): boolean
			return numColumns < p4
		end
	}
end

return getShareSheetRowLayout
