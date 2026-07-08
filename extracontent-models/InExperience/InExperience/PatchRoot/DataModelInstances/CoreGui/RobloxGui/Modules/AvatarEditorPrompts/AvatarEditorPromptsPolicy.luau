local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)
local v3 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v4 = PolicyProvider.withGetPolicyImplementation(v3)

function v4.Mapper(p1) -- line: 11
	return {
		getCustomOutfitNames = function() -- line: 13
			-- upvalues: p1 (copy)
			if p1.CustomCostumeNames ~= nil then
				return p1.CustomCostumeNames
			end

			return true
		end
	}
end

return v4
