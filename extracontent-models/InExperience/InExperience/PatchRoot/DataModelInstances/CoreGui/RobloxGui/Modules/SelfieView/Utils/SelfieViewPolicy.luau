local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)
local v3 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v4 = PolicyProvider.withGetPolicyImplementation(v3)

function v4.Mapper(p1) -- line: 7
	return {
		eligibleForSelfieViewFeature = function() -- line: 9
			-- upvalues: p1 (copy)
			return p1.EligibleForSelfieViewFeature or false
		end
	}
end

v4.PolicyImplementation = v3

return v4
