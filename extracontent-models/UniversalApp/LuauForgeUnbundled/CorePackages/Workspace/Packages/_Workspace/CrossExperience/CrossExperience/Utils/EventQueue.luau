require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Logger")

local class = {}
class.__index = class

local function getFirstKeyInTable(items)
	if items then
		for k, item in pairs(items) do
			return k
		end
	end

	return nil
end

function class.new(p2)
	local v5 = { queues = {}, requiresEventsInOrder = p2 }

	setmetatable(v5, class)
	return v5
end

function class:processNextEvent(p2, p3)
	local queue = self.queues[p2]

	if not queue then
		Logger:error("EventQueue: queue not found for origin {} abort processing", p2)
		return
	end

	if queue.nextSequenceNumber == nil then
		local events = queue.events
		local v5 = nil

		if events then
			for k, event in pairs(events) do
				v5 = k
				break
			end
		end

		if v5 ~= nil then
			Logger:info("EventQueue: sequence for {} at {}", p2, v5)
			queue.nextSequenceNumber = v5
		end
	end

	local event = queue.events[queue.nextSequenceNumber]

	if event then
		Logger:info("EventQueue: processing event {} seq {}", event.event.NOTIFY, event.params._seq)

		if not p3 then
			Logger:info(
				"EventQueue: event originally delayed {} seq {} ",
				event.event.NOTIFY,
				event.params._seq
			)
		end

		event.callback(event.params)
		queue.events[queue.nextSequenceNumber] = nil
		queue.nextSequenceNumber += 1
		self:processNextEvent(p2)
	elseif p3 then
		Logger:info(
			"EventQueue: delaying processing event {} seq {} expecting {}",
			p3.event.NOTIFY,
			p3.params._seq,
			queue.nextSequenceNumber
		)
	end
end

function class:reset()
	self.queues = {}
end

function class:process(p2, p3, callback)
	if not p3 then
		Logger:error("EventQueue: invalid event {} params missing", p2.NOTIFY)
		return
	end

	local origin = p3._origin
	local seq = p3._seq

	if origin and seq and self.requiresEventsInOrder then
		if not self.queues[origin] then
			Logger:info("EventQueue: initiating queue {}", origin)
			self.queues[origin] = { nextSequenceNumber = nil, events = {} }
		end

		Logger:info(
			"EventQueue: new event {} seq {} current seq {}",
			p2.NOTIFY,
			seq,
			self.queues[origin].nextSequenceNumber
		)

		local v5 = { event = p2, params = p3, callback = callback }

		self.queues[origin].events[seq] = v5
		self:processNextEvent(origin, v5)
	else
		Logger:info("EventQueue: event {} processing immediately", p2.NOTIFY)

		if callback then
			callback(p3)
		end
	end
end

return class
