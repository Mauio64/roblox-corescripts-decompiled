local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useRelationshipSelector = require(script.Parent.useRelationshipSelector)
require(UserSearch.Common.LocalTypes)
require(parent.GraphQLServer)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images

local SocialCommon = require(parent.SocialCommon)
local useMutualFriendsText = SocialCommon.Hooks.useMutualFriendsText
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes

local RoduxPresence = require(UserSearch.Rodux.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local FFlagUserSearchPresenceStoreMigration = require(UserSearch.Flags.FFlagUserSearchPresenceStoreMigration)
local presenceType

if FFlagUserSearchPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType = nil
end

local SharedFlags = require(parent.SharedFlags)
local FFlagUserSearchUseThisIsYou = SharedFlags.FFlagUserSearchUseThisIsYou
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserSearchClassmatesInsight = SharedFlags2.FFlagUserSearchClassmatesInsight

local iconsstatusplayerfriend = Images["icons/status/player/friend"]
local iconsstatusplayerfollowing = Images["icons/status/player/following"]

local function fn(previousUsernames, searchKeyword: string)
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
	local v = useRelationshipSelector(data.userId)

	local shouldUseCompactTiles = data.shouldUseCompactTiles
	local shouldUseCompactTiles2 = data.shouldUseCompactTiles

	local v2 = useLocalization({
		youAreFriends = not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.YouAreFriends" or nil,
		youAreFollowing = not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.YouAreFollowing" or nil,
		thisIsYou = FFlagUserSearchUseThisIsYou and "Feature.PlayerSearchResults.Label.ThisIsYou" or not shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.ThisIsYou" or nil,
		friend = shouldUseCompactTiles and "Feature.Friends.Label.Friend" or nil,
		following = shouldUseCompactTiles and "Feature.Friends.Label.Following" or nil,
		you = shouldUseCompactTiles and "Feature.PlayerSearchResults.Label.You" or nil,
		newUsername = "Feature.PlayerSearchResults.Label.NewUsername",
		frequents = "Feature.Friends.Label.Frequent",
		classmates = FFlagUserSearchClassmatesInsight and "Feature.Schools.Label.Classmates" or nil
	})

	local profileInsight = data.profileInsight
	local v3 = profileInsight and profileInsight.mutualFriends and #profileInsight.mutualFriends or 0
	local text = useMutualFriendsText(v3)

	if v.isMyself then
		local text2

		if FFlagUserSearchUseThisIsYou then
			text2 = v2.thisIsYou
		elseif shouldUseCompactTiles then
			text2 = v2.you
		else
			text2 = v2.thisIsYou
		end

		return { text = text2 }, ContextualInfoTypes.IsMyself
	end

	if fn(data.previousUsernames, data.searchKeyword) then
		return { text = v2.newUsername }, ContextualInfoTypes.PreviousUsername
	end

	if v.status == Enum.FriendStatus.Friend then
		if data.shouldUseCompactTiles then
			local v4

			if FFlagUserSearchPresenceStoreMigration then
				v4 = data.userPresence and data.userPresence.userPresenceType == presenceType.InGame
			else
				v4 = data.userPresence and data.userPresence.userPresenceType == PresenceType.InGame
			end

			if v4 and data.userPresence and data.userPresence.lastLocation and data.userPresence.universeId then
				return { text = data.userPresence.lastLocation }, ContextualInfoTypes.ExperienceLastLocation
			end
		end

		local text2

		if shouldUseCompactTiles then
			text2 = v2.friend
		else
			text2 = v2.youAreFriends
		end

		local icon

		if not shouldUseCompactTiles2 then
			icon = iconsstatusplayerfriend
		end

		return { text = text2, icon = icon }, ContextualInfoTypes.Friend
	elseif v.following == true then
		local text2

		if shouldUseCompactTiles then
			text2 = v2.following
		else
			text2 = v2.youAreFollowing
		end

		local icon

		if not shouldUseCompactTiles2 then
			icon = iconsstatusplayerfollowing
		end

		return { text = text2, icon = icon }, ContextualInfoTypes.Following
	else
		if profileInsight then
			if v3 > 0 then
				local icon

				if not shouldUseCompactTiles2 then
					icon = iconsstatusplayerfriend
				end

				return { text = text, icon = icon }, ContextualInfoTypes.MutualFriends
			elseif profileInsight.isOfflineFrequents then
				return { text = v2.frequents }, ContextualInfoTypes.Frequents
			end
		end

		if FFlagUserSearchClassmatesInsight and profileInsight and profileInsight.isClassmate then
			return { text = v2.classmates }, ContextualInfoTypes.Classmates
		end

		return nil, nil
	end
end
