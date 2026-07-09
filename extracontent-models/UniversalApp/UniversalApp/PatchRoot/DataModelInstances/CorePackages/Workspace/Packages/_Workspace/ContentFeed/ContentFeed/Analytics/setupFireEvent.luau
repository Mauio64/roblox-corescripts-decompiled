local ParentParent = script.Parent.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.SocialLuaAnalytics)
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireTelemetry = SocialLuaAnalytics.Analytics.FireEvent.fireTelemetry

require(script.Parent.EventNames)

local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: fireEventStream (copy), EventStreamActionList (copy), fireTelemetry (copy), TelemetryActionList (copy)
	local v8 = fireEventStream({
		eventStreamImpl = t1.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = t1.infoForAllEvents
	})
	local v9 = fireTelemetry({
		telemetryImpl = t1.analytics.Telemetry,
		eventList = TelemetryActionList
	})

	return function(p1, p2) -- line: 28
		-- upvalues: TelemetryActionList (copy), v9 (copy), EventStreamActionList (copy), v8 (copy)
		if TelemetryActionList[p1] then
			v9(p1, p2)
		end

		if EventStreamActionList[p1] then
			v8(p1, p2)
		end
	end
end
