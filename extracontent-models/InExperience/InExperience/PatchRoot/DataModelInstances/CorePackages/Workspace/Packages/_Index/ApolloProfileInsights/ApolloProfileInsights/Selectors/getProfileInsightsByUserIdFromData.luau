local parent = script:FindFirstAncestor("ApolloProfileInsights").Parent
local Cryo = require(parent.Cryo)

require(parent.GraphQLServer)

return function(p, p2)
	if p and p.profilesInsightsByUserIds then
		local profilesInsightsByUserIds = p.profilesInsightsByUserIds

		return profilesInsightsByUserIds[Cryo.List.findWhere(profilesInsightsByUserIds, function(p3, _): boolean
			return p3.targetUserId == tostring(p2)
		end)]
	end

	return nil
end
