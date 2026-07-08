local Parent = script:FindFirstAncestor("ProfileInsights").Parent
local Cryo = require(Parent.Cryo)
local createSignal = require(Parent.Signals).createSignal
local FFlagPlayerSearchEnableOnlineFrequents = require(Parent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents

local function createProfileInsight(s1: string, p1) -- line: 39
	-- upvalues: Cryo (copy), FFlagPlayerSearchEnableOnlineFrequents (copy)
	local t1 = {
		targetUserId = "",
		isOfflineFrequents = false,
		userId = s1,
		mutualFriends = {}
	}

	if not p1 or type(p1) ~= "table" then
		return t1
	end

	if p1.targetUser then
		t1.targetUserId = tostring(p1.targetUser)
	end

	for _, v10 in p1.profileInsights do
		if v10.mutualFriendInsight and v10.mutualFriendInsight.mutualFriends then
			local mutualFriends = v10.mutualFriendInsight.mutualFriends

			t1.mutualFriends = Cryo.List.foldLeft(Cryo.Dictionary.keys(mutualFriends), function(p2, p3) -- line: 58
				-- upvalues: mutualFriends (copy)
				local v25 = mutualFriends[p3]

				table.insert(p2, {
					id = p3,
					username = v25.username,
					displayName = v25.displayName
				})

				return p2
			end, {})
		end

		if v10.offlineFrequentsInsight then
			t1.isOfflineFrequents = v10.offlineFrequentsInsight.havePlayedTogether
		end

		if FFlagPlayerSearchEnableOnlineFrequents and v10.playedTogetherInsight then
			local playedTogetherInsight = v10.playedTogetherInsight

			t1.isOfflineFrequents = t1.isOfflineFrequents or playedTogetherInsight.havePlayedTogether
		end

		if v10.friendshipAgeInsight then
			local friendshipAgeInsight = v10.friendshipAgeInsight

			t1.friendshipAgeUnixSeconds = friendshipAgeInsight.friendsSinceDateTime and friendshipAgeInsight.friendsSinceDateTime.seconds or -1
		end

		if v10.friendRequestOriginInsight then
			t1.friendRequestOriginSource = v10.friendRequestOriginInsight.friendRequestOriginSource or -1
		end

		if v10.accountCreationDateInsight then
			local accountCreationDateInsight = v10.accountCreationDateInsight

			t1.accountCreationDateUnixSeconds = accountCreationDateInsight.accountCreatedDateTime and accountCreationDateInsight.accountCreatedDateTime.seconds or -1
		end

		if v10.accountLocationInsight then
			local accountLocationInsight = v10.accountLocationInsight

			t1.localizedCountryName = accountLocationInsight and accountLocationInsight.localizedCountryName or ""
		end

		if v10.accountCreationDateInsight then
			local accountCreationDateInsight = v10.accountCreationDateInsight

			if accountCreationDateInsight and accountCreationDateInsight.namespace and accountCreationDateInsight.verifiedAgeBandLabel then
				t1.userAgeVerifiedBracket = `{ accountCreationDateInsight.namespace }.{ accountCreationDateInsight.verifiedAgeBandLabel }`
			end
		end
	end

	return t1
end

return {
	createProfileInsightsSignalList = function() -- line: 135
		-- upvalues: createSignal (copy)
		local v21, v22 = createSignal({})

		return {
			getProfileInsights = v21,
			setProfileInsights = v22
		}
	end,
	createProfileInsightsList = function(p4) -- line: 120
		-- upvalues: createProfileInsight (copy)
		local t2 = {}

		if not p4 or type(p4) ~= "table" then
			return t2
		end

		for _, v20 in p4 do
			table.insert(t2, (createProfileInsight(v20.targetUser, v20)))
		end

		return t2
	end,
	createProfileInsight = createProfileInsight
}
