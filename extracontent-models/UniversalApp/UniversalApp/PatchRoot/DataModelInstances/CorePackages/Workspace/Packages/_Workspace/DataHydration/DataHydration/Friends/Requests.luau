local GetFindFriendsPage = require(script.GetFindFriendsPage)
local GetOnlineFriends = require(script.GetOnlineFriends)
local MultiGetFriendshipStatuses = require(script.MultiGetFriendshipStatuses)
local RequestFriendshipFromUserId = require(script.RequestFriendshipFromUserId)

return {
	GetFindFriendsPage = GetFindFriendsPage,
	GetOnlineFriends = GetOnlineFriends,
	MultiGetFriendshipStatuses = MultiGetFriendshipStatuses,
	RequestFriendshipFromUserId = RequestFriendshipFromUserId
}
