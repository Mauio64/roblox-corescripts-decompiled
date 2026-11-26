local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies")
local roduxFriends = dependencies.RoduxFriends
local convertActions = dependencies.convertActions
local friendsActionAdaptor = dependencies.friendsActionAdaptor

return convertActions(roduxFriends.installReducer(), friendsActionAdaptor(roduxFriends), {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0, newFriendRequestsCount = 0 },
	recommendations = {},
	friendshipStatus = {},
	friendsRankByUserId = {}
})
