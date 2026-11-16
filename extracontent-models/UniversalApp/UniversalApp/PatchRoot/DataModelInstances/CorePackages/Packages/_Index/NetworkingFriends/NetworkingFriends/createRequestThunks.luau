require(script.Parent.networkingFriendsTypes)

local networkRequests = script.Parent.networkRequests
local createGetFriendsFromUserId = require(networkRequests.createGetFriendsFromUserId)
local createFindFriendsFromUserId = require(networkRequests.createFindFriendsFromUserId)
local createSearchFriendsByQuery = require(networkRequests.createSearchFriendsByQuery)
local createGetFriendRequestsCount = require(networkRequests.createGetFriendRequestsCount)
local createUnfriendTargetUserId = require(networkRequests.createUnfriendTargetUserId)
local createGetFriendRequests = require(networkRequests.createGetFriendRequests)
local createAcceptFriendRequestFromUserId = require(networkRequests.createAcceptFriendRequestFromUserId)
local createDeclineFriendRequestFromUserId = require(networkRequests.createDeclineFriendRequestFromUserId)
local createDeclineAllFriendRequests = require(networkRequests.createDeclineAllFriendRequests)
local createGetFriendsCountFromUserId = require(networkRequests.createGetFriendsCountFromUserId)
local createGetInactiveFriends = require(networkRequests.createGetInactiveFriends)
local createRequestFriendshipFromUserId = require(networkRequests.createRequestFriendshipFromUserId)

local createRequestFriendshipFromContactId = require(networkRequests.createRequestFriendshipFromContactId)
local createGetFollowingExists = require(networkRequests.createGetFollowingExists)
local createGetUserFollowers = require(networkRequests.createGetUserFollowers)

local createGetFriendRecommendationsFromUserId = require(networkRequests.createGetFriendRecommendationsFromUserId)

local createGetFriendshipStatus = require(networkRequests.createGetFriendshipStatus)

local createGetExtendedFriendshipStatus = require(networkRequests.createGetExtendedFriendshipStatus)
local createAcceptFriendRequestWithToken = require(networkRequests.createAcceptFriendRequestWithToken)
local createGetFollowersCount = require(networkRequests.createGetFollowersCount)
local createGetFollowingsCount = require(networkRequests.createGetFollowingsCount)
local createValidateFriendRequestNickname = require(networkRequests.createValidateFriendRequestNickname)

return function(p)
	return {
		GetFriendsFromUserId = createGetFriendsFromUserId(p),
		FindFriendsFromUserId = createFindFriendsFromUserId(p),
		SearchFriendsByQuery = createSearchFriendsByQuery(p),
		GetFriendRequestsCount = createGetFriendRequestsCount(p),
		UnfriendTargetUserId = createUnfriendTargetUserId(p),
		GetFriendRequests = createGetFriendRequests(p),
		AcceptFriendRequestFromUserId = createAcceptFriendRequestFromUserId(p),
		DeclineFriendRequestFromUserId = createDeclineFriendRequestFromUserId(p),
		DeclineAllFriendRequests = createDeclineAllFriendRequests(p),
		GetFriendsCountFromUserId = createGetFriendsCountFromUserId(p),
		GetInactiveFriends = createGetInactiveFriends(p),
		RequestFriendshipFromUserId = createRequestFriendshipFromUserId(p),
		RequestFriendshipFromContactId = createRequestFriendshipFromContactId(p),
		GetFollowingExists = createGetFollowingExists(p),
		GetUserFollowers = createGetUserFollowers(p),
		GetFriendRecommendationsFromUserId = createGetFriendRecommendationsFromUserId(p),
		GetFriendshipStatus = createGetFriendshipStatus(p),
		GetExtendedFriendshipStatus = createGetExtendedFriendshipStatus(p),
		AcceptFriendRequestWithToken = createAcceptFriendRequestWithToken(p),
		GetFollowersCount = createGetFollowersCount(p),
		GetFollowingsCount = createGetFollowingsCount(p),
		ValidateFriendRequestNickname = createValidateFriendRequestNickname(p)
	}
end
