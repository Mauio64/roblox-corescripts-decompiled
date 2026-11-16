local parent = script:FindFirstAncestor("GameFilters").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useTopBarHeightSelector()
	return useSelector(function(p)
		return p.TopBar.topBarHeight
	end)
end

return useTopBarHeightSelector
