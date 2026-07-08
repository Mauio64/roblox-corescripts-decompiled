local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local Display = require(CollectionViewsParent.Display)
local Signals = require(CollectionViewsParent.Signals)

require(CollectionViews.CollectionViewTypes)

local createCollectionLayoutStore = require(script.Parent.createCollectionLayoutStore)

local function createMainCollectionLayoutStore() -- line: 17
	-- upvalues: Display (copy), Signals (copy), createCollectionLayoutStore (copy)
	local v7 = Display.GetDisplayStore(false)
	local v8, v9 = Signals.createSignal(nil)
	local v10 = Signals.createComputed(function(p1) -- line: 22
		-- upvalues: v8 (copy), v7 (copy)
		local v13 = v8(p1)

		if v13 then
			return v13
		end

		return v7.getViewportSize(p1).X
	end)
	local v11 = createCollectionLayoutStore(v10)

	return {
		getContainerWidth = v11.getContainerWidth,
		getDesignSpaceContainerWidth = v11.getDesignSpaceContainerWidth,
		getItemsPerRow = v11.getItemsPerRow,
		getNumItemsForAllCategories = v11.getNumItemsForAllCategories,
		setDefaultContentRegionWidth = v9
	}
end

return createMainCollectionLayoutStore
