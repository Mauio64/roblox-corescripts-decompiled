require(script.Parent.networkingFriendsTypes)

local networkRequests = script.Parent.networkRequests
local createGetFriendsFromUserId = require(networkRequests.createGetFriendsFromUserId)
local createFindFriendsFromUserId = require(networkRequests.createFindFriendsFromUserId)
local createSearchFriendsByQuery = require(networkRequests.createSearchFriendsByQuery)
local createGetFriendRequestsCount = require(networkRequests.createGetFriendRequestsCount)
local createGetNewFriendRequestsCount = require(networkRequests.createGetNewFriendRequestsCount)
local createUnfriendTargetUserId = require(networkRequests.createUnfriendTargetUserId)
local createGetFriendRequests = require(networkRequests.createGetFriendRequests)
local createAcceptFriendRequestFromUserId = require(networkRequests.createAcceptFriendRequestFromUserId)
local createDeclineFriendRequestFromUserId = require(networkRequests.createDeclineFriendRequestFromUserId)
local createDeclineAllFriendRequests = require(networkRequests.createDeclineAllFriendRequests)
local createClearNewFriendRequests = require(networkRequests.createClearNewFriendRequests)
local createGetFriendsCountFromUserId = require(networkRequests.createGetFriendsCountFromUserId)
local createGetInactiveFriends = require(networkRequests.createGetInactiveFriends)
local createRequestFriendshipFromUserId = require(networkRequests.createRequestFriendshipFromUserId)
local createRequestFriendshipFromContactId = require(networkRequests.createRequestFriendshipFromContactId)
local createGetFollowingExists = require(networkRequests.createGetFollowingExists)
local createGetUserFollowers = require(networkRequests.createGetUserFollowers)
local createGetFriendRecommendationsFromUserId = require(networkRequests.createGetFriendRecommendationsFromUserId)
local createGetFriendshipStatus = require(networkRequests.createGetFriendshipStatus)
local createGetFriendshipStatuses = require(networkRequests.createGetFriendshipStatuses)
local createGetExtendedFriendshipStatus = require(networkRequests.createGetExtendedFriendshipStatus)
local createAcceptFriendRequestWithToken = require(networkRequests.createAcceptFriendRequestWithToken)
local createGetFollowersCount = require(networkRequests.createGetFollowersCount)
local createGetFollowingsCount = require(networkRequests.createGetFollowingsCount)
local createValidateFriendRequestNickname = require(networkRequests.createValidateFriendRequestNickname)
local createRemoveTC = require(networkRequests.createRemoveTC)
local createSendTCRequest = require(networkRequests.createSendTCRequest)

return function(p1) -- line: 37
	-- upvalues: createGetFriendsFromUserId (copy), createFindFriendsFromUserId (copy), createSearchFriendsByQuery (copy), createGetFriendRequestsCount (copy), createGetNewFriendRequestsCount (copy), createUnfriendTargetUserId (copy), createGetFriendRequests (copy), createAcceptFriendRequestFromUserId (copy), createDeclineFriendRequestFromUserId (copy), createDeclineAllFriendRequests (copy), createClearNewFriendRequests (copy), createGetFriendsCountFromUserId (copy), createGetInactiveFriends (copy), createRequestFriendshipFromUserId (copy), createRequestFriendshipFromContactId (copy), createGetFollowingExists (copy), createGetUserFollowers (copy), createGetFriendRecommendationsFromUserId (copy), createGetFriendshipStatus (copy), createGetFriendshipStatuses (copy), createGetExtendedFriendshipStatus (copy), createAcceptFriendRequestWithToken (copy), createGetFollowersCount (copy), createGetFollowingsCount (copy), createValidateFriendRequestNickname (copy), createRemoveTC (copy), createSendTCRequest (copy)
	return {
		GetFriendsFromUserId = createGetFriendsFromUserId(p1),
		FindFriendsFromUserId = createFindFriendsFromUserId(p1),
		SearchFriendsByQuery = createSearchFriendsByQuery(p1),
		GetFriendRequestsCount = createGetFriendRequestsCount(p1),
		GetNewFriendRequestsCount = createGetNewFriendRequestsCount(p1),
		UnfriendTargetUserId = createUnfriendTargetUserId(p1),
		GetFriendRequests = createGetFriendRequests(p1),
		AcceptFriendRequestFromUserId = createAcceptFriendRequestFromUserId(p1),
		DeclineFriendRequestFromUserId = createDeclineFriendRequestFromUserId(p1),
		DeclineAllFriendRequests = createDeclineAllFriendRequests(p1),
		ClearNewFriendRequests = createClearNewFriendRequests(p1),
		GetFriendsCountFromUserId = createGetFriendsCountFromUserId(p1),
		GetInactiveFriends = createGetInactiveFriends(p1),
		RequestFriendshipFromUserId = createRequestFriendshipFromUserId(p1),
		RequestFriendshipFromContactId = createRequestFriendshipFromContactId(p1),
		GetFollowingExists = createGetFollowingExists(p1),
		GetUserFollowers = createGetUserFollowers(p1),
		GetFriendRecommendationsFromUserId = createGetFriendRecommendationsFromUserId(p1),
		GetFriendshipStatus = createGetFriendshipStatus(p1),
		GetFriendshipStatuses = createGetFriendshipStatuses(p1),
		GetExtendedFriendshipStatus = createGetExtendedFriendshipStatus(p1),
		AcceptFriendRequestWithToken = createAcceptFriendRequestWithToken(p1),
		GetFollowersCount = createGetFollowersCount(p1),
		GetFollowingsCount = createGetFollowingsCount(p1),
		ValidateFriendRequestNickname = createValidateFriendRequestNickname(p1),
		RemoveTC = createRemoveTC(p1),
		SendTCRequest = createSendTCRequest(p1)
	}
end
