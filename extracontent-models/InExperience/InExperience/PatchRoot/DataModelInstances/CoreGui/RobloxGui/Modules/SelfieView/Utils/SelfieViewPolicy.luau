local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v = PolicyProvider.withGetPolicyImplementation(memStorageService)

function v.Mapper(p)
	return {
		eligibleForSelfieViewFeature = function()
			return p.EligibleForSelfieViewFeature or false
		end
	}
end

v.PolicyImplementation = memStorageService

return v
