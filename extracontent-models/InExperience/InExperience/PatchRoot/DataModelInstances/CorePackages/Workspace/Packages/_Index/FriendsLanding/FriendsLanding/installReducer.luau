local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking

return function()
	local combineReducers = rodux.combineReducers
	local Friends = require(script.Friends)
	return combineReducers({
		Friends = Friends(),
		NetworkStatus = roduxNetworking.installReducer()
	})
end
