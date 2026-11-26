return {
	formatRecommendationContextType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Formatters/formatRecommendationContextType"),
	formatPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Formatters/formatPresence"),
	createDiagMetricString = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Formatters/createDiagMetricString"),
	repeatValue = function(p2, p3)
		return table.concat(table.create(p3, (tostring(p2))), ",")
	end
}
