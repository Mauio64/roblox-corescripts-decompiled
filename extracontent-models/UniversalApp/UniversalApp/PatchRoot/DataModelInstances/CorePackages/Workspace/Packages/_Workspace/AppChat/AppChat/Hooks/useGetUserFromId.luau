local Parent = script:FindFirstAncestor("AppChat").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

return function(s1: string?) -- line: 6
	-- upvalues: useSelector (copy)
	return useSelector(function(p1) -- line: 7
		-- upvalues: s1 (copy)
		if s1 then
			return p1.Users[s1]
		end

		return nil
	end)
end
