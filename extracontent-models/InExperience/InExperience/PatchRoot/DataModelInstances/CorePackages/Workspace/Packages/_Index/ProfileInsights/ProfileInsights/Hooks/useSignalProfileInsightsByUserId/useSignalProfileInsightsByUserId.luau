local ProfileInsights = script:FindFirstAncestor("ProfileInsights")
local parent = ProfileInsights.Parent

local ProfileInsightsStore = require(ProfileInsights["data-hydration"].ProfileInsightsStore)

local SignalsReact = require(parent.SignalsReact)
local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddFriendsPageTrustedFriendRequestSection = SharedFlags.FFlagAddFriendsPageTrustedFriendRequestSection

local function useSignalProfileInsightsByUserId(data)
	local v = React.useMemo(function()
		local getProfileInsightsByUserId = ProfileInsightsStore(false).getProfileInsightsByUserId
		local v = {
			userIds = { data.userId },
			rankingStrategy = data.rankingStrategy,
			skipFetch = 0,
			forceFetch = 0
		}
		local skipFetch

		if FFlagAddFriendsPageTrustedFriendRequestSection then
			skipFetch = data.skipFetch
		end

		v.skipFetch = skipFetch
		v.forceFetch = data.forceFetch
		return getProfileInsightsByUserId(v)
	end, { data.userId, data.rankingStrategy, data.skipFetch, data.forceFetch })

	local v2 = SignalsReact.useSignalState(v(false).data.getProfileInsights)

	return React.useMemo(function()
		for _, v3 in v2 do
			if v3.targetUserId == data.userId then
				return v3
			end
		end

		return {}
	end, { v2 }), v(false).status == "fetching"
end

return useSignalProfileInsightsByUserId
