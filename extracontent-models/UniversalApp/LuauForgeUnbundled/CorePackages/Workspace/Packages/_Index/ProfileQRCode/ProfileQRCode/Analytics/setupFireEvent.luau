local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SocialLuaAnalytics")

local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/DiagActionList")
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventStreamActionList")

return function(p2)
	local v5 = fireEventStream({
		eventStreamImpl = p2.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = p2.infoForAllEvents
	})

	local v6 = fireDiagCounter({ diagImpl = p2.analytics.Diag, eventList = DiagActionList })

	return function(p3, p4)
		if DiagActionList[p3] then
			v6(p3)
		end

		return v5(p3, p4)
	end
end
