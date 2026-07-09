local ParentParent = script.Parent.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.SocialLuaAnalytics)
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireEventStream = SocialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireTelemetry = SocialLuaAnalytics.Analytics.FireEvent.fireTelemetry
local DiagActionList = require(script.Parent.DiagActionList)

require(script.Parent.EventNames)

local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: fireEventStream (copy), EventStreamActionList (copy), fireDiagCounter (copy), DiagActionList (copy), fireTelemetry (copy), TelemetryActionList (copy)
	local v10 = fireEventStream({
		eventStreamImpl = t1.analytics.EventStream,
		eventList = EventStreamActionList,
		infoForAllEvents = t1.infoForAllEvents
	})
	local v11 = fireDiagCounter({
		diagImpl = t1.analytics.Diag,
		eventList = DiagActionList
	})
	local v12 = fireTelemetry({
		telemetryImpl = t1.analytics.Telemetry,
		eventList = TelemetryActionList
	})

	return function(p1, p2) -- line: 35
		-- upvalues: DiagActionList (copy), v11 (copy), TelemetryActionList (copy), v12 (copy), EventStreamActionList (copy), v10 (copy)
		if DiagActionList[p1] then
			v11(p1)
		end

		if TelemetryActionList[p1] then
			v12(p1, p2)
		end

		if EventStreamActionList[p1] then
			v10(p1, p2)
		end
	end
end
