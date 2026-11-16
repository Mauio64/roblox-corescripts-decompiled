local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local ApolloClient = require(parent.ApolloClient)
local useQuery = ApolloClient.useQuery

local ProfilesInsightsQuery = require(UserSearch.Apollo.ProfilesInsightsQuery)

local SharedFlags = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequents = SharedFlags.FFlagPlayerSearchEnableOnlineFrequents

return function(userIds, p: string, rankingStrategy: string?)
	local pageId = ProfilesInsightsQuery.createPageId(p)

	local query = ProfilesInsightsQuery.query
	local v = {
		errorPolicy = "all",
		skip = not userIds or #userIds == 0,
		variables = 0
	}

	if not FFlagPlayerSearchEnableOnlineFrequents then
		rankingStrategy = nil
	end

	v.variables = { userIds = userIds, pageId = pageId, rankingStrategy = rankingStrategy }
	return (useQuery(query, v))
end
