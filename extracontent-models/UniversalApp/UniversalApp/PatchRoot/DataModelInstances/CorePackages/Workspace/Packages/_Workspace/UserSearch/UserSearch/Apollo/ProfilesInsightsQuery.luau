local Parent = script:FindFirstAncestor("UserSearch").Parent

return {
	query = require(Parent.ApolloClient).gql(require(script.Parent.ProfilesInsights)),
	createPageId = function(s1: string) -- line: 12
		return "PROFILE_INSIGHTS_SEARCH_PAGE_ID" .. ":" .. s1
	end
}
