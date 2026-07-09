local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local useLocalization = require(UserSearchParent.Localization).Hooks.useLocalization
local useRelationshipSelector = require(script.Parent.useRelationshipSelector)

require(UserSearch.Common.LocalTypes)
require(UserSearchParent.GraphQLServer)

local Images = require(UserSearchParent.UIBlox).App.ImageSet.Images
local SocialCommon = require(UserSearchParent.SocialCommon)
local useMutualFriendsText = SocialCommon.Hooks.useMutualFriendsText
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local PresenceType = require(UserSearch.Rodux.RoduxPresence).Enums.PresenceType
local FFlagUserSearchUseThisIsYou = require(UserSearchParent.SharedFlags).FFlagUserSearchUseThisIsYou
local FFlagConnectionsToFriendsRename = require(UserSearchParent.SharedFlags).FFlagConnectionsToFriendsRename
local v12 = Images["icons/status/player/friend"]
local v13 = Images["icons/status/player/following"]

local function v14(p1, s1: string) -- line: 28
	if not p1 or #p1 == 0 then
		return false
	end

	for i = 1, #p1 do
		if string.lower(p1[i]) == string.lower(s1) then
			return p1[i]
		end
	end

	return false
end

return function(t1: {[any]: any}) -- line: 56
	-- upvalues: useRelationshipSelector (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), FFlagUserSearchUseThisIsYou (copy), useMutualFriendsText (copy), ContextualInfoTypes (copy), v14 (copy), PresenceType (copy), v12 (copy), v13 (copy)
	local v19 = useRelationshipSelector(t1.userId)
	local shouldUseCompactTiles = t1.shouldUseCompactTiles
	local shouldUseCompactTiles2 = t1.shouldUseCompactTiles
	local v22 = useLocalization({
		newUsername = "Feature.PlayerSearchResults.Label.NewUsername",
		frequents = "Feature.Friends.Label.Frequent",
		youAreFriends = if not shouldUseCompactTiles then not FFlagConnectionsToFriendsRename and "Feature.PlayerSearchResults.Label.YouAreConnections" or "Feature.PlayerSearchResults.Label.YouAreFriends" else nil,
		youAreFollowing = not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.YouAreFollowing" or nil,
		thisIsYou = if not FFlagUserSearchUseThisIsYou then not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.ThisIsYou" or nil else "Feature.PlayerSearchResults.Label.ThisIsYou",
		friend = if not shouldUseCompactTiles then nil else not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.Connection" or "Feature.Friends.Label.Friend",
		following = if not shouldUseCompactTiles then nil else "Feature.Friends.Label.Following",
		you = if not shouldUseCompactTiles then nil else "Feature.PlayerSearchResults.Label.You"
	})
	local profileInsight = t1.profileInsight
	local v24 = profileInsight and (not not profileInsight.mutualFriends and #profileInsight.mutualFriends) or 0
	local v25 = useMutualFriendsText(v24)

	if v19.isMyself then
		return {
			text = if not FFlagUserSearchUseThisIsYou then if not shouldUseCompactTiles then v22.thisIsYou else v22.you else v22.thisIsYou
		}, ContextualInfoTypes.IsMyself
	end

	if v14(t1.previousUsernames, t1.searchKeyword) then
		return {
			text = v22.newUsername
		}, ContextualInfoTypes.PreviousUsername
	end

	if v19.status == Enum.FriendStatus.Friend then
		if t1.shouldUseCompactTiles and t1.userPresence and t1.userPresence.userPresenceType == PresenceType.InGame and t1.userPresence.lastLocation and t1.userPresence.universeId then
			return {
				text = t1.userPresence.lastLocation
			}, ContextualInfoTypes.ExperienceLastLocation
		end

		return {
			text = if not shouldUseCompactTiles then v22.youAreFriends else v22.friend,
			icon = if not shouldUseCompactTiles2 then v12 else nil
		}, ContextualInfoTypes.Friend
	end

	if v19.following == true then
		return {
			text = if not shouldUseCompactTiles then v22.youAreFollowing else v22.following,
			icon = if not shouldUseCompactTiles2 then v13 else nil
		}, ContextualInfoTypes.Following
	end

	if profileInsight then
		if v24 > 0 then
			return {
				text = v25,
				icon = if not shouldUseCompactTiles2 then v12 else nil
			}, ContextualInfoTypes.MutualFriends
		end

		if profileInsight.isOfflineFrequents then
			return {
				text = v22.frequents
			}, ContextualInfoTypes.Frequents
		end
	end

	return nil, nil
end
