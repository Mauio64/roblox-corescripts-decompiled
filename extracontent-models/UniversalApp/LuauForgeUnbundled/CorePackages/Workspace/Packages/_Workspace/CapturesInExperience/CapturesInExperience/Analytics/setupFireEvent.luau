local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/SocialLuaAnalytics")

local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireTelemetry = SocialLuaAnalytics.Analytics.FireEvent.fireTelemetry

require("@luauforge/deferred/dWP")
local module2 = require("@luauforge/deferred/dXY")
local module3 = require("@luauforge/deferred/dYa")

return function(p2)
	local v5 = fireEventStream({
		eventStreamImpl = p2.analytics.EventStream,
		eventList = module2,
		infoForAllEvents = p2.infoForAllEvents
	})

	local v6 = fireTelemetry({
		telemetryImpl = p2.analytics.Telemetry,
		eventList = module3
	})

	return function(p3, p4)
		if module3[p3] then
			v6(p3, p4)
		end

		if module2[p3] then
			v5(p3, p4)
		end
	end
end
