local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Signals")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Display")

local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes").CollectionItemSize

local function createColumnSpanCollectionLayoutStore(p2, callback, callback2)
	local getPlatformScale = Display.GetDisplayStore(false).getPlatformScale

	local computed = Signals.createComputed(function(p3): boolean
		return callback2(p3) > 0
	end)

	local computed2 = Signals.createComputed(function(p3)
		local v5 = callback2(p3)

		if v5 > 0 then
			return v5
		end

		return p2.getContainerWidth(p3) * callback(p3)
	end)

	local computed3 = Signals.createComputed(function(p3)
		return computed2(p3) / getPlatformScale(p3)
	end)

	local v5 = {}

	for k, v6 in {
		collectionItemSize.XSmall,
		collectionItemSize.Small,
		collectionItemSize.Medium,
		collectionItemSize.Large,
		collectionItemSize.XLarge
	} do
		local v7 = p2.getItemsPerRow[v6]
		v5[v6] = Signals.createComputed(function(p3)
			return (math.max(1, (math.floor(v7(p3) * callback(p3) + 1e-6))))
		end)
	end

	return {
		getContainerWidth = computed2,
		getDesignSpaceContainerWidth = computed3,
		getItemsPerRow = v5,
		getNumItemsForAllCategories = Signals.createComputed(function(p3)
			local result = {}

			for k, v6 in v5 do
				result[k] = v6(p3)
			end

			return result
		end),
		getIsContainerMeasured = computed
	}
end

return createColumnSpanCollectionLayoutStore
