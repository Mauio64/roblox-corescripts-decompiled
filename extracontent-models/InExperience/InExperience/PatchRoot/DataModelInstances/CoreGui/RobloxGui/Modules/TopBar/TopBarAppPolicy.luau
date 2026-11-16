local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v = PolicyProvider.withGetPolicyImplementation(memStorageService)

function v.Mapper(p)
	return {
		showBadgeOver12 = not FFlagShowGameAgeRating and function()
			return p.ShowBadgeOver12 or false
		end or nil
	}
end

return v
