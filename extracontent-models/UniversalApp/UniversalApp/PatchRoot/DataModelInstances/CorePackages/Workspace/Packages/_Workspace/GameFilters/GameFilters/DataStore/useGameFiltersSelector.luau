local GameFilters = script:FindFirstAncestor("GameFilters")
local GameFiltersParent = GameFilters.Parent

require(GameFiltersParent.DiscoveryTypes)

local useSelector = require(GameFiltersParent.RoactUtils).Hooks.RoactRodux.useSelector
local GameFiltersReducer = require(GameFilters.DataStore.GameFiltersReducer)

local function useGameFiltersSelector(s1: string) -- line: 9
	-- upvalues: useSelector (copy), GameFiltersReducer (copy)
	return (useSelector(function(p1) -- line: 10
		-- upvalues: GameFiltersReducer (copy), s1 (copy)
		return p1.Personalization[GameFiltersReducer.key][s1]
	end))
end

return useGameFiltersSelector
