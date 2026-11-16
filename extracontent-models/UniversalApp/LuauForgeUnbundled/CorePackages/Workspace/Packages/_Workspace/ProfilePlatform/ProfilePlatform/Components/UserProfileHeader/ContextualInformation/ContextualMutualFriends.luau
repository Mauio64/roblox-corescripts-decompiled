local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local images = UIBlox.App.ImageSet.Images
local playerContext = UIBlox.App.Indicator.PlayerContext

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserProfiles")

local function truncateSomeNames(value, p2)
	if p2.shouldTruncateLongNames and #value >= 13 then
		return string.format("%s%s", string.sub(value, 1, 12), "…")
	end

	return value
end

local function getNamesListText(list, p2)
	local v5 = {}

	for i = 1, math.min(#list, 3) do
		table.insert(v5, list[i])
	end

	return table.concat(Cryo.List.map(v5, function(p3)
		return truncateSomeNames(p3, p2)
	end), ", ")
end

local function getOthersText(p2, p3, data)
	local oneMutualFriendText = data.oneMutualFriendText
	local pluralMutualFriendsText = data.pluralMutualFriendsText
	local oneOtherMutualFriendText = data.oneOtherMutualFriendText
	local v5 = data.pluralOtherMutualFriendsText

	if p2 == 1 then
		return oneMutualFriendText
	end

	if p2 <= 3 then
		return pluralMutualFriendsText
	end

	local v6 = p2 - p3

	if v6 == 1 then
		v5 = oneOtherMutualFriendText
	end

	return `+ {v6} {v5}`
end

local function getText(p2, list, p3, data)
	local namesListText = getNamesListText(list, p3)
	local v5 = math.min(#list, 3)
	local oneMutualFriendText = data.oneMutualFriendText
	local v6 = data.pluralMutualFriendsText
	local oneOtherMutualFriendText = data.oneOtherMutualFriendText
	local v7 = data.pluralOtherMutualFriendsText

	if p2 == 1 then
		v6 = oneMutualFriendText
	elseif not (p2 <= 3) then
		local v8 = p2 - v5

		if v8 == 1 then
			v7 = oneOtherMutualFriendText
		end

		v6 = `+ {v8} {v7}`
	end

	return `{namesListText} {v6}`
end

local function contextualPresence(p2)
	local v5 = useLocalization({
		oneMutualFriendText = TextKeys.OneMutualFriend,
		pluralMutualFriendsText = TextKeys.PluralMutualFriends,
		oneOtherMutualFriendText = TextKeys.OneOtherMutualFriend,
		pluralOtherMutualFriendsText = TextKeys.PluralOtherMutualFriends
	})

	local mutualFriendsCount = p2.mutualFriendsCount

	local mapped = Cryo.List.map(p2.mutualFriends, function(p3)
		return (tostring(p3))
	end)

	local v6 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = mapped,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local combinedNameFromIds = {}
	local v7 = ""
	local v8 = #p2.mutualFriends

	if v6.data then
		for i, v9 in ipairs(mapped) do
			local combinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId(v6.data, v9)
			v7 ..= combinedNameFromId

			if i ~= v8 then
				v7 ..= ", "
			end

			combinedNameFromIds[i] = combinedNameFromId
		end
	end

	local namesListText = getNamesListText(combinedNameFromIds, {
		shouldTruncateLongNames = mutualFriendsCount > 1
	})
	local v10 = math.min(#combinedNameFromIds, 3)
	local oneMutualFriendText = v5.oneMutualFriendText
	local v11 = v5.pluralMutualFriendsText
	local oneOtherMutualFriendText = v5.oneOtherMutualFriendText
	local v12 = v5.pluralOtherMutualFriendsText

	if mutualFriendsCount == 1 then
		v11 = oneMutualFriendText
	elseif not (mutualFriendsCount <= 3) then
		local v13 = mutualFriendsCount - v10

		if v13 == 1 then
			v12 = oneOtherMutualFriendText
		end

		v11 = `+ {v13} {v12}`
	end

	local formatted = `{namesListText} {v11}`

	return React.createElement(playerContext, {
		icon = images["icons/status/player/friend"],
		text = formatted,
		textHeight = 30
	})
end

return contextualPresence
