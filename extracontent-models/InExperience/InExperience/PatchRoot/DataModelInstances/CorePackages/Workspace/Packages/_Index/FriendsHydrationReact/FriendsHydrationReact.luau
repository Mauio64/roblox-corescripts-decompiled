local parent = script.Parent
require(parent.DataHydration)

return {
	["jest.config"] = script["jest.config"],
	useGetOnlineFriends = require(script.useGetOnlineFriends),
	useGetOnlineFriendsByUniverseId = require(script.useGetOnlineFriendsByUniverseId),
	useGetAllFriends = require(script.useGetAllFriends),
	useGetIsFriendWith = require(script.useGetIsFriendWith),
	useGetFriendshipStatus = require(script.useGetFriendshipStatus),
	useGetFriendsCountByUserId = require(script.useGetFriendsCountByUserId)
}
