local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.Types)

local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local Enums = require(ProfilePlatform.Common.Enums)
local FriendStatus = require(ProfilePlatform.Analytics.FriendStatus)
local t1 = {
	Friends = FriendStatus.Friends,
	Self = FriendStatus.Self,
	RequestSent = FriendStatus.RequestSent,
	RequestReceived = FriendStatus.RequestReceived,
	None = FriendStatus.NotFriends,
	Invalid = FriendStatus.Unknown,
	Ineligible = FriendStatus.Ineligible,
	_ = FriendStatus.Unknown
}

local function getTrustedFriendStatusString(p1) -- line: 27
	if not p1 then
		return nil
	end

	return p1.trustedFriendStatus or nil
end
local function mapFriendshipStatusToAnalyticsFriendStatus(s1: string) -- line: 35
	-- upvalues: t1 (copy)
	return t1[s1]
end

return {
	getViewerRelationshipFromProfileResponse = function(p2) -- line: 19
		-- upvalues: getDeepValue (copy), Enums (copy)
		return getDeepValue(p2, `responseBody.components.{ Enums.Components.UserProfileHeader }.viewerRelationship`)
	end,
	getContextualInformationFromProfileResponse = function(p3) -- line: 23
		-- upvalues: getDeepValue (copy), Enums (copy)
		return getDeepValue(p3, `responseBody.components.{ Enums.Components.UserProfileHeader }.contextualInformation`)
	end,
	mapViewerRelationshipAndContextToAnalyticsFriendStatus = function(p4, p5) -- line: 39
		-- upvalues: Enums (copy), FriendStatus (copy), t1 (copy)
		local v14 = p4 and p4.friendshipStatus or "Invalid"

		if p5 and (p5.context == Enums.ContextualTypes.AccountDeleted and v14 == "Friends") then
			return FriendStatus.Ineligible
		end

		return t1[v14]
	end,
	isViewerTrustedFriendsFromViewerRelationship = function(p6) -- line: 53
		return ((if p6 then p6.trustedFriendStatus or nil else nil)) == "TrustedFriends"
	end
}
