local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local Signals = require(parent.Signals)
local Display = require(parent.Display)

local CollectionViewTypes = require(CollectionViews.CollectionViewTypes)
local CollectionItemSize = CollectionViewTypes.CollectionItemSize
local CollectionBreakpointConfig = require(script.Parent.CollectionBreakpointConfig)
local resolveBreakpoint = CollectionBreakpointConfig.resolveBreakpoint
local getItemsPerRow = CollectionBreakpointConfig.getItemsPerRow

local function createCollectionLayoutStore(callback, p)
	local getPlatformScale = Display.GetDisplayStore(false).getPlatformScale

	local getIsContainerMeasured = Signals.createComputed(function(p2): boolean
		return callback(p2) > 0
	end)
	local getContainerWidth

	if p then
		getContainerWidth = Signals.createComputed(function(p2)
			local v = callback(p2)

			if v > 0 then
				return v
			end

			return p.getContainerWidth(p2)
		end)
	else
		getContainerWidth = callback
	end

	local getDesignSpaceContainerWidth = Signals.createComputed(function(p2)
		return getContainerWidth(p2) / getPlatformScale(p2)
	end)

	local computed = Signals.createComputed(function(p2)
		return resolveBreakpoint(getDesignSpaceContainerWidth(p2))
	end)

	local getItemsPerRow2 = {}

	for _, v in {
		CollectionItemSize.XSmall,
		CollectionItemSize.Small,
		CollectionItemSize.Medium,
		CollectionItemSize.Large,
		CollectionItemSize.XLarge
	} do
		getItemsPerRow2[v] = Signals.createComputed(function(p2)
			return getItemsPerRow(computed(p2), v)
		end)
	end

	return {
		getContainerWidth = getContainerWidth,
		getDesignSpaceContainerWidth = getDesignSpaceContainerWidth,
		getItemsPerRow = getItemsPerRow2,
		getNumItemsForAllCategories = Signals.createComputed(function(p2)
			local result = {}

			for k, v in getItemsPerRow2 do
				result[k] = v(p2)
			end

			return result
		end),
		getIsContainerMeasured = getIsContainerMeasured
	}
end

return createCollectionLayoutStore
