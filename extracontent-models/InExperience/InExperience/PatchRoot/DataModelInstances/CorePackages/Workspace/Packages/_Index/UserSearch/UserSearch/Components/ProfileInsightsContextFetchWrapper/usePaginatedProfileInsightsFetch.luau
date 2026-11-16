local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local useProfileInsightsFetch = require(script.Parent.useProfileInsightsFetch)
local useMatchSearchPagination = require(UserSearch.Utils.useMatchSearchPagination)

local ProfileInsights = require(parent.ProfileInsights)
local SignalsReact = require(parent.SignalsReact)

require(UserSearch.Common.LocalTypes)
require(parent.GraphQLServer)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableProfileInsightsApolloMigration = SharedFlags.GetFFlagEnableProfileInsightsApolloMigration

local SharedFlags2 = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequents = SharedFlags2.FFlagPlayerSearchEnableOnlineFrequents
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserSearchClassmatesInsight = SharedFlags3.FFlagUserSearchClassmatesInsight

local function fn(p)
	return Dash.reduce(p, function(p2, p3)
		p2[p3.targetUserId] = p3
		return p2
	end, {})
end

local function fn2(searchKeyword: string) -- 1 equivalent call inferred from this helper
	return "PROFILE_INSIGHTS_SEARCH_PAGE_ID" .. ":" .. searchKeyword
end

return function(data)
	local v = useMatchSearchPagination({
		users = data.users or {}
	})

	local userIds = React.useMemo(function()
		return Dash.map(v, function(p)
			return p.id
		end)
	end, { v })
	local v2

	if GetFFlagEnableProfileInsightsApolloMigration() then
		local getProfileInsightsByPage = ProfileInsights.ProfileInsightsStore(false).getProfileInsightsByPage
		local v3 = {
			pageId = fn2(data.searchKeyword), -- inferred equivalent call
			userIds = userIds,
			rankingStrategy = 0,
			count = 0
		}
		local rankingStrategy

		if FFlagPlayerSearchEnableOnlineFrequents then
			rankingStrategy = data.rankingStrategy
		end

		v3.rankingStrategy = rankingStrategy
		v3.count = FFlagUserSearchClassmatesInsight
			and FFlagPlayerSearchEnableOnlineFrequents
			and data.rankingStrategy
			and 3
			or nil
		local profileInsightsByPage = getProfileInsightsByPage(v3)

		v2 = SignalsReact.useSignalState(profileInsightsByPage(false).data.getProfileInsights)
	else
		local searchKeyword = data.searchKeyword
		local v3

		if FFlagPlayerSearchEnableOnlineFrequents then
			v3 = data.rankingStrategy
		end

		local v4 = useProfileInsightsFetch(userIds, searchKeyword, v3)

		v2 = not (v4.data and v4.data.profilesInsights) and {} or v4.data.profilesInsights.profileInsights
	end

	return (React.useMemo(function()
		return fn(v2)
	end, { v2 }))
end
