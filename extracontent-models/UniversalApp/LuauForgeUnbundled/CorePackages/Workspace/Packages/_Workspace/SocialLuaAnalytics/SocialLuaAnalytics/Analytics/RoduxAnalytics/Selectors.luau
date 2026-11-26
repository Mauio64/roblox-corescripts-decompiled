require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/AnalyticsTypes")
local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/Selectors/getSessionIdByKey")

return function(p2)
	return { getSessionIdByKey = module(p2) }
end
