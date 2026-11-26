return {
	query = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/ApolloClient").gql(require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Apollo/ProfilesInsights")),
	createPageId = function(p2)
		return "PROFILE_INSIGHTS_SEARCH_PAGE_ID" .. ":" .. p2
	end
}
