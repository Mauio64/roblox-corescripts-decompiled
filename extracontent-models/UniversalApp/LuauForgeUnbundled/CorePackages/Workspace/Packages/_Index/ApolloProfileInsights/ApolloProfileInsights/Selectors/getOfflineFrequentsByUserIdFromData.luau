local getProfileInsightsByUserIdFromData = require("@game/CorePackages/Workspace/Packages/_Index/ApolloProfileInsights/ApolloProfileInsights/Selectors/getProfileInsightsByUserIdFromData")

return function(p2, p3)
	local v5 = getProfileInsightsByUserIdFromData(p2, p3)

	if v5 then
		return v5.isOfflineFrequents or false
	end

	return false
end
