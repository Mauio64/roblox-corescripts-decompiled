local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Rodux")
local roduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/dependencies").RoduxNetworking

local function installReducer()
	return Rodux.combineReducers({
		VerifiedUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/installReducer/VerifiedUsers"),
		VerifiedGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/installReducer/VerifiedGroups"),
		NetworkStatus = roduxNetworking.installReducer()
	})
end

return installReducer
