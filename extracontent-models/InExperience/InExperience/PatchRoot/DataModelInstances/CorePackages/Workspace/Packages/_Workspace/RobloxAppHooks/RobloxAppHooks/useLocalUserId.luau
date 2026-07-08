local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

return function() -- line: 6
	-- upvalues: useSelector (copy)
	return useSelector(function(p1) -- line: 7
		return p1.LocalUserId
	end)
end
