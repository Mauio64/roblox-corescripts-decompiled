local Parent = script:FindFirstAncestor("EditProfile").Parent
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy

return function() -- line: 5
	-- upvalues: useAppPolicy (copy)
	return useAppPolicy(function(p1) -- line: 6
		return p1.getRealNamesInDisplayNamesEnabled()
	end)
end
