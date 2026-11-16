local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")

local Rodux = require(VerifiedBadges.Parent.Rodux)
local dependencies = require(VerifiedBadges.dependencies)
local roduxNetworking = dependencies.RoduxNetworking

local function installReducer()
	return Rodux.combineReducers({
		VerifiedUsers = require(script.VerifiedUsers),
		VerifiedGroups = require(script.VerifiedGroups),
		NetworkStatus = roduxNetworking.installReducer()
	})
end

return installReducer
