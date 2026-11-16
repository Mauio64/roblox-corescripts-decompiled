local parent = script:FindFirstAncestor("EditProfile").Parent
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

return function()
	return useAppPolicy(function(p)
		return p.getRealNamesInDisplayNamesEnabled()
	end)
end
