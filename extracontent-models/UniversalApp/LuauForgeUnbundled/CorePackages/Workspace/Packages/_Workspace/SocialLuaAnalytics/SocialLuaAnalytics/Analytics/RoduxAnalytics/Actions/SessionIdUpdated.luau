local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/dependencies")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/AnalyticsTypes")

return dependencies.Rodux.makeActionCreator("SessionIdUpdated", function(p2)
	return { payload = p2 }
end)
