local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Cryo")

local AnalyticsFactory = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/AnalyticsFactory/AnalyticsFactory")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

local function setUpAnalyticsFactory(p2)
	return function(p3)
		local joined = Cryo.Dictionary.join(
			p2.staticInfoForAllEvents or {},
			p3 and p3.infoForAllEvents or {}
		)

		return AnalyticsFactory(Cryo.Dictionary.join(p2, { infoForAllEvents = joined }))
	end
end

return setUpAnalyticsFactory
