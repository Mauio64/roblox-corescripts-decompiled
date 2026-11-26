local ProfileInsightsStore = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration/ProfileInsightsStore")

local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SignalsReact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/React")

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagAddFriendsPageTrustedFriendRequestSection

local function useSignalProfileInsightsByUserId(data)
	local v5 = React.useMemo(function()
		local getProfileInsightsByUserId = ProfileInsightsStore(false).getProfileInsightsByUserId
		local v6 = {
			userIds = { data.userId },
			rankingStrategy = data.rankingStrategy,
			skipFetch = 0,
			forceFetch = 0
		}
		local v7 = if fFlagAddFriendsPageTrustedFriendRequestSection then data.skipFetch else nil
		v6.skipFetch = v7
		v6.forceFetch = data.forceFetch
		return getProfileInsightsByUserId(v6)
	end, { data.userId, data.rankingStrategy, data.skipFetch, data.forceFetch })

	local v6 = SignalsReact.useSignalState(v5(false).data.getProfileInsights)

	return React.useMemo(function()
		for k, v7 in v6 do
			if v7.targetUserId == data.userId then
				return v7
			end
		end

		return {}
	end, { v6 }), v5(false).status == "fetching"
end

return useSignalProfileInsightsByUserId
