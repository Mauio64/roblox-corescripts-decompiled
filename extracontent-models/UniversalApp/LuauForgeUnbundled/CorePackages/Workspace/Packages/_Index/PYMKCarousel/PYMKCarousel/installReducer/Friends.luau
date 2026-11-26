local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local roduxFriends = dependencies.RoduxFriends
local convertActions = dependencies.convertActions
local friendsActionAdaptor = dependencies.friendsActionAdaptor
local llama = dependencies.llama
local friendsOmniActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/friendsOmniActionAdaptor")
local v5 = {
	countsByUserId = {},
	byUserId = {},
	requests = {
		receivedCount = 0,
		newFriendRequestsCount = 0,
		byUserId = {},
		mutualFriends = {},
		sentAt = {},
		sourceUniverseIds = {}
	},
	recommendations = { byUserId = {}, bySource = {} },
	friendshipStatus = {},
	friendsRankByUserId = {}
}

local v6 = roduxFriends.installReducer()

return function(p2)
	return convertActions(v6, llama.Dictionary.join(friendsActionAdaptor(roduxFriends), friendsOmniActionAdaptor(p2)), v5)
end
