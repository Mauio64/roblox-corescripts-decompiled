require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkingFriendsTypes")

local createGetFriendsFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFriendsFromUserId")
local createFindFriendsFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createFindFriendsFromUserId")
local createSearchFriendsByQuery = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createSearchFriendsByQuery")
local createGetFriendRequestsCount = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFriendRequestsCount")
local createGetNewFriendRequestsCount = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetNewFriendRequestsCount")
local createUnfriendTargetUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createUnfriendTargetUserId")
local createGetFriendRequests = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFriendRequests")
local createAcceptFriendRequestFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createAcceptFriendRequestFromUserId")
local createDeclineFriendRequestFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createDeclineFriendRequestFromUserId")
local createDeclineAllFriendRequests = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createDeclineAllFriendRequests")
local createClearNewFriendRequests = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createClearNewFriendRequests")
local createGetFriendsCountFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFriendsCountFromUserId")
local createGetInactiveFriends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetInactiveFriends")
local createRequestFriendshipFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createRequestFriendshipFromUserId")

local createRequestFriendshipFromContactId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createRequestFriendshipFromContactId")
local createGetFollowingExists = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFollowingExists")
local createGetUserFollowers = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetUserFollowers")

local createGetFriendRecommendationsFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFriendRecommendationsFromUserId")

local createGetFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFriendshipStatus")

local createGetFriendshipStatuses = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFriendshipStatuses")

local createGetExtendedFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetExtendedFriendshipStatus")
local createAcceptFriendRequestWithToken = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createAcceptFriendRequestWithToken")
local createGetFollowersCount = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFollowersCount")
local createGetFollowingsCount = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createGetFollowingsCount")
local createValidateFriendRequestNickname = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createValidateFriendRequestNickname")
local createRemoveTC = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createRemoveTC")
local createSendTCRequest = require("@game/CorePackages/Workspace/Packages/_Index/FriendsNetworking/FriendsNetworking/networkRequests/createSendTCRequest")

return function(p2)
	return {
		GetFriendsFromUserId = createGetFriendsFromUserId(p2),
		FindFriendsFromUserId = createFindFriendsFromUserId(p2),
		SearchFriendsByQuery = createSearchFriendsByQuery(p2),
		GetFriendRequestsCount = createGetFriendRequestsCount(p2),
		GetNewFriendRequestsCount = createGetNewFriendRequestsCount(p2),
		UnfriendTargetUserId = createUnfriendTargetUserId(p2),
		GetFriendRequests = createGetFriendRequests(p2),
		AcceptFriendRequestFromUserId = createAcceptFriendRequestFromUserId(p2),
		DeclineFriendRequestFromUserId = createDeclineFriendRequestFromUserId(p2),
		DeclineAllFriendRequests = createDeclineAllFriendRequests(p2),
		ClearNewFriendRequests = createClearNewFriendRequests(p2),
		GetFriendsCountFromUserId = createGetFriendsCountFromUserId(p2),
		GetInactiveFriends = createGetInactiveFriends(p2),
		RequestFriendshipFromUserId = createRequestFriendshipFromUserId(p2),
		RequestFriendshipFromContactId = createRequestFriendshipFromContactId(p2),
		GetFollowingExists = createGetFollowingExists(p2),
		GetUserFollowers = createGetUserFollowers(p2),
		GetFriendRecommendationsFromUserId = createGetFriendRecommendationsFromUserId(p2),
		GetFriendshipStatus = createGetFriendshipStatus(p2),
		GetFriendshipStatuses = createGetFriendshipStatuses(p2),
		GetExtendedFriendshipStatus = createGetExtendedFriendshipStatus(p2),
		AcceptFriendRequestWithToken = createAcceptFriendRequestWithToken(p2),
		GetFollowersCount = createGetFollowersCount(p2),
		GetFollowingsCount = createGetFollowingsCount(p2),
		ValidateFriendRequestNickname = createValidateFriendRequestNickname(p2),
		RemoveTC = createRemoveTC(p2),
		SendTCRequest = createSendTCRequest(p2)
	}
end
