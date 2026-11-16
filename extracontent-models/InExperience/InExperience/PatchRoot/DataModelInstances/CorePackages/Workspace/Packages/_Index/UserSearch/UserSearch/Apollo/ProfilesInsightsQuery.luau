local parent = script:FindFirstAncestor("UserSearch").Parent

local ApolloClient = require(parent.ApolloClient)
return {
	query = ApolloClient.gql(require(script.Parent.ProfilesInsights)),
	createPageId = function(p: string)
		return "PROFILE_INSIGHTS_SEARCH_PAGE_ID" .. ":" .. p
	end
}
