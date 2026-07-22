local Parent = script:FindFirstAncestor("Moments").Parent
local v2 = require(Parent.PolicyProvider).GetPolicyImplementations.MemStorageService("app-policy")

return function() -- line: 9
	-- upvalues: v2 (copy)
	return v2.read()
end
