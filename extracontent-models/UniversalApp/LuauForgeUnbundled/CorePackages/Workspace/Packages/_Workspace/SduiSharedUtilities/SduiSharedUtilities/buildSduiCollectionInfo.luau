local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/CollectionViews")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Display")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags")
local getPreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getPreferredTextSizeLineBudget")

local fIntLuaAppSduiCarouselPlaceholderHeaderHeightPx = SharedFlags.FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx
local fFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets

local function buildSduiCollectionInfo(p2, p3, value)
	local displayStore = Display.GetDisplayStore(false)
	local mainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore(false)

	local viewportSize = displayStore.getViewportSize(false)
	local topBarHeight = displayStore.getTopBarHeight(false)
	local platformScale = displayStore.getPlatformScale(false)
	local v5 = not (platformScale and platformScale > 0) and 1 or platformScale
	local designSpaceContainerWidth = mainCollectionLayoutStore.getDesignSpaceContainerWidth(false)
	local numItemsForAllCategories = mainCollectionLayoutStore.getNumItemsForAllCategories(false)

	local v6 = (viewportSize.Y - topBarHeight) / v5

	local v7 = designSpaceContainerWidth / math.max(1, numItemsForAllCategories[p2] or 1) * p3.Scale + p3.Offset

	if fFlagSduiPreferredTextSizeLineBudgets then
		local v8 = math.max(value or 0, 0)

		if v8 > 0 then
			v7 += getPreferredTextSizeLineBudget(require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/TextSize").getTextSizeStore(false).getTextSizeOffset(false) or 0, v8) / v5
		end
	end

	local v8 = fIntLuaAppSduiCarouselPlaceholderHeaderHeightPx + 12 + v7 + 16

	return {
		items_per_row = numItemsForAllCategories,
		rows_above_fold = not (v8 > 0) and 1 or math.max(1, (math.floor(v6 / v8))) + 1
	}
end

return buildSduiCollectionInfo
