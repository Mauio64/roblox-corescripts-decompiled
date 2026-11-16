require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RoactUtils").Hooks.RoactRodux.useSelector

local GameFiltersReducer = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/DataStore/GameFiltersReducer")

local function useGameFiltersSelector(p2)
	return (useSelector(function(p3)
		return p3.Personalization[GameFiltersReducer.key][p2]
	end))
end

return useGameFiltersSelector
