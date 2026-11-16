local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking

local Friends = require(script.Parent.Friends)

return function()
	return rodux.combineReducers({
		Friends = Friends,
		NetworkStatus = roduxNetworking.installReducer()
	})
end
