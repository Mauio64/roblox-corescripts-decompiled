local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/Cryo")

local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/Signals").createSignal

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents
local fFlagProfileInsightsParseClassmates = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagProfileInsightsParseClassmates
local fFlagProfileInsightsKeyByRankingStrategy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagProfileInsightsKeyByRankingStrategy
local fFlagTrustedFriendCandidatesSection = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagTrustedFriendCandidatesSection

local function hasNumberValue(p2): boolean
	return p2 ~= nil and p2 ~= -1
end

local v5 = {
	mutualFriendInsight = {
		field = "mutualFriends",
		hasValue = function(p2): boolean
			return #p2.mutualFriends > 0
		end
	},
	offlineFrequentsInsight = {
		field = "isOfflineFrequents",
		hasValue = function(p2): boolean
			return p2.isOfflineFrequents == true
		end
	},
	playedTogetherInsight = fFlagPlayerSearchEnableOnlineFrequents and {
		field = "isOfflineFrequents",
		hasValue = function(p2): boolean
			return p2.isOfflineFrequents == true
		end
	} or nil,
	friendshipAgeInsight = {
		field = "friendshipAgeUnixSeconds",
		hasValue = function(p2): boolean
			local friendshipAgeUnixSeconds = p2.friendshipAgeUnixSeconds
			return friendshipAgeUnixSeconds ~= nil and friendshipAgeUnixSeconds ~= -1
		end
	},
	friendRequestOriginInsight = {
		field = "friendRequestOriginSource",
		hasValue = function(p2): boolean
			if fFlagTrustedFriendCandidatesSection then
			end

			local friendRequestOriginSource = p2.friendRequestOriginSource
			return friendRequestOriginSource ~= nil and friendRequestOriginSource ~= -1
		end
	},
	accountCreationDateInsight = {
		field = "accountCreationDateUnixSeconds",
		hasValue = function(p2): boolean
			local accountCreationDateUnixSeconds = p2.accountCreationDateUnixSeconds
			return accountCreationDateUnixSeconds ~= nil and accountCreationDateUnixSeconds ~= -1
		end
	},
	accountLocationInsight = {
		field = "localizedCountryName",
		hasValue = function(p2): boolean
			local localizedCountryName = p2.localizedCountryName
			return localizedCountryName ~= nil and localizedCountryName ~= ""
		end
	},
	classmatesInsight = fFlagProfileInsightsParseClassmates and {
		field = "isClassmate",
		hasValue = function(p2): boolean
			return p2.isClassmate == true
		end
	} or nil
}

local function getRankedInsightKeys(profileInsights, profileInsight)
	local fields = {}

	for k, item in profileInsights do
		for k2, v6 in v5 do
			if not (item[k2] and v6 and table.find(fields, v6.field) == nil and v6.hasValue(profileInsight)) then
				continue
			end

			table.insert(fields, v6.field)
		end
	end

	return fields
end

local function createProfileInsight(targetUser, item)
	local profileInsight = {
		userId = targetUser,
		mutualFriends = {},
		targetUserId = "",
		isOfflineFrequents = false
	}

	if not item or type(item) ~= "table" then
		return profileInsight
	end

	if item.targetUser then
		profileInsight.targetUserId = tostring(item.targetUser)
	end

	for k, profileInsight2 in item.profileInsights do
		if profileInsight2.mutualFriendInsight and profileInsight2.mutualFriendInsight.mutualFriends then
			local mutualFriends = profileInsight2.mutualFriendInsight.mutualFriends
			profileInsight.mutualFriends = Cryo.List.foldLeft(
				Cryo.Dictionary.keys(mutualFriends),
				function(list, p2)
					local mutualFriend = mutualFriends[p2]
					table.insert(list, {
						id = p2,
						username = mutualFriend.username,
						displayName = mutualFriend.displayName
					})

					return list
				end,
				{}
			)
		end

		if profileInsight2.offlineFrequentsInsight then
			profileInsight.isOfflineFrequents = profileInsight2.offlineFrequentsInsight.havePlayedTogether
		end

		if fFlagPlayerSearchEnableOnlineFrequents and profileInsight2.playedTogetherInsight then
			local playedTogetherInsight = profileInsight2.playedTogetherInsight
			profileInsight.isOfflineFrequents = profileInsight.isOfflineFrequents
				or playedTogetherInsight.havePlayedTogether
		end

		if profileInsight2.friendshipAgeInsight then
			local friendshipAgeInsight = profileInsight2.friendshipAgeInsight
			profileInsight.friendshipAgeUnixSeconds = friendshipAgeInsight.friendsSinceDateTime
				and friendshipAgeInsight.friendsSinceDateTime.seconds
				or -1
		end

		if profileInsight2.friendRequestOriginInsight then
			profileInsight.friendRequestOriginSource = profileInsight2.friendRequestOriginInsight.friendRequestOriginSource
				or -1
		end

		if profileInsight2.accountCreationDateInsight then
			local accountCreationDateInsight = profileInsight2.accountCreationDateInsight
			profileInsight.accountCreationDateUnixSeconds = accountCreationDateInsight.accountCreatedDateTime
				and accountCreationDateInsight.accountCreatedDateTime.seconds
				or -1
		end

		if profileInsight2.accountLocationInsight then
			local accountLocationInsight = profileInsight2.accountLocationInsight
			profileInsight.localizedCountryName = accountLocationInsight
				and accountLocationInsight.localizedCountryName
				or ""
		end

		if fFlagProfileInsightsParseClassmates and profileInsight2.classmatesInsight then
			profileInsight.isClassmate = profileInsight2.classmatesInsight.isClassmate == true
		end

		if not profileInsight2.accountCreationDateInsight then
			continue
		end

		local accountCreationDateInsight = profileInsight2.accountCreationDateInsight

		if
			accountCreationDateInsight
			and accountCreationDateInsight.namespace
			and accountCreationDateInsight.verifiedAgeBandLabel
		then
			profileInsight.userAgeVerifiedBracket = `{accountCreationDateInsight.namespace}.{accountCreationDateInsight.verifiedAgeBandLabel}`
		end
	end

	if fFlagProfileInsightsKeyByRankingStrategy then
		profileInsight.rankedInsightKeys = getRankedInsightKeys(item.profileInsights, profileInsight)
	end

	return profileInsight
end

return {
	createProfileInsightsSignalList = function()
		local signal, v6 = createSignal({})
		return { getProfileInsights = signal, setProfileInsights = v6 }
	end,
	createProfileInsightsList = function(items)
		local profileInsightsList = {}

		if not items or type(items) ~= "table" then
			return profileInsightsList
		end

		for k, item in items do
			table.insert(profileInsightsList, createProfileInsight(item.targetUser, item))
		end

		return profileInsightsList
	end,
	createProfileInsight = createProfileInsight
}
