local parent = script.Parent.Parent.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireTelemetry = SocialLuaAnalytics.Analytics.FireEvent.fireTelemetry

local DiagActionList = require(script.Parent.DiagActionList)
require(script.Parent.EventNames)
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return function(p)
	local v = fireEventStream({
		eventStreamImpl = p.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = p.infoForAllEvents
	})

	local v2 = fireDiagCounter({ diagImpl = p.analytics.Diag, eventList = DiagActionList })

	local v3 = fireTelemetry({
		telemetryImpl = p.analytics.Telemetry,
		eventList = TelemetryActionList
	})

	return function(p2, p3)
		if DiagActionList[p2] then
			v2(p2)
		end

		if TelemetryActionList[p2] then
			v3(p2, p3)
		end

		if EventStreamActionList[p2] then
			v(p2, p3)
		end
	end
end
