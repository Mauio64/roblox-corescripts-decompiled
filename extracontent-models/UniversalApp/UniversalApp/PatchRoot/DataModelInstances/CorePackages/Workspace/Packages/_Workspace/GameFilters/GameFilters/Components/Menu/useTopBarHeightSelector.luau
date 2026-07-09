local Parent = script:FindFirstAncestor("GameFilters").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

local function useTopBarHeightSelector() -- line: 7
	-- upvalues: useSelector (copy)
	return useSelector(function(p1) -- line: 8
		return p1.TopBar.topBarHeight
	end)
end

return useTopBarHeightSelector
