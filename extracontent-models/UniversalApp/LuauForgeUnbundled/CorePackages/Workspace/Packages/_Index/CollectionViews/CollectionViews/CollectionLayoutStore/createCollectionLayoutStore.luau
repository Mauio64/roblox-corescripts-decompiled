local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Signals")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Display")

local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes").CollectionItemSize
local CollectionBreakpointConfig = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/CollectionBreakpointConfig")
local resolveBreakpoint = CollectionBreakpointConfig.resolveBreakpoint
local getItemsPerRow = CollectionBreakpointConfig.getItemsPerRow

local function createCollectionLayoutStore(callback, p2)
	local getPlatformScale = Display.GetDisplayStore(false).getPlatformScale

	local computed = Signals.createComputed(function(p3): boolean
		return callback(p3) > 0
	end)
	local v5

	if p2 then
		v5 = Signals.createComputed(function(p3)
			local v6 = callback(p3)

			if v6 > 0 then
				return v6
			end

			return p2.getContainerWidth(p3)
		end)
	else
		v5 = callback
	end

	local computed2 = Signals.createComputed(function(p3)
		return v5(p3) / getPlatformScale(p3)
	end)

	local computed3 = Signals.createComputed(function(p3)
		return resolveBreakpoint(computed2(p3))
	end)

	local v6 = {}

	for k, v7 in {
		collectionItemSize.XSmall,
		collectionItemSize.Small,
		collectionItemSize.Medium,
		collectionItemSize.Large,
		collectionItemSize.XLarge
	} do
		v6[v7] = Signals.createComputed(function(p3)
			return getItemsPerRow(computed3(p3), v7)
		end)
	end

	return {
		getContainerWidth = v5,
		getDesignSpaceContainerWidth = computed2,
		getItemsPerRow = v6,
		getNumItemsForAllCategories = Signals.createComputed(function(p3)
			local result = {}

			for k, v7 in v6 do
				result[k] = v7(p3)
			end

			return result
		end),
		getIsContainerMeasured = computed
	}
end

return createCollectionLayoutStore
