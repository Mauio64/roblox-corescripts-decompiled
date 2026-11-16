local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.Types)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local Enums = require(ProfilePlatform.Common.Enums)
local FriendStatus = require(ProfilePlatform.Analytics.FriendStatus)

local v = {
	["Friends"] = FriendStatus.Friends,
	Self = FriendStatus.Self,
	RequestSent = FriendStatus.RequestSent,
	RequestReceived = FriendStatus.RequestReceived,
	None = FriendStatus.NotFriends,
	Invalid = FriendStatus.Unknown,
	Ineligible = FriendStatus.Ineligible,
	_ = FriendStatus.Unknown
}

local function getTrustedFriendStatusString(p) -- 1 equivalent call inferred from this helper
	if p then
		return p.trustedFriendStatus or nil
	end

	return nil
end

local function mapFriendshipStatusToAnalyticsFriendStatus(friendshipStatus: string) -- 1 equivalent call inferred from this helper
	return v[friendshipStatus]
end

local ViewerRelationshipUtils = {}

function ViewerRelationshipUtils.getViewerRelationshipFromProfileResponse(p)
	return getDeepValue(p, `responseBody.components.{Enums.Components.UserProfileHeader}.viewerRelationship`)
end

function ViewerRelationshipUtils.getContextualInformationFromProfileResponse(p)
	return getDeepValue(p, `responseBody.components.{Enums.Components.UserProfileHeader}.contextualInformation`)
end

function ViewerRelationshipUtils.mapViewerRelationshipAndContextToAnalyticsFriendStatus(p, p2)
	local friendshipStatus = p and p.friendshipStatus or "Invalid"

	if p2 and p2.context == Enums.ContextualTypes.AccountDeleted and friendshipStatus == "Friends" then
		return FriendStatus.Ineligible
	end

	return mapFriendshipStatusToAnalyticsFriendStatus(friendshipStatus) -- inferred equivalent call
end

function ViewerRelationshipUtils.isViewerTrustedFriendsFromViewerRelationship(p): boolean
	return getTrustedFriendStatusString(p) == "TrustedFriends" -- inferred equivalent call
end

return ViewerRelationshipUtils
