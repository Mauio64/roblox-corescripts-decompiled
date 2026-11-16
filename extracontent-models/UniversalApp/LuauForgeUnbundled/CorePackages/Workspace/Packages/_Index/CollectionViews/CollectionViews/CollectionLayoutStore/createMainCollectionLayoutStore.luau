local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Display")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes")
local createCollectionLayoutStore = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/createCollectionLayoutStore")

local fFlagEnableHomePageSduiPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagEnableHomePageSduiPrefetch

local function createMainCollectionLayoutStore()
	local displayStore = Display.GetDisplayStore(false)

	local signal, v5 = Signals.createSignal(nil)

	local computed = Signals.createComputed(function(p2)
		local v6 = signal(p2)

		if v6 then
			return v6
		end

		return displayStore.getViewportSize(p2).X
	end)
	local v6

	if fFlagEnableHomePageSduiPrefetch then
		v6 = Signals.createComputed(function(p2): boolean
			local v7 = signal(p2)
			return v7 ~= nil and v7 > 0
		end)
	end

	local v7 = createCollectionLayoutStore(computed)
	return {
		getContainerWidth = v7.getContainerWidth,
		getDesignSpaceContainerWidth = v7.getDesignSpaceContainerWidth,
		getItemsPerRow = v7.getItemsPerRow,
		getNumItemsForAllCategories = v7.getNumItemsForAllCategories,
		getIsContainerMeasured = v6,
		setDefaultContentRegionWidth = v5
	}
end

return createMainCollectionLayoutStore
