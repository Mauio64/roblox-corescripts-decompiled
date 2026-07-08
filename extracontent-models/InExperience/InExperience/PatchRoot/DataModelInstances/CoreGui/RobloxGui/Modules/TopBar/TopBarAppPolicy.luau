local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)
local v3 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v4 = PolicyProvider.withGetPolicyImplementation(v3)

function v4.Mapper(p1) -- line: 7
	return {
		getDisplayVoiceBetaBadge = function() -- line: 9
			-- upvalues: p1 (copy)
			return p1.DisplayVoiceBetaBadge or false
		end,
		showBadgeOver12 = function() -- line: 12
			-- upvalues: p1 (copy)
			return p1.ShowBadgeOver12 or false
		end
	}
end

return v4
