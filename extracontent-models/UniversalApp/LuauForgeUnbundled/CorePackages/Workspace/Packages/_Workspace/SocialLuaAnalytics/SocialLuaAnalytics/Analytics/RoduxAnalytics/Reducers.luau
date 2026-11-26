local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/dependencies").Rodux
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/AnalyticsTypes")

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/Reducers/bySessionKey")

return function(p2)
	return rodux.combineReducers({ bySessionKey = module(p2) })
end
