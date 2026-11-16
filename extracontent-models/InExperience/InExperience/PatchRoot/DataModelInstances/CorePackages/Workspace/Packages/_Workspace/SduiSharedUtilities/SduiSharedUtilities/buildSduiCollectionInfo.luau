local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local CollectionViews = require(parent.CollectionViews)
local Display = require(parent.Display)
local SharedFlags = require(parent.SharedFlags)
local getPreferredTextSizeLineBudget = require(SduiSharedUtilities.getPreferredTextSizeLineBudget)

local FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx = SharedFlags.FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx
local FFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets

local function buildSduiCollectionInfo(p: string, udim: UDim, value: number?)
	local displayStore = Display.GetDisplayStore(false)
	local mainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore(false)

	local viewportSize = displayStore.getViewportSize(false)
	local topBarHeight = displayStore.getTopBarHeight(false)
	local platformScale = displayStore.getPlatformScale(false)
	local v = not (platformScale and platformScale > 0) and 1 or platformScale
	local designSpaceContainerWidth = mainCollectionLayoutStore.getDesignSpaceContainerWidth(false)
	local numItemsForAllCategories = mainCollectionLayoutStore.getNumItemsForAllCategories(false)

	local v2 = (viewportSize.Y - topBarHeight) / v

	local v3 = designSpaceContainerWidth / math.max(1, numItemsForAllCategories[p] or 1) * udim.Scale + udim.Offset

	if FFlagSduiPreferredTextSizeLineBudgets then
		local v4 = math.max(value or 0, 0)

		if v4 > 0 then
			local TextSize = require(parent.TextSize)
			v3 += getPreferredTextSizeLineBudget(TextSize.getTextSizeStore(false).getTextSizeOffset(false) or 0, v4) / v
		end
	end

	local v4 = FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx + 12 + v3 + 16

	return {
		items_per_row = numItemsForAllCategories,
		rows_above_fold = not (v4 > 0) and 1 or math.max(1, (math.floor(v2 / v4))) + 1
	}
end

return buildSduiCollectionInfo
