local useQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/ApolloClient").useQuery

local ProfilesInsightsQuery = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Apollo/ProfilesInsightsQuery")

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents

return function(list, p2, rankingStrategy)
	local pageId = ProfilesInsightsQuery.createPageId(p2)

	local query = ProfilesInsightsQuery.query
	local v6 = {
		errorPolicy = "all",
		skip = not list or #list == 0,
		variables = 0
	}

	if not fFlagPlayerSearchEnableOnlineFrequents then
		rankingStrategy = nil
	end

	v6.variables = {
		userIds = list,
		pageId = pageId,
		rankingStrategy = rankingStrategy
	}
	return (useQuery(query, v6))
end
