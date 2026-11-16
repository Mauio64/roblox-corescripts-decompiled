local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local PlayerContext = UIBlox.App.Indicator.PlayerContext

local UserProfiles = require(parent.UserProfiles)

local function truncateSomeNames(value: string, p)
	if p.shouldTruncateLongNames and #value >= 13 then
		return string.format("%s%s", string.sub(value, 1, 12), "…")
	end

	return value
end

local function getNamesListText(list, p)
	local v = {}

	for i = 1, math.min(#list, 3) do
		table.insert(v, list[i])
	end

	return table.concat(Cryo.List.map(v, function(p2)
		return truncateSomeNames(p2, p)
	end), ", ")
end

local function getOthersText(p: number, p2: number, data) -- 1 equivalent call inferred from this helper
	local oneMutualFriendText = data.oneMutualFriendText
	local pluralMutualFriendsText = data.pluralMutualFriendsText
	local oneOtherMutualFriendText = data.oneOtherMutualFriendText
	local v = data.pluralOtherMutualFriendsText

	if p == 1 then
		return oneMutualFriendText
	end

	if p <= 3 then
		return pluralMutualFriendsText
	end

	local v2 = p - p2

	if v2 == 1 then
		v = oneOtherMutualFriendText
	end

	return `+ {v2} {v}`
end

local function getText(mutualFriendsCount: number, combinedNameFromIds, p, data) -- 1 equivalent call inferred from this helper
	return `{getNamesListText(combinedNameFromIds, p)} {getOthersText(mutualFriendsCount, math.min(#combinedNameFromIds, 3), data)}` -- inferred equivalent call
end

local function contextualPresence(p)
	local v = useLocalization({
		oneMutualFriendText = TextKeys.OneMutualFriend,
		pluralMutualFriendsText = TextKeys.PluralMutualFriends,
		oneOtherMutualFriendText = TextKeys.OneOtherMutualFriend,
		pluralOtherMutualFriendsText = TextKeys.PluralOtherMutualFriends
	})

	local mutualFriendsCount = p.mutualFriendsCount

	local mapped = Cryo.List.map(p.mutualFriends, function(p2)
		return (tostring(p2))
	end)

	local v2 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = mapped,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local combinedNameFromIds = {}
	local v3 = ""
	local v4 = #p.mutualFriends

	if v2.data then
		for i, v5 in ipairs(mapped) do
			local combinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId(v2.data, v5)
			v3 ..= combinedNameFromId

			if i ~= v4 then
				v3 ..= ", "
			end

			combinedNameFromIds[i] = combinedNameFromId
		end
	end

	local text = getText(mutualFriendsCount, combinedNameFromIds, { -- inferred equivalent call
		shouldTruncateLongNames = mutualFriendsCount > 1
	}, v)

	return React.createElement(PlayerContext, {
		icon = Images["icons/status/player/friend"],
		text = text,
		textHeight = 30
	})
end

return contextualPresence
