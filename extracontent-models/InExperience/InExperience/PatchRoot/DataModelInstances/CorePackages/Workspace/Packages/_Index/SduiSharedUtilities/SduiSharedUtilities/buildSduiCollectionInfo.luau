local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local CollectionViews = require(Parent.CollectionViews)
local Display = require(Parent.Display)
local FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx = require(Parent.SharedFlags).FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx

local function buildSduiCollectionInfo(s1: string, uDim: UDim) -- line: 26
	-- upvalues: Display (copy), CollectionViews (copy), FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx (copy)
	local v8 = Display.GetDisplayStore(false)
	local v9 = CollectionViews.getMainCollectionLayoutStore(false)
	local v10 = v8.getViewportSize(false)
	local v11 = v8.getTopBarHeight(false)
	local v12 = v8.getPlatformScale(false)
	local v13 = (not v12 or not (v12 > 0)) and 1 or v12
	local v14 = v9.getDesignSpaceContainerWidth(false)
	local v15 = v9.getNumItemsForAllCategories(false)
	local v16 = (v10.Y - v11) / v13
	local v17 = v14 / math.max(1, v15[s1] or 1) * uDim.Scale + uDim.Offset
	local v18 = FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx + 12 + v17 + 16
	local v19 = not (v18 > 0) and 1 or math.max(1, (math.floor(v16 / v18))) + 1

	return {
		items_per_row = v15,
		rows_above_fold = v19
	}
end

return buildSduiCollectionInfo
