local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

local hostAnalyticsListener = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/hostAnalyticsListener")

local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent

return function(p2, p3)
	fireAnalyticsEvent(p2, p3)

	local v5 = hostAnalyticsListener.get()

	if v5 ~= nil then
		v5(p2, p3)
	end
end
