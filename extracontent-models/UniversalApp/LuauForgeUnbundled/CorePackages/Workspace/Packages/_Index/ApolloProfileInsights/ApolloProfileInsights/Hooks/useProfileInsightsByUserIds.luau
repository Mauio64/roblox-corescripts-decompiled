local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/ApolloClient")
local ApolloLocalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/ApolloLocalState")

local useQuery = ApolloClient.useQuery
local queries = ApolloLocalState.queries

local function useProfileInsightsByUserIds(data)
	return (useQuery(queries.profilesInsightsByUserIds, {
		errorPolicy = "all",
		skip = not data.userIds or data.skip,
		variables = { userIds = data.userIds, rankingStrategy = data.rankingStrategy },
		fetchPolicy = data.fetchPolicy
	}))
end

return useProfileInsightsByUserIds
