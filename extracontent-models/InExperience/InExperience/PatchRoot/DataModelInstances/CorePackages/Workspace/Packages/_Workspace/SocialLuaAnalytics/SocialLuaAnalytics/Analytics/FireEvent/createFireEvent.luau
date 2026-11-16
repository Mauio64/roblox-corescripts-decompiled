local fireEventStream = require(script.Parent.fireEventStream)
local fireDiag = require(script.Parent.fireDiag)
local fireTelemetry = require(script.Parent.fireTelemetry)
require(script.Parent.Parent.Types)

local function setupFireEvent(data, data2)
	local v

	if data.analytics.EventStream and data2.EventStream then
		v = fireEventStream({
			eventStreamImpl = data.analytics.EventStream,
			eventList = data2.EventStream,
			infoForAllEvents = data.infoForAllEvents,
			getInfoForAllEvents = data.getInfoForAllEvents,
			loggerImpl = data.loggerImpl
		})
	else
		v = nil
	end

	local v2

	if data.analytics.Diag and data2.Diag then
		v2 = fireDiag({
			diagImpl = data.analytics.Diag,
			eventList = data2.Diag,
			loggerImpl = data.loggerImpl
		})
	else
		v2 = nil
	end

	local v3

	if data.analytics.Telemetry and data2.Telemetry then
		v3 = fireTelemetry({
			telemetryImpl = data.analytics.Telemetry,
			eventList = data2.Telemetry,
			getInfoForAllEvents = data.getInfoForAllEvents,
			loggerImpl = data.loggerImpl
		})
	else
		v3 = nil
	end

	return function(p, p2)
		if v2 and data2.Diag and data2.Diag[p] then
			v2(p, p2)
		end

		if v and data2.EventStream and data2.EventStream[p] then
			v(p, p2)
		end

		if v3 and data2.Telemetry and data2.Telemetry[p] then
			v3(p, p2)
		end

		return p, p2
	end
end

local function createFireEvent(p)
	return function(p2)
		return setupFireEvent(p2, p)
	end
end

return createFireEvent
