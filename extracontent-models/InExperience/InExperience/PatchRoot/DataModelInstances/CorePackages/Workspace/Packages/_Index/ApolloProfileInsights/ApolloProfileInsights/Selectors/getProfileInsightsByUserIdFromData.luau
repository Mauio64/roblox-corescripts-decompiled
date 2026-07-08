local Parent = script:FindFirstAncestor("ApolloProfileInsights").Parent
local Cryo = require(Parent.Cryo)

require(Parent.GraphQLServer)

return function(t1: {[any]: any}?, p1) -- line: 12
	-- upvalues: Cryo (copy)
	if not t1 or not t1.profilesInsightsByUserIds then
		return nil
	end

	local profilesInsightsByUserIds = t1.profilesInsightsByUserIds

	return profilesInsightsByUserIds[Cryo.List.findWhere(profilesInsightsByUserIds, function(p2, _) -- line: 20
		-- upvalues: p1 (copy)
		return p2.targetUserId == tostring(p1)
	end)]
end
