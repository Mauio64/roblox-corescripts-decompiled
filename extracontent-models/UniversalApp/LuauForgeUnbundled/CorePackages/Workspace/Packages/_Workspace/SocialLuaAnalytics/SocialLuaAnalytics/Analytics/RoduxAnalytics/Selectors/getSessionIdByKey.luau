require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/RoduxAnalytics/AnalyticsTypes")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Utils/getDeepValue")

return function(p2)
	local keyPath = p2.keyPath
	return function(p3)
		return function(p4)
			return getDeepValue(p3, string.format("%s.bySessionKey.%s", keyPath, p4))
		end
	end
end
