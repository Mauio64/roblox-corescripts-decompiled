local Parent = script:FindFirstAncestor("ApolloProfileInsights").Parent
local ApolloClient = require(Parent.ApolloClient)
local ApolloLocalState = require(Parent.ApolloLocalState)
local useQuery = ApolloClient.useQuery
local queries = ApolloLocalState.queries

local function useProfileInsightsByUserIds(t1: {[any]: any}) -- line: 17
	-- upvalues: useQuery (copy), queries (copy)
	return (useQuery(queries.profilesInsightsByUserIds, {
		errorPolicy = "all",
		skip = not t1.userIds or t1.skip,
		variables = {
			userIds = t1.userIds,
			rankingStrategy = t1.rankingStrategy
		},
		fetchPolicy = t1.fetchPolicy
	}))
end

return useProfileInsightsByUserIds
