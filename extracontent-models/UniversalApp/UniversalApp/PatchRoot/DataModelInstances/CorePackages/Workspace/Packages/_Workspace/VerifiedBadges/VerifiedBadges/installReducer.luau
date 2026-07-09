local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local Rodux = require(VerifiedBadges.Parent.Rodux)
local RoduxNetworking = require(VerifiedBadges.dependencies).RoduxNetworking

local function installReducer() -- line: 12
	-- upvalues: Rodux (copy), RoduxNetworking (copy)
	return Rodux.combineReducers({
		VerifiedUsers = require(script.VerifiedUsers),
		VerifiedGroups = require(script.VerifiedGroups),
		NetworkStatus = RoduxNetworking.installReducer()
	})
end

return installReducer
