local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local Signals = require(CollectionViewsParent.Signals)
local Display = require(CollectionViewsParent.Display)
local CollectionItemSize = require(CollectionViews.CollectionViewTypes).CollectionItemSize
local CollectionBreakpointConfig = require(script.Parent.CollectionBreakpointConfig)
local resolveBreakpoint = CollectionBreakpointConfig.resolveBreakpoint
local getItemsPerRow = CollectionBreakpointConfig.getItemsPerRow

local function createCollectionLayoutStore(p1, p2) -- line: 24
	-- upvalues: Display (copy), Signals (copy), resolveBreakpoint (copy), CollectionItemSize (copy), getItemsPerRow (copy)
	local getPlatformScale = Display.GetDisplayStore(false).getPlatformScale
	local v13 = Signals.createComputed(function(p3) -- line: 30
		-- upvalues: p1 (copy)
		return p1(p3) > 0
	end)
	local v14 = if not p2 then p1 else Signals.createComputed(function(p4) -- line: 35
		-- upvalues: p1 (copy), p2 (copy)
		local v23 = p1(p4)

		if v23 > 0 then
			return v23
		end

		return p2.getContainerWidth(p4)
	end)
	local v15 = Signals.createComputed(function(p5) -- line: 44
		-- upvalues: v14 (copy), getPlatformScale (copy)
		return v14(p5) / getPlatformScale(p5)
	end)
	local v16 = Signals.createComputed(function(p6) -- line: 48
		-- upvalues: resolveBreakpoint (copy), v15 (copy)
		return resolveBreakpoint(v15(p6))
	end)
	local t1 = {}

	for _, v19 in {
		CollectionItemSize.XSmall,
		CollectionItemSize.Small,
		CollectionItemSize.Medium,
		CollectionItemSize.Large,
		CollectionItemSize.XLarge
	} do
		t1[v19] = Signals.createComputed(function(p7) -- line: 62
			-- upvalues: getItemsPerRow (copy), v16 (copy), v19 (copy)
			return getItemsPerRow(v16(p7), v19)
		end)
	end

	local v20 = Signals.createComputed(function(p8) -- line: 68
		-- upvalues: t1 (copy)
		local t2 = {}

		for v29, v30 in t1 do
			t2[v29] = v30(p8)
		end

		return t2
	end)

	return {
		getContainerWidth = v14,
		getDesignSpaceContainerWidth = v15,
		getItemsPerRow = t1,
		getNumItemsForAllCategories = v20,
		getIsContainerMeasured = v13
	}
end

return createCollectionLayoutStore
