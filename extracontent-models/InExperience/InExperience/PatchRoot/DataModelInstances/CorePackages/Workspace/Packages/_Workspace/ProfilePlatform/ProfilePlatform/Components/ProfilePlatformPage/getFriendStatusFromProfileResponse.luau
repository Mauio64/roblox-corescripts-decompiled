local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagProfilePlatformUseViewerRelationshipForSocialState = require(ProfilePlatform.Flags.FFlagProfilePlatformUseViewerRelationshipForSocialState)
local FriendStatus = require(ProfilePlatform.Analytics.FriendStatus)
local viewerRelationshipUtils = require(script.Parent.viewerRelationshipUtils)
local v7 = game:DefineFastFlag("ProfilePlatformFixSelfAnalytics", false)

local function getFriendStatusFromProfileResponse(p1) -- line: 13
	-- upvalues: FFlagProfilePlatformUseViewerRelationshipForSocialState (copy), viewerRelationshipUtils (copy), getDeepValue (copy), Enums (copy), FriendStatus (copy), v7 (copy)
	if FFlagProfilePlatformUseViewerRelationshipForSocialState then
		local v10 = viewerRelationshipUtils.getViewerRelationshipFromProfileResponse(p1)
		local v11 = viewerRelationshipUtils.getContextualInformationFromProfileResponse(p1)

		return viewerRelationshipUtils.mapViewerRelationshipAndContextToAnalyticsFriendStatus(v10, v11)
	end

	local v12 = getDeepValue(p1, `responseBody.components.{ Enums.Components.Actions }.buttons`)
	local v13 = if not v12 or not v12[1] then nil else v12[1].type

	if not v13 then
		return FriendStatus.Unknown
	end

	if v13 == Enums.ProfileActions.PendingFriendRequest then
		return FriendStatus.RequestSent
	end

	if v13 == Enums.ProfileActions.AcceptFriendRequest then
		return FriendStatus.RequestReceived
	end

	if v13 == Enums.ProfileActions.Chat or v13 == Enums.ProfileActions.JoinExperience or v13 == Enums.ProfileActions.EditAlias then
		return FriendStatus.Friends
	end

	if v13 == Enums.ProfileActions.EditProfile or v7 and v13 == Enums.ProfileActions.EditAvatar or v7 and v13 == Enums.ProfileActions.EditAppearance then
		return FriendStatus.Self
	end

	if v13 == Enums.ProfileActions.Unfriend then
		return FriendStatus.Ineligible
	end

	return FriendStatus.NotFriends
end

return getFriendStatusFromProfileResponse
