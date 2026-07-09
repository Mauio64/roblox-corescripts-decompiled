local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local useQuery = require(UserSearchParent.ApolloClient).useQuery
local ProfilesInsightsQuery = require(UserSearch.Apollo.ProfilesInsightsQuery)
local FFlagPlayerSearchEnableOnlineFrequents = require(UserSearchParent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents

return function(t1: {[any]: any}, s1: string, s2: string?) -- line: 11
	-- upvalues: ProfilesInsightsQuery (copy), useQuery (copy), FFlagPlayerSearchEnableOnlineFrequents (copy)
	local v9 = ProfilesInsightsQuery.createPageId(s1)

	return (useQuery(ProfilesInsightsQuery.query, {
		errorPolicy = "all",
		skip = not t1 or #t1 == 0,
		variables = {
			userIds = t1,
			pageId = v9,
			rankingStrategy = if not FFlagPlayerSearchEnableOnlineFrequents then nil else s2
		}
	}))
end
