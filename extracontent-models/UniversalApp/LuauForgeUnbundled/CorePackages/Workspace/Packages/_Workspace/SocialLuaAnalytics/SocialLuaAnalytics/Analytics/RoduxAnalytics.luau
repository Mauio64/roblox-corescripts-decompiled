local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/Actions")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/Selectors")
local Reducers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/Reducers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/AnalyticsTypes")

return {
	config = function(p2)
		return {
			installReducer = function()
				return Reducers(p2)
			end,
			Actions = module(p2),
			Selectors = module2(p2)
		}
	end
}
