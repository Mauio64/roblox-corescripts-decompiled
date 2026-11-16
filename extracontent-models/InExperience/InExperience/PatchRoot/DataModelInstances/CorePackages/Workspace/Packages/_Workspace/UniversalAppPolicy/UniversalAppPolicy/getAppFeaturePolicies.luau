local UniversalAppGetPolicy = require(script.Parent.UniversalAppGetPolicy)
local AppFeaturePolicies = require(script.Parent.AppFeaturePolicies)

return function()
	return AppFeaturePolicies(UniversalAppGetPolicy.read() or {})
end
