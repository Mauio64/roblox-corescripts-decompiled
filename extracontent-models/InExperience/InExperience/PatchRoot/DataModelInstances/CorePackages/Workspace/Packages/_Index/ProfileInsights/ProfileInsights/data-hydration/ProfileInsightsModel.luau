local parent = script:FindFirstAncestor("ProfileInsights").Parent

local Cryo = require(parent.Cryo)

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local SharedFlags = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequents = SharedFlags.FFlagPlayerSearchEnableOnlineFrequents
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileInsightsParseClassmates = SharedFlags2.FFlagProfileInsightsParseClassmates
local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfileInsightsKeyByRankingStrategy = SharedFlags3.FFlagProfileInsightsKeyByRankingStrategy
local SharedFlags4 = require(parent.SharedFlags)
local FFlagTrustedFriendCandidatesSection = SharedFlags4.FFlagTrustedFriendCandidatesSection

local function hasNumberValue(p: number?): boolean -- 3 equivalent calls inferred from this helper
	return p ~= nil and p ~= -1
end

local v = {
	mutualFriendInsight = {
		field = "mutualFriends",
		hasValue = function(p): boolean
			return #p.mutualFriends > 0
		end
	},
	offlineFrequentsInsight = {
		field = "isOfflineFrequents",
		hasValue = function(p): boolean
			return p.isOfflineFrequents == true
		end
	},
	playedTogetherInsight = FFlagPlayerSearchEnableOnlineFrequents and {
		field = "isOfflineFrequents",
		hasValue = function(p): boolean
			return p.isOfflineFrequents == true
		end
	} or nil,
	friendshipAgeInsight = {
		field = "friendshipAgeUnixSeconds",
		hasValue = function(p)
			return hasNumberValue(p.friendshipAgeUnixSeconds) -- inferred equivalent call
		end
	},
	friendRequestOriginInsight = {
		field = "friendRequestOriginSource",
		hasValue = function(p)
			if FFlagTrustedFriendCandidatesSection then
			end

			return hasNumberValue(p.friendRequestOriginSource) -- inferred equivalent call
		end
	},
	accountCreationDateInsight = {
		field = "accountCreationDateUnixSeconds",
		hasValue = function(p)
			return hasNumberValue(p.accountCreationDateUnixSeconds) -- inferred equivalent call
		end
	},
	accountLocationInsight = {
		field = "localizedCountryName",
		hasValue = function(p): boolean
			local localizedCountryName = p.localizedCountryName
			return localizedCountryName ~= nil and localizedCountryName ~= ""
		end
	},
	classmatesInsight = FFlagProfileInsightsParseClassmates and {
		field = "isClassmate",
		hasValue = function(p): boolean
			return p.isClassmate == true
		end
	} or nil
}

local function getRankedInsightKeys(profileInsights, profileInsight)
	local fields = {}

	for _, item in profileInsights do
		for k, v2 in v do
			if not (item[k] and v2 and table.find(fields, v2.field) == nil and v2.hasValue(profileInsight)) then
				continue
			end

			table.insert(fields, v2.field)
		end
	end

	return fields
end

local function createProfileInsight(targetUser: string, item)
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

	for _, profileInsight2 in item.profileInsights do
		if profileInsight2.mutualFriendInsight and profileInsight2.mutualFriendInsight.mutualFriends then
			local mutualFriends = profileInsight2.mutualFriendInsight.mutualFriends
			profileInsight.mutualFriends = Cryo.List.foldLeft(Cryo.Dictionary.keys(mutualFriends), function(list, id)
				local mutualFriend = mutualFriends[id]
				table.insert(list, {
					id = id,
					username = mutualFriend.username,
					displayName = mutualFriend.displayName
				})

				return list
			end, {})
		end

		if profileInsight2.offlineFrequentsInsight then
			profileInsight.isOfflineFrequents = profileInsight2.offlineFrequentsInsight.havePlayedTogether
		end

		if FFlagPlayerSearchEnableOnlineFrequents and profileInsight2.playedTogetherInsight then
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

		if FFlagProfileInsightsParseClassmates and profileInsight2.classmatesInsight then
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

	if FFlagProfileInsightsKeyByRankingStrategy then
		profileInsight.rankedInsightKeys = getRankedInsightKeys(item.profileInsights, profileInsight)
	end

	return profileInsight
end

local ProfileInsightsModel = {}

function ProfileInsightsModel.createProfileInsightsSignalList()
	local signal, setProfileInsights = createSignal({})
	return { getProfileInsights = signal, setProfileInsights = setProfileInsights }
end

function ProfileInsightsModel.createProfileInsightsList(items)
	local profileInsightsList = {}

	if not items or type(items) ~= "table" then
		return profileInsightsList
	end

	for _, item in items do
		table.insert(profileInsightsList, createProfileInsight(item.targetUser, item))
	end

	return profileInsightsList
end

ProfileInsightsModel.createProfileInsight = createProfileInsight
return ProfileInsightsModel
