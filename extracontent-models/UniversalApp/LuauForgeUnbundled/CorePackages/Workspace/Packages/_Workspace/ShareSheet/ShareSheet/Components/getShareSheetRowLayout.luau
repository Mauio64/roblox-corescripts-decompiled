require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppComposition")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/CollectionViews")

local function getShareSheetRowLayout(p2, data, p3, p4)
	local margin = data.margin
	local gutter = data.gutter
	local v5 = p3 ~= Enum.DisplaySize.Small and 0 or data.carouselPeek
	local v6 = v5 > 0 and 1 or 0
	local numColumns = CollectionViews.calculateNumColumns(p4, gutter, 1, 1e999, p2 - 2 * margin - v5)
	local itemWidth = CollectionViews.calculateItemWidth(numColumns, gutter, margin, p2, 0, v5)
	local v7 = math.floor(itemWidth)
	local v8 = math.round((itemWidth - v7) * numColumns)

	return {
		margin = margin,
		gap = gutter,
		visibleTileCount = numColumns + v6,
		maxTileCount = v5 > 0 and 1e999 or numColumns,
		getTileWidth = function(p5)
			if p5 <= v8 then
				return v7 + 1
			end

			return v7
		end,
		isScrollingEnabled = function(p5): boolean
			return numColumns < p5
		end
	}
end

return getShareSheetRowLayout
