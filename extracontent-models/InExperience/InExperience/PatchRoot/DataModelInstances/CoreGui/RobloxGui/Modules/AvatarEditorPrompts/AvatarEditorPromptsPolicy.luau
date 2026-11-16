local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v = PolicyProvider.withGetPolicyImplementation(memStorageService)

function v.Mapper(p)
	return {
		getCustomOutfitNames = function()
			return p.CustomCostumeNames == nil or p.CustomCostumeNames
		end
	}
end

return v
