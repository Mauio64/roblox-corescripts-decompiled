local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RoactUtils").Hooks.RoactRodux.useSelector

local function useTopBarHeightSelector()
	return useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)
end

return useTopBarHeightSelector
