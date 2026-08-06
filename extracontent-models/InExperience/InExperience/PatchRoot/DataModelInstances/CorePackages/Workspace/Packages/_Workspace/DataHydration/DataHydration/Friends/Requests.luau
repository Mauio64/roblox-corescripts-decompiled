local GetFindFriendsPage = require(script.GetFindFriendsPage)
local GetOnlineFriends = require(script.GetOnlineFriends)
local MultiGetFriendshipStatuses = require(script.MultiGetFriendshipStatuses)
local RequestFriendshipFromUserId = require(script.RequestFriendshipFromUserId)
local AcceptFriendRequestFromUserId = require(script.AcceptFriendRequestFromUserId)
local DeclineFriendRequestFromUserId = require(script.DeclineFriendRequestFromUserId)

return {
	GetFindFriendsPage = GetFindFriendsPage,
	GetOnlineFriends = GetOnlineFriends,
	MultiGetFriendshipStatuses = MultiGetFriendshipStatuses,
	RequestFriendshipFromUserId = RequestFriendshipFromUserId,
	AcceptFriendRequestFromUserId = AcceptFriendRequestFromUserId,
	DeclineFriendRequestFromUserId = DeclineFriendRequestFromUserId
}
