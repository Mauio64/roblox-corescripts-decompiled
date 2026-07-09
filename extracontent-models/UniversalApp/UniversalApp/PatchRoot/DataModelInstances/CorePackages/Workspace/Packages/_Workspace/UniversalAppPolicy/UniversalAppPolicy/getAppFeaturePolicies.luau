local UniversalAppGetPolicy = require(script.Parent.UniversalAppGetPolicy)
local AppFeaturePolicies = require(script.Parent.AppFeaturePolicies)

return function() -- line: 8
	-- upvalues: UniversalAppGetPolicy (copy), AppFeaturePolicies (copy)
	local v3 = UniversalAppGetPolicy.read() or {}

	return AppFeaturePolicies(v3)
end
