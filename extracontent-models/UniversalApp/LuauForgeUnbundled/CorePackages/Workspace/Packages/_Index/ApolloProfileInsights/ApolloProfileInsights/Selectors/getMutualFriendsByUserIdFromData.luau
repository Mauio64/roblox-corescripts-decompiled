local getProfileInsightsByUserIdFromData = require("@game/CorePackages/Workspace/Packages/_Index/ApolloProfileInsights/ApolloProfileInsights/Selectors/getProfileInsightsByUserIdFromData")

require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/GraphQLServer")

return function(p2, p3)
	local v5 = getProfileInsightsByUserIdFromData(p2, p3)
	local v6

	if not v5 then
		v6 = {}
		return v6
	end

	v6 = v5.mutualFriends

	if v6 then
		return v6
	end

	return {}
end
