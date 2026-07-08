local fireEventStream = require(script.Parent.Parent.FireEvent.fireEventStream)
local fireDiagCounter = require(script.Parent.Parent.FireEvent.fireDiagCounter)
local DiagEventList = require(script.Parent.DiagEventList)
local EventStreamEventList = require(script.Parent.EventStreamEventList)

require(script.Parent.Parent.FireEvent.Types)

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: fireEventStream (copy), EventStreamEventList (copy), fireDiagCounter (copy), DiagEventList (copy)
	local v6 = fireEventStream({
		eventStreamImpl = t1.analytics.EventStream,
		eventList = EventStreamEventList,
		loggerImpl = t1.loggerImpl,
		infoForAllEvents = t1.infoForAllEvents
	})
	local v7 = fireDiagCounter({
		diagImpl = t1.analytics.Diag,
		eventList = DiagEventList,
		loggerImpl = t1.loggerImpl
	})

	return function(p1, p2) -- line: 21
		-- upvalues: EventStreamEventList (copy), v6 (copy), DiagEventList (copy), v7 (copy)
		if EventStreamEventList[p1] then
			v6(p1, p2)
		end

		if DiagEventList[p1] then
			v7(p1)
		end

		return DateTime.now()
	end
end
