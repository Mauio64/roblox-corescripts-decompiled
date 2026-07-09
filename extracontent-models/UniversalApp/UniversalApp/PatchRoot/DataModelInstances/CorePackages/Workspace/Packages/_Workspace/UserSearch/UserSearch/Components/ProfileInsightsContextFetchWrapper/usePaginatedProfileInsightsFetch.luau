local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local React = require(UserSearchParent.React)
local Dash = require(UserSearchParent.Dash)
local useProfileInsightsFetch = require(script.Parent.useProfileInsightsFetch)
local useMatchSearchPagination = require(UserSearch.Utils.useMatchSearchPagination)
local ProfileInsights = require(UserSearchParent.ProfileInsights)
local SignalsReact = require(UserSearchParent.SignalsReact)

require(UserSearch.Common.LocalTypes)
require(UserSearchParent.GraphQLServer)

local GetFFlagEnableProfileInsightsApolloMigration = require(UserSearchParent.SharedFlags).GetFFlagEnableProfileInsightsApolloMigration
local FFlagPlayerSearchEnableOnlineFrequents = require(UserSearchParent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents

local function v11(t1: {[any]: any}) -- line: 30
	-- upvalues: Dash (copy)
	return Dash.reduce(t1, function(p1, p2) -- line: 31
		p1[p2.targetUserId] = p2

		return p1
	end, {})
end

return function(t2: {[any]: any}) -- line: 43
	-- upvalues: useMatchSearchPagination (copy), React (copy), Dash (copy), GetFFlagEnableProfileInsightsApolloMigration (copy), ProfileInsights (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), SignalsReact (copy), useProfileInsightsFetch (copy), v11 (copy)
	local v15 = t2.users or {}
	local v16 = useMatchSearchPagination({
		users = v15
	})
	local v17 = React.useMemo(function() -- line: 47
		-- upvalues: Dash (copy), v16 (copy)
		return Dash.map(v16, function(p3) -- line: 48
			return p3.id
		end)
	end, { v16 })
	local u19

	if GetFFlagEnableProfileInsightsApolloMigration() then
		local v18 = ProfileInsights.ProfileInsightsStore(false).getProfileInsightsByPage({
			pageId = "PROFILE_INSIGHTS_SEARCH_PAGE_ID" .. ":" .. t2.searchKeyword,
			userIds = v17,
			rankingStrategy = if not FFlagPlayerSearchEnableOnlineFrequents then nil else t2.rankingStrategy
		})

		u19 = SignalsReact.useSignalState(v18(false).data.getProfileInsights)
	else
		local v20 = useProfileInsightsFetch(v17, t2.searchKeyword, if not FFlagPlayerSearchEnableOnlineFrequents then nil else t2.rankingStrategy)

		u19 = if not v20.data or not v20.data.profilesInsights then {} else v20.data.profilesInsights.profileInsights
	end

	return (React.useMemo(function() -- line: 73
		-- upvalues: v11 (copy), u19 (ref)
		return v11(u19)
	end, { u19 }))
end
