local CrossExperience = script:FindFirstAncestor("CrossExperience")

require(CrossExperience.Types)

local Logger = require(CrossExperience.Logger)

local EventQueue = {}
EventQueue.__index = EventQueue

local function getFirstKeyInTable(items)
	if items then
		for k, _ in pairs(items) do
			return k
		end
	end

	return nil
end

function EventQueue.new(requiresEventsInOrder: boolean)
	local v = { queues = {}, requiresEventsInOrder = requiresEventsInOrder }

	setmetatable(v, EventQueue)
	return v
end

function EventQueue:processNextEvent(p: string, p2)
	local queue = self.queues[p]

	if not queue then
		Logger:error("EventQueue: queue not found for origin {} abort processing", p)
		return
	end

	if queue.nextSequenceNumber == nil then
		local events = queue.events
		local nextSequenceNumber = nil

		if events then
			for k, _ in pairs(events) do
				nextSequenceNumber = k
				break
			end
		end

		if nextSequenceNumber ~= nil then
			Logger:info("EventQueue: sequence for {} at {}", p, nextSequenceNumber)
			queue.nextSequenceNumber = nextSequenceNumber
		end
	end

	local event = queue.events[queue.nextSequenceNumber]

	if event then
		Logger:info("EventQueue: processing event {} seq {}", event.event.NOTIFY, event.params._seq)

		if not p2 then
			Logger:info("EventQueue: event originally delayed {} seq {} ", event.event.NOTIFY, event.params._seq)
		end

		event.callback(event.params)
		queue.events[queue.nextSequenceNumber] = nil
		queue.nextSequenceNumber += 1
		self:processNextEvent(p)
	elseif p2 then
		Logger:info(
			"EventQueue: delaying processing event {} seq {} expecting {}",
			p2.event.NOTIFY,
			p2.params._seq,
			queue.nextSequenceNumber
		)
	end
end

function EventQueue:reset()
	self.queues = {}
end

function EventQueue:process(event, params, callback)
	if not params then
		Logger:error("EventQueue: invalid event {} params missing", event.NOTIFY)
		return
	end

	local origin = params._origin
	local seq = params._seq

	if origin and seq and self.requiresEventsInOrder then
		if not self.queues[origin] then
			Logger:info("EventQueue: initiating queue {}", origin)
			self.queues[origin] = { nextSequenceNumber = nil, events = {} }
		end

		Logger:info(
			"EventQueue: new event {} seq {} current seq {}",
			event.NOTIFY,
			seq,
			self.queues[origin].nextSequenceNumber
		)

		local v = { event = event, params = params, callback = callback }

		self.queues[origin].events[seq] = v
		self:processNextEvent(origin, v)
	else
		Logger:info("EventQueue: event {} processing immediately", event.NOTIFY)

		if callback then
			callback(params)
		end
	end
end

return EventQueue
