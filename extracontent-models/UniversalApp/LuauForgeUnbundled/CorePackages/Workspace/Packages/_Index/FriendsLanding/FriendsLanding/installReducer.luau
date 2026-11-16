local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking

return function()
	return rodux.combineReducers({
		Friends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/installReducer/Friends")(),
		NetworkStatus = roduxNetworking.installReducer()
	})
end
