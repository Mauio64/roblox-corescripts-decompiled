local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Dash")
local useProfileInsightsFetch = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/ProfileInsightsContextFetchWrapper/useProfileInsightsFetch")
local useMatchSearchPagination = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Utils/useMatchSearchPagination")

local ProfileInsights = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/ProfileInsights")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/LocalTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/GraphQLServer")

local getFFlagEnableProfileInsightsApolloMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").GetFFlagEnableProfileInsightsApolloMigration

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents
local fFlagUserSearchClassmatesInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchClassmatesInsight

local function fn(p2)
	return Dash.reduce(p2, function(p3, p4)
		p3[p4.targetUserId] = p4
		return p3
	end, {})
end

return function(data)
	local users = data.users or {}
	local v5 = useMatchSearchPagination({ users = users })

	local v6 = React.useMemo(function()
		return Dash.map(v5, function(p2)
			return p2.id
		end)
	end, { v5 })
	local v7

	if getFFlagEnableProfileInsightsApolloMigration() then
		local getProfileInsightsByPage = ProfileInsights.ProfileInsightsStore(false).getProfileInsightsByPage
		local v8 = {
			pageId = "PROFILE_INSIGHTS_SEARCH_PAGE_ID" .. ":" .. data.searchKeyword,
			userIds = v6,
			rankingStrategy = 0,
			count = 0
		}

		local v9 = if fFlagPlayerSearchEnableOnlineFrequents then data.rankingStrategy else nil
		v8.rankingStrategy = v9
		v8.count = fFlagUserSearchClassmatesInsight
			and fFlagPlayerSearchEnableOnlineFrequents
			and data.rankingStrategy
			and 3
			or nil
		local profileInsightsByPage = getProfileInsightsByPage(v8)

		v7 = SignalsReact.useSignalState(profileInsightsByPage(false).data.getProfileInsights)
	else
		local searchKeyword = data.searchKeyword
		local v9 = if fFlagPlayerSearchEnableOnlineFrequents then data.rankingStrategy else nil
		local v10 = useProfileInsightsFetch(v6, searchKeyword, v9)

		v7 = not (v10.data and v10.data.profilesInsights) and {}
			or v10.data.profilesInsights.profileInsights
	end

	return (React.useMemo(function()
		return fn(v7)
	end, { v7 }))
end
