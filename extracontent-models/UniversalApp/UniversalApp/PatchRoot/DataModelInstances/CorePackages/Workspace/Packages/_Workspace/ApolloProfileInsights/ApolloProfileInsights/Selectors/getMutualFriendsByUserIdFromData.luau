local Parent = script:FindFirstAncestor("ApolloProfileInsights").Parent
local getProfileInsightsByUserIdFromData = require(script.Parent.getProfileInsightsByUserIdFromData)

require(Parent.GraphQLServer)

return function(p1, p2) -- line: 11
	-- upvalues: getProfileInsightsByUserIdFromData (copy)
	local v5 = getProfileInsightsByUserIdFromData(p1, p2)
	local mutualFriends

	if v5 then
		mutualFriends = v5.mutualFriends

		if not mutualFriends then
			return {}
		end
	else
		mutualFriends = {}
	end

	return mutualFriends
end
