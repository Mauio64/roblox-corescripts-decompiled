require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local module = require("@luauforge/bundled/feH")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local FriendStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/FriendStatus")

local v5 = {
	["Friends"] = FriendStatus.Friends,
	Self = FriendStatus.Self,
	RequestSent = FriendStatus.RequestSent,
	RequestReceived = FriendStatus.RequestReceived,
	None = FriendStatus.NotFriends,
	Invalid = FriendStatus.Unknown,
	Ineligible = FriendStatus.Ineligible,
	_ = FriendStatus.Unknown
}

local function getTrustedFriendStatusString(p2)
	if p2 then
		return p2.trustedFriendStatus or nil
	end

	return nil
end

local function mapFriendshipStatusToAnalyticsFriendStatus(p2)
	return v5[p2]
end

return {
	getViewerRelationshipFromProfileResponse = function(p2)
		return module(
			p2,
			`responseBody.components.{module2.Components.UserProfileHeader}.viewerRelationship`
		)
	end,
	getContextualInformationFromProfileResponse = function(p2)
		return module(
			p2,
			`responseBody.components.{module2.Components.UserProfileHeader}.contextualInformation`
		)
	end,
	mapViewerRelationshipAndContextToAnalyticsFriendStatus = function(p2, p3)
		local friendshipStatus = p2 and p2.friendshipStatus or "Invalid"

		if
			p3
			and p3.context == Enums.ContextualTypes.AccountDeleted
			and friendshipStatus == "Friends"
		then
			return FriendStatus.Ineligible
		end

		return v5[friendshipStatus]
	end,
	isViewerTrustedFriendsFromViewerRelationship = function(p2): boolean
		return (if p2 then p2.trustedFriendStatus or nil else nil) == "TrustedFriends"
	end
}
