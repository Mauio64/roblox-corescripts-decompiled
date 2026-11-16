local EventPropagationEvent = {}
EventPropagationEvent.__index = EventPropagationEvent

function EventPropagationEvent.new(targetInstance, currentInstance, eventName: string, phase: string, flag: boolean?, eventData)
	local v = {
		cancelled = false,
		phase = phase,
		currentInstance = currentInstance,
		targetInstance = targetInstance,
		eventName = eventName,
		synthetic = flag or false,
		eventData = 0
	}

	if type(eventData) == "table" and not table.isfrozen(eventData) then
		eventData = table.freeze(eventData)
	end

	v.eventData = eventData

	setmetatable(v, EventPropagationEvent)
	return v
end

function EventPropagationEvent:cancel()
	self.cancelled = true
end

return EventPropagationEvent
