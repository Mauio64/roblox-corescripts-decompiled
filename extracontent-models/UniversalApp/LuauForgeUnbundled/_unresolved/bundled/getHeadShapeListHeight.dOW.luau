local module = require("@luauforge/bundled/dOD")

local function getHeadShapeListHeight(data)
	local tokens = data.tokens
	local v5 = module(tokens)
	local itemCount = data.itemCount
	local availableViewportHeight = data.availableViewportHeight

	local containerPaddingTop = v5.containerPaddingTop
	local containerPaddingBottom = v5.containerPaddingBottom
	local largeTileContainerSize = v5.largeTileContainerSize
	local tileListPaddingTop = v5.tileListPaddingTop
	local tileListPaddingBottom = v5.tileListPaddingBottom
	local tileListPaddingBetweenItems = v5.tileListPaddingBetweenItems
	local size_1000 = tokens.Size.Size_1000
	local v6 = tokens.Size.Size_800 * 2

	local function calculateHeightForRows(p2)
		return largeTileContainerSize * p2 + (not (p2 > 1) and 0 or (p2 - 1) * tileListPaddingBetweenItems) + tileListPaddingTop + tileListPaddingBottom
	end

	local v7 = largeTileContainerSize * 1 + 0 + tileListPaddingTop + tileListPaddingBottom
	local v8 = largeTileContainerSize * 7 + 6 * tileListPaddingBetweenItems + tileListPaddingTop + tileListPaddingBottom

	local v9 = not (itemCount and itemCount > 0) and 1 or math.ceil(itemCount / 4)
	return (math.clamp(
		math.min(
			largeTileContainerSize * v9 + (not (v9 > 1) and 0 or (v9 - 1) * tileListPaddingBetweenItems) + tileListPaddingTop + tileListPaddingBottom,
			availableViewportHeight - (containerPaddingTop + containerPaddingBottom + size_1000 + v6)
		),
		v7,
		v8
	))
end

return getHeadShapeListHeight
