local fireEventStream = require(script.Parent.fireEventStream)
local fireDiag = require(script.Parent.fireDiag)
local fireTelemetry = require(script.Parent.fireTelemetry)

require(script.Parent.Parent.Types)

local function setupFireEvent(t1: {[any]: any}, t2: {[any]: any}) -- line: 23
	-- upvalues: fireEventStream (copy), fireDiag (copy), fireTelemetry (copy)
	local v8 = if not t1.analytics.EventStream or not t2.EventStream then nil else fireEventStream({
		eventStreamImpl = t1.analytics.EventStream,
		eventList = t2.EventStream,
		infoForAllEvents = t1.infoForAllEvents,
		getInfoForAllEvents = t1.getInfoForAllEvents,
		loggerImpl = t1.loggerImpl
	})
	local v9 = if not t1.analytics.Diag or not t2.Diag then nil else fireDiag({
		diagImpl = t1.analytics.Diag,
		eventList = t2.Diag,
		loggerImpl = t1.loggerImpl
	})
	local v10 = if not t1.analytics.Telemetry or not t2.Telemetry then nil else fireTelemetry({
		telemetryImpl = t1.analytics.Telemetry,
		eventList = t2.Telemetry,
		getInfoForAllEvents = t1.getInfoForAllEvents,
		loggerImpl = t1.loggerImpl
	})

	return function(p1, p2) -- line: 51
		-- upvalues: v9 (copy), t2 (copy), v8 (copy), v10 (copy)
		if v9 and (t2.Diag and t2.Diag[p1]) then
			v9(p1, p2)
		end

		if v8 and t2.EventStream and t2.EventStream[p1] then
			v8(p1, p2)
		end

		if v10 and t2.Telemetry and t2.Telemetry[p1] then
			v10(p1, p2)
		end

		return p1, p2
	end
end
local function createFireEvent(t3: {[any]: any}) -- line: 72
	-- upvalues: setupFireEvent (copy)
	return function(t4: {[any]: any}) -- line: 73
		-- upvalues: setupFireEvent (copy), t3 (copy)
		return (setupFireEvent(t4, t3))
	end
end

return createFireEvent
