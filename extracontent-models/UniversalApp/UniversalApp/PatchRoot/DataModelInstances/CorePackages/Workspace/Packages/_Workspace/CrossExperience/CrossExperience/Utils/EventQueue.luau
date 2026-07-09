local CrossExperience = script:FindFirstAncestor("CrossExperience")

require(CrossExperience.Types)

local Logger = require(CrossExperience.Logger)
local t1 = {}

t1.__index = t1

local function getFirstKeyInTable(p1) -- line: 40
	if p1 then
		for k, _ in pairs(p1) do
			return k
		end
	end

	return nil
end

function t1.new(b1: boolean) -- line: 51
	-- upvalues: t1 (copy)
	local t2 = {
		queues = {},
		requiresEventsInOrder = b1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.processNextEvent(t3: {[any]: any}, s1: string, t4: {[any]: any}?) -- line: 60
	-- upvalues: Logger (copy)
	local v13 = t3.queues[s1]

	if not v13 then
		Logger:error("EventQueue: queue not found for origin {} abort processing", s1)

		return
	end

	if v13.nextSequenceNumber == nil then
		local events = v13.events
		local v15 = nil

		if events then
			for k, _ in pairs(events) do
				v15 = k

				break
			end
		end

		if v15 ~= nil then
			Logger:info("EventQueue: sequence for {} at {}", s1, v15)
			v13.nextSequenceNumber = v15
		end
	end

	local v18 = v13.events[v13.nextSequenceNumber]

	if v18 then
		Logger:info("EventQueue: processing event {} seq {}", v18.event.NOTIFY, v18.params._seq)

		if not t4 then
			Logger:info("EventQueue: event originally delayed {} seq {} ", v18.event.NOTIFY, v18.params._seq)
		end

		v18.callback(v18.params)
		v13.events[v13.nextSequenceNumber] = nil
		v13.nextSequenceNumber = v13.nextSequenceNumber + 1
		t3:processNextEvent(s1)

		return
	end

	if t4 then
		Logger:info("EventQueue: delaying processing event {} seq {} expecting {}", t4.event.NOTIFY, t4.params._seq, v13.nextSequenceNumber)
	end
end
function t1.reset(p2) -- line: 98
	p2.queues = {}
end
function t1.process(t5: {[any]: any}, p3, p4, p5: ((...any) -> ...any)?) -- line: 102
	-- upvalues: Logger (copy)
	if not p4 then
		Logger:error("EventQueue: invalid event {} params missing", p3.NOTIFY)

		return
	end

	local _origin = p4._origin
	local _seq = p4._seq

	if not _origin or not _seq or not t5.requiresEventsInOrder then
		Logger:info("EventQueue: event {} processing immediately", p3.NOTIFY)

		if p5 then
			p5(p4)
		end

		return
	end

	if not t5.queues[_origin] then
		Logger:info("EventQueue: initiating queue {}", _origin)
		t5.queues[_origin] = {
			nextSequenceNumber = nil,
			events = {}
		}
	end

	Logger:info("EventQueue: new event {} seq {} current seq {}", p3.NOTIFY, _seq, t5.queues[_origin].nextSequenceNumber)

	local t6 = {
		event = p3,
		params = p4,
		callback = p5
	}

	t5.queues[_origin].events[_seq] = t6
	t5:processNextEvent(_origin, t6)
end

return t1
