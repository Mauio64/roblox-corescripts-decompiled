local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Cryo = require(ProfilePlatformParent.Cryo)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local PlayerContext = UIBlox.App.Indicator.PlayerContext
local UserProfiles = require(ProfilePlatformParent.UserProfiles)
local FFlagConnectionsToFriendsRename = require(ProfilePlatformParent.SharedFlags).FFlagConnectionsToFriendsRename

local function truncateSomeNames(s1: string, t1: {[any]: any}) -- line: 31
	if t1.shouldTruncateLongNames and #s1 >= 13 then
		return string.format("%s%s", string.sub(s1, 1, 12), "…")
	end

	return s1
end
local function getNamesListText(t2: {[any]: any}, t3: {[any]: any}) -- line: 38
	-- upvalues: Cryo (copy), truncateSomeNames (copy)
	local t4 = {}

	for i = 1, math.min(#t2, 3) do
		table.insert(t4, t2[i])
	end

	return table.concat(Cryo.List.map(t4, function(p1) -- line: 46
		-- upvalues: truncateSomeNames (copy), t3 (copy)
		return truncateSomeNames(p1, t3)
	end), ", ")
end
local function getOthersText(n1: number, n2: number, t5: {[any]: any}) -- line: 53
	local oneMutualFriendText = t5.oneMutualFriendText
	local pluralMutualFriendsText = t5.pluralMutualFriendsText
	local oneOtherMutualFriendText = t5.oneOtherMutualFriendText
	local pluralOtherMutualFriendsText = t5.pluralOtherMutualFriendsText

	if n1 == 1 then
		return oneMutualFriendText
	end

	if n1 <= 3 then
		return pluralMutualFriendsText
	end

	local v30 = n1 - n2

	return `+ { v30 } { (if v30 ~= 1 then pluralOtherMutualFriendsText else oneOtherMutualFriendText) }`
end
local function getText(n3: number, t6: {[any]: any}, t7: {[any]: any}, p2) -- line: 76
	-- upvalues: getNamesListText (copy)
	local v35 = getNamesListText(t6, t7)
	local v36 = math.min(#t6, 3)
	local oneMutualFriendText = p2.oneMutualFriendText
	local pluralMutualFriendsText = p2.pluralMutualFriendsText
	local oneOtherMutualFriendText = p2.oneOtherMutualFriendText
	local pluralOtherMutualFriendsText = p2.pluralOtherMutualFriendsText

	if n3 == 1 then
	elseif n3 <= 3 then
		oneMutualFriendText = pluralMutualFriendsText
	else
		local v41 = n3 - v36

		oneMutualFriendText = `+ { v41 } { (if v41 ~= 1 then pluralOtherMutualFriendsText else oneOtherMutualFriendText) }`
	end

	return `{ v35 } { oneMutualFriendText }`
end
local function contextualPresence(t8: {[any]: any}) -- line: 85
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), Cryo (copy), UserProfiles (copy), getNamesListText (copy), React (copy), PlayerContext (copy), Images (copy)
	local v43 = useLocalization({
		oneMutualFriendText = if not FFlagConnectionsToFriendsRename then TextKeys.OneMutualConnection else TextKeys.OneMutualFriend,
		pluralMutualFriendsText = if not FFlagConnectionsToFriendsRename then TextKeys.PluralMutualConnections else TextKeys.PluralMutualFriends,
		oneOtherMutualFriendText = if not FFlagConnectionsToFriendsRename then TextKeys.OneOtherMutualConnection else TextKeys.OneOtherMutualFriend,
		pluralOtherMutualFriendsText = if not FFlagConnectionsToFriendsRename then TextKeys.PluralOtherMutualConnections else TextKeys.PluralOtherMutualFriends
	})
	local mutualFriendsCount = t8.mutualFriendsCount
	local v45 = Cryo.List.map(t8.mutualFriends, function(p3) -- line: 103
		return (tostring(p3))
	end)
	local v46 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = v45,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local t9 = {}
	local s2 = ""
	local v49 = #t8.mutualFriends

	if v46.data then
		for i, v in ipairs(v45) do
			local v52 = UserProfiles.Selectors.getCombinedNameFromId(v46.data, v)

			s2 ..= v52

			if i ~= v49 then
				s2 ..= ", "
			end

			t9[i] = v52
		end
	end

	local t10 = {
		shouldTruncateLongNames = mutualFriendsCount > 1
	}
	local v54 = getNamesListText(t9, t10)
	local v55 = math.min(#t9, 3)
	local oneMutualFriendText = v43.oneMutualFriendText
	local pluralMutualFriendsText = v43.pluralMutualFriendsText
	local oneOtherMutualFriendText = v43.oneOtherMutualFriendText
	local pluralOtherMutualFriendsText = v43.pluralOtherMutualFriendsText

	if mutualFriendsCount == 1 then
	elseif mutualFriendsCount <= 3 then
		oneMutualFriendText = pluralMutualFriendsText
	else
		local v60 = mutualFriendsCount - v55

		oneMutualFriendText = `+ { v60 } { (if v60 ~= 1 then pluralOtherMutualFriendsText else oneOtherMutualFriendText) }`
	end

	local v61 = `{ v54 } { oneMutualFriendText }`

	return React.createElement(PlayerContext, {
		textHeight = 30,
		icon = Images["icons/status/player/friend"],
		text = v61
	})
end

return contextualPresence
