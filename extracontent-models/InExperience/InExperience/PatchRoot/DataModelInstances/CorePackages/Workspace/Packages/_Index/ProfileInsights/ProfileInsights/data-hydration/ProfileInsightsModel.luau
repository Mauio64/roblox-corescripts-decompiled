local parent = script:FindFirstAncestor("ProfileInsights").Parent

local Cryo = require(parent.Cryo)

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local SharedFlags = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequents = SharedFlags.FFlagPlayerSearchEnableOnlineFrequents
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileInsightsParseClassmates = SharedFlags2.FFlagProfileInsightsParseClassmates

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
