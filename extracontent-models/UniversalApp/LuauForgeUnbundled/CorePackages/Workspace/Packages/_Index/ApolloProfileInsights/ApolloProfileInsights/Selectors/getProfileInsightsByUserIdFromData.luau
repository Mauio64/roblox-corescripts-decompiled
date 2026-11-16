local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/GraphQLServer")

return function(p2, p3)
	if p2 and p2.profilesInsightsByUserIds then
		local profilesInsightsByUserIds = p2.profilesInsightsByUserIds

		return profilesInsightsByUserIds[Cryo.List.findWhere(
			profilesInsightsByUserIds,
			function(p4, p5): boolean
				return p4.targetUserId == tostring(p3)
			end
		)]
	end

	return nil
end
