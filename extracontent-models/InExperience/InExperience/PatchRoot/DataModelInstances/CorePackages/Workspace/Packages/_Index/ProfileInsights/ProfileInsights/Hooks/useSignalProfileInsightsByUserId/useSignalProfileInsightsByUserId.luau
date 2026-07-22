local ProfileInsights = script:FindFirstAncestor("ProfileInsights")
local ProfileInsightsParent = ProfileInsights.Parent
local ProfileInsightsStore = require(ProfileInsights["data-hydration"].ProfileInsightsStore)
local SignalsReact = require(ProfileInsightsParent.SignalsReact)
local React = require(ProfileInsightsParent.React)
local FFlagAddFriendsPageTrustedFriendRequestSection = require(ProfileInsightsParent.SharedFlags).FFlagAddFriendsPageTrustedFriendRequestSection

local function useSignalProfileInsightsByUserId(t1: {[any]: any}) -- line: 18
	-- upvalues: ProfileInsightsStore (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), SignalsReact (copy), React (copy)
	local v9 = ProfileInsightsStore(false).getProfileInsightsByUserId({
		userIds = { t1.userId },
		rankingStrategy = t1.rankingStrategy,
		skipFetch = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else t1.skipFetch
	})
	local v10 = SignalsReact.useSignalState(v9(false).data.getProfileInsights)

	return React.useMemo(function() -- line: 26
		-- upvalues: v10 (copy), t1 (copy)
		for _, v12 in v10 do
			if v12.targetUserId == t1.userId then
				return v12
			end
		end

		return {}
	end, { v10 }), v9(false).status == "fetching"
end

return useSignalProfileInsightsByUserId
