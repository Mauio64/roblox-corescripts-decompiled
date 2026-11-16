local GameFilters = script:FindFirstAncestor("GameFilters")

local parent = GameFilters.Parent
require(parent.DiscoveryTypes)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local GameFiltersReducer = require(GameFilters.DataStore.GameFiltersReducer)

local function useGameFiltersSelector(p: string)
	return (useSelector(function(p2)
		return p2.Personalization[GameFiltersReducer.key][p]
	end))
end

return useGameFiltersSelector
