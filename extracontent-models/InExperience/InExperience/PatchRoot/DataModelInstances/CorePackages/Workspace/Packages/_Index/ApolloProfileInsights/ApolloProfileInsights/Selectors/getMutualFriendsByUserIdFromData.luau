local parent = script:FindFirstAncestor("ApolloProfileInsights").Parent

local getProfileInsightsByUserIdFromData = require(script.Parent.getProfileInsightsByUserIdFromData)

require(parent.GraphQLServer)

return function(p, p2)
	local profileInsightsByUserIdFromData = getProfileInsightsByUserIdFromData(p, p2)
	local v

	if not profileInsightsByUserIdFromData then
		return {}
	end

	v = profileInsightsByUserIdFromData.mutualFriends
	return v or {}
end
