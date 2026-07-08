local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)
local v3 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v4 = PolicyProvider.withGetPolicyImplementation(v3)

function v4.Mapper(_) -- line: 7
	return {}
end

return v4
