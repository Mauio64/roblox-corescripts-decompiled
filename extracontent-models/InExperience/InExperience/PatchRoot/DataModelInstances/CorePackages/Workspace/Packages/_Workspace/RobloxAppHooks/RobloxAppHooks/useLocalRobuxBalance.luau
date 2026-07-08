local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalUserId = require(script.Parent.useLocalUserId)

return function() -- line: 7
	-- upvalues: useLocalUserId (copy), useSelector (copy)
	local v4 = useLocalUserId()

	return useSelector(function(p1) -- line: 9
		-- upvalues: v4 (copy)
		return p1.UserRobux[v4]
	end)
end
