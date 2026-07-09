local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy

return function() -- line: 6
	-- upvalues: useAppPolicy (copy)
	return useAppPolicy(function(p1) -- line: 7
		return p1.getEnableProfileQrCode()
	end)
end
