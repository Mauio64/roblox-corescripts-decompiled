local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local Display = require(parent.Display)
local Signals = require(parent.Signals)

require(CollectionViews.CollectionViewTypes)
local createCollectionLayoutStore = require(script.Parent.createCollectionLayoutStore)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableHomePageSduiPrefetch = SharedFlags.FFlagEnableHomePageSduiPrefetch

local function createMainCollectionLayoutStore()
	local displayStore = Display.GetDisplayStore(false)

	local signal, setDefaultContentRegionWidth = Signals.createSignal(nil)

	local computed = Signals.createComputed(function(p)
		return signal(p) or displayStore.getViewportSize(p).X
	end)
	local getIsContainerMeasured

	if FFlagEnableHomePageSduiPrefetch then
		getIsContainerMeasured = Signals.createComputed(function(p): boolean
			local v = signal(p)
			return v ~= nil and v > 0
		end)
	end

	local collectionLayoutStore = createCollectionLayoutStore(computed)
	return {
		getContainerWidth = collectionLayoutStore.getContainerWidth,
		getDesignSpaceContainerWidth = collectionLayoutStore.getDesignSpaceContainerWidth,
		getItemsPerRow = collectionLayoutStore.getItemsPerRow,
		getNumItemsForAllCategories = collectionLayoutStore.getNumItemsForAllCategories,
		getIsContainerMeasured = getIsContainerMeasured,
		setDefaultContentRegionWidth = setDefaultContentRegionWidth
	}
end

return createMainCollectionLayoutStore
