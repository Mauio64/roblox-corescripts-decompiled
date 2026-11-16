local fireEventStream = require(script.Parent.Parent.FireEvent.fireEventStream)
local fireDiagCounter = require(script.Parent.Parent.FireEvent.fireDiagCounter)
local DiagEventList = require(script.Parent.DiagEventList)
local EventStreamEventList = require(script.Parent.EventStreamEventList)
require(script.Parent.Parent.FireEvent.Types)

return function(data)
	local v = fireEventStream({
		eventStreamImpl = data.analytics.EventStream,
		eventList = EventStreamEventList,
		loggerImpl = data.loggerImpl,
		infoForAllEvents = data.infoForAllEvents
	})

	local v2 = fireDiagCounter({
		diagImpl = data.analytics.Diag,
		eventList = DiagEventList,
		loggerImpl = data.loggerImpl
	})

	return function(p, p2)
		if EventStreamEventList[p] then
			v(p, p2)
		end

		if DiagEventList[p] then
			v2(p)
		end

		return DateTime.now()
	end
end
