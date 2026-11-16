local parent = script:FindFirstAncestor("Squads").Parent
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

return function()
	return useAppPolicy(function(p)
		return p.getCanAccessParty()
	end)
end
