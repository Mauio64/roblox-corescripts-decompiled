local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local RoduxFriends = dependencies.RoduxFriends
local convertActions = dependencies.convertActions
local friendsActionAdaptor = dependencies.friendsActionAdaptor
local t1 = {
	countsByUserId = {},
	byUserId = {},
	requests = {
		receivedCount = 0,
		newFriendRequestsCount = 0
	},
	recommendations = {},
	friendshipStatus = {},
	friendsRankByUserId = {}
}

return convertActions(RoduxFriends.installReducer(), friendsActionAdaptor(RoduxFriends), t1)
