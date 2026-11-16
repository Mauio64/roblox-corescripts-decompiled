local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/SocialLuaAnalytics")
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream

local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Analytics/EventStreamActionList")
local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Analytics/DiagActionList")

return function(p2)
	local v5 = fireEventStream({
		eventStreamImpl = p2.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = p2.infoForAllEvents
	})

	local v6 = fireDiagCounter({ diagImpl = p2.analytics.Diag, eventList = DiagActionList })

	return function(p3, p4)
		if v6 and DiagActionList[p3] then
			v6(p3)
		end

		return v5(p3, p4)
	end
end
