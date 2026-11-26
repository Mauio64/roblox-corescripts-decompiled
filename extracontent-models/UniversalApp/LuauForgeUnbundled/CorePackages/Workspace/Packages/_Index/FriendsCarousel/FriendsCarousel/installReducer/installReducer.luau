local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies")

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/installReducer/Friends")

return function()
	return rodux.combineReducers({
		Friends = module2,
		NetworkStatus = roduxNetworking.installReducer()
	})
end
