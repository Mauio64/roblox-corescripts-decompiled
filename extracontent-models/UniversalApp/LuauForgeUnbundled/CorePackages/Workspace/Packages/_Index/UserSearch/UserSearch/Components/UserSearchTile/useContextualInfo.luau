local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Localization").Hooks.useLocalization

local useRelationshipSelector = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchTile/useRelationshipSelector")
require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/LocalTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/GraphQLServer")

local images = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UIBlox").App.ImageSet.Images

local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialCommon")
local useMutualFriendsText = SocialCommon.Hooks.useMutualFriendsText
local contextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes

local presenceType = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Rodux/RoduxPresence").Enums.PresenceType
local FFlagUserSearchPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchPresenceStoreMigration")

local presenceType2 = if FFlagUserSearchPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/DataHydration").Presence.PresenceEnums.PresenceType else nil

local fFlagUserSearchUseThisIsYou = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchUseThisIsYou
local fFlagUserSearchClassmatesInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchClassmatesInsight

local iconsstatusplayerfriend = images["icons/status/player/friend"]
local iconsstatusplayerfollowing = images["icons/status/player/following"]

local function fn(previousUsernames, searchKeyword)
	if not previousUsernames or #previousUsernames == 0 then
		return false
	end

	for i = 1, #previousUsernames do
		if string.lower(previousUsernames[i]) == string.lower(searchKeyword) then
			return previousUsernames[i]
		end
	end

	return false
end

return function(data)
	local v5 = useRelationshipSelector(data.userId)

	local shouldUseCompactTiles = data.shouldUseCompactTiles
	local shouldUseCompactTiles2 = data.shouldUseCompactTiles

	local v6 = useLocalization({
		youAreFriends = not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.YouAreFriends" or nil,
		youAreFollowing = not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.YouAreFollowing" or nil,
		thisIsYou = fFlagUserSearchUseThisIsYou and "Feature.PlayerSearchResults.Label.ThisIsYou" or not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.ThisIsYou" or nil,
		friend = shouldUseCompactTiles and "Feature.Friends.Label.Friend" or nil,
		following = shouldUseCompactTiles and "Feature.Friends.Label.Following" or nil,
		you = shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.You" or nil,
		newUsername = "Feature.PlayerSearchResults.Label.NewUsername",
		frequents = "Feature.Friends.Label.Frequent",
		classmates = fFlagUserSearchClassmatesInsight and "Feature.Schools.Label.Classmates" or nil
	})

	local profileInsight = data.profileInsight
	local v7 = profileInsight and profileInsight.mutualFriends and #profileInsight.mutualFriends or 0
	local v8 = useMutualFriendsText(v7)

	if v5.isMyself then
		local v10

		if fFlagUserSearchUseThisIsYou then
			v10 = v6.thisIsYou
		else
			v10 = if shouldUseCompactTiles then v6.you else v6.thisIsYou
		end

		return { text = v10 }, contextualInfoTypes.IsMyself
	end

	if fn(data.previousUsernames, data.searchKeyword) then
		return { text = v6.newUsername }, contextualInfoTypes.PreviousUsername
	end

	if v5.status == Enum.FriendStatus.Friend then
		if data.shouldUseCompactTiles then
			local v9

			if FFlagUserSearchPresenceStoreMigration then
				v9 = data.userPresence and data.userPresence.userPresenceType == presenceType2.InGame
			else
				v9 = data.userPresence and data.userPresence.userPresenceType == presenceType.InGame
			end

			if
				v9
				and data.userPresence
				and data.userPresence.lastLocation
				and data.userPresence.universeId
			then
				return { text = data.userPresence.lastLocation }, contextualInfoTypes.ExperienceLastLocation
			end
		end

		local v10 = if shouldUseCompactTiles then v6.friend else v6.youAreFriends
		return {
			text = v10,
			icon = if not shouldUseCompactTiles2 then iconsstatusplayerfriend else nil
		}, contextualInfoTypes.Friend
	elseif v5.following == true then
		local v10 = if shouldUseCompactTiles then v6.following else v6.youAreFollowing
		return {
			text = v10,
			icon = if not shouldUseCompactTiles2 then iconsstatusplayerfollowing else nil
		}, contextualInfoTypes.Following
	else
		if profileInsight then
			if v7 > 0 then
				return {
					text = v8,
					icon = if not shouldUseCompactTiles2 then iconsstatusplayerfriend else nil
				}, contextualInfoTypes.MutualFriends
			elseif profileInsight.isOfflineFrequents then
				return { text = v6.frequents }, contextualInfoTypes.Frequents
			end
		end

		if fFlagUserSearchClassmatesInsight and profileInsight and profileInsight.isClassmate then
			return { text = v6.classmates }, contextualInfoTypes.Classmates
		end

		return nil, nil
	end
end
