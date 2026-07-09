local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

return function() -- line: 8
	-- upvalues: useSelector (copy)
	return useSelector(function(p1) -- line: 9
		if not p1.TopBar then
			return 0
		end

		if p1.TopBar.topBarHeight then
			return p1.TopBar.topBarHeight
		end

		return 0
	end)
end
