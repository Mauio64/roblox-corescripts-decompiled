local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local getFoundationMappedStyleTokens = require(AvatarExperienceHeadRefinement.Utils.getFoundationMappedStyleTokens)

local function getHeadShapeListHeight(t1: {[any]: any}) -- line: 16
	-- upvalues: getFoundationMappedStyleTokens (copy)
	local tokens = t1.tokens
	local v6 = getFoundationMappedStyleTokens(tokens)
	local itemCount = t1.itemCount
	local availableViewportHeight = t1.availableViewportHeight
	local containerPaddingTop = v6.containerPaddingTop
	local containerPaddingBottom = v6.containerPaddingBottom
	local largeTileContainerSize = v6.largeTileContainerSize
	local tileListPaddingTop = v6.tileListPaddingTop
	local tileListPaddingBottom = v6.tileListPaddingBottom
	local tileListPaddingBetweenItems = v6.tileListPaddingBetweenItems
	local Size_1000 = tokens.Size.Size_1000
	local v16 = tokens.Size.Size_800 * 2

	local function calculateHeightForRows(n1: number) -- line: 33
		-- upvalues: largeTileContainerSize (copy), tileListPaddingBetweenItems (copy), tileListPaddingTop (copy), tileListPaddingBottom (copy)
		return largeTileContainerSize * n1 + (not (n1 > 1) and 0 or (n1 - 1) * tileListPaddingBetweenItems) + tileListPaddingTop + tileListPaddingBottom
	end

	local v18 = largeTileContainerSize * 1 + 0 + tileListPaddingTop + tileListPaddingBottom
	local v19 = largeTileContainerSize * 7 + 6 * tileListPaddingBetweenItems + tileListPaddingTop + tileListPaddingBottom
	local v20 = (not itemCount or not (itemCount > 0)) and 1 or math.ceil(itemCount / 4)

	return (math.clamp(math.min(largeTileContainerSize * v20 + (not (v20 > 1) and 0 or (v20 - 1) * tileListPaddingBetweenItems) + tileListPaddingTop + tileListPaddingBottom, availableViewportHeight - (containerPaddingTop + containerPaddingBottom + Size_1000 + v16)), v18, v19))
end

return getHeadShapeListHeight
