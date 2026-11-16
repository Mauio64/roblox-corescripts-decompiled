local parent = script.Parent.Parent
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local getAncestors = FocusNavigationUtils.getAncestors
local mockableWarn = FocusNavigationUtils.mockableWarn

local eventPropagationEvent = require(script.Parent.eventPropagationEvent)

local __DEBUG_EVENT_PROPAGATION__ = _G.__DEBUG_EVENT_PROPAGATION__

local function describeFunction(callback)
	return table.concat(table.pack(debug.info(callback, "sln")), " ")
end

local function getEventsFromRegistry(p, p2)
	return p[p2]
end

local function getEventPhasesFromRegistry(p, p2, p3: string)
	local v = p[p2]

	if v then
		return v[p3]
	end

	return nil
end

local function getEventHandler(p, p2, p3: string, p4)
	local v = p[p2]
	local v2

	if v then
		v2 = v[p3]
	end

	if v2 == nil then
		return nil
	end

	return v2[p4]
end

local EventPropagationService = {}
EventPropagationService.__index = EventPropagationService

function EventPropagationService:registerEventHandler(p, p2: string, callback, value)
	if __DEBUG_EVENT_PROPAGATION__ then
		print("+++ register handler", p2, tostring(p), value or "Bubble")
	end

	local v = value or "Bubble"
	self.eventHandlerRegistry[p] = self.eventHandlerRegistry[p] or {}
	self.eventHandlerRegistry[p][p2] = self.eventHandlerRegistry[p][p2] or {}
	local v2 = _G.__DEV__ and self.eventHandlerRegistry[p][p2][v]

	if v2 then
		mockableWarn(string.format(
			"New handler bound to the %s phase of '%s' will override an existing handler:\n\tprevious handler: %s\n\t     new handler: %s",
			v,
			p2,
			table.concat(table.pack(debug.info(callback, "sln")), " "),
			describeFunction(v2)
		))
	end

	self.eventHandlerRegistry[p][p2][v] = callback
end

function EventPropagationService:registerEventHandlers(p, items)
	if not self.eventHandlerRegistry[p] then
		self.eventHandlerRegistry[p] = {}
	end

	for k, item in items do
		self:registerEventHandler(p, k, item.handler, item.phase)
	end
end

function EventPropagationService:deregisterEventHandlers(p, items)
	if not self.eventHandlerRegistry[p] then
		return
	end

	for k, item in items do
		self:deregisterEventHandler(p, k, item.handler, item.phase)
	end
end

function EventPropagationService:deregisterEventHandler(p, p2: string, callback, value)
	if __DEBUG_EVENT_PROPAGATION__ then
		print("--- deregister handler", p2, tostring(p), value or "Bubble")
	end

	local v = value or "Bubble"
	local eventHandler = self.eventHandlerRegistry[p]
	local v2

	if eventHandler then
		v2 = eventHandler[p2]
	end

	if v2 and v2[v] then
		if _G.__DEV__ then
			local v3 = v2[v]

			if v3 ~= callback then
				local v4

				if type(callback) == "function" then
					v4 = table.concat(table.pack(debug.info(callback, "sln")), " ")
				else
					v4 = tostring(callback)
				end

				local v5

				if type(v3) == "function" then
					v5 = table.concat(table.pack(debug.info(v3, "sln")), " ")
				else
					v5 = tostring(v3)
				end

				mockableWarn(string.format(
					"Deregistering non-matching event handler bound to the %s phase of '%s':\n\tprevious handler: %s\n\t     new handler: %s",
					v,
					p2,
					v4,
					v5
				))
			end
		end

		v2[v] = nil
	elseif _G.__DEV__ then
		mockableWarn(string.format("Cannot deregister unregistered event handler bound to the %s phase of '%s'", v, p2))
	end
end

function EventPropagationService.getRegisteredEventHandlers(p, p2)
	local eventHandler = p.eventHandlerRegistry[p2]

	if not eventHandler then
		return nil
	end

	local result = {}

	for k, v in eventHandler do
		result[k] = next(v) ~= nil
	end

	return result
end

function EventPropagationService.propagateEvent(p, p2, p3: string, p4, options)
	local v = options or {}
	local synthetic = v.synthetic or false

	local function runEventHandler(p5, p6)
		local v2 = p3
		local eventHandler = p.eventHandlerRegistry[p5]
		local v3

		if eventHandler then
			v3 = eventHandler[v2]
		end

		local v4

		if v3 ~= nil then
			v4 = v3[p6]
		end

		if not v4 then
			return false
		end

		local v5 = eventPropagationEvent.new(p2, p5, p3, p6, synthetic, p4)
		v4(v5)

		return v5.cancelled
	end

	local v2 = v.silent and { p2 } or getAncestors(p2)

	if __DEBUG_EVENT_PROPAGATION__ then
		print(">>> capture event", p3, "for", (tostring(p2)))
	end

	for i = #v2, 1, -1 do
		local v3 = v2[i]
		local eventHandler = p.eventHandlerRegistry[v3]
		local v4

		if eventHandler then
			v4 = eventHandler[p3]
		end

		local capture

		if v4 ~= nil then
			capture = v4.Capture
		end

		local v5

		if capture then
			local v6 = eventPropagationEvent.new(p2, v3, p3, "Capture", synthetic, p4)
			capture(v6)

			v5 = v6.cancelled
		else
			v5 = false
		end

		if v5 then
			return
		end
	end

	local eventHandler = p.eventHandlerRegistry[p2]
	local v3

	if eventHandler then
		v3 = eventHandler[p3]
	end

	local target

	if v3 ~= nil then
		target = v3.Target
	end

	local v4

	if target then
		local v5 = eventPropagationEvent.new(p2, p2, p3, "Target", synthetic, p4)
		target(v5)

		v4 = v5.cancelled
	else
		v4 = false
	end

	if v4 then
		return
	end

	if __DEBUG_EVENT_PROPAGATION__ then
		print("<<< bubble event", p3, "from", (tostring(p2)))
	end

	for i = 1, #v2 do
		local v5 = v2[i]
		local eventHandler2 = p.eventHandlerRegistry[v5]
		local v6

		if eventHandler2 then
			v6 = eventHandler2[p3]
		end

		local bubble

		if v6 ~= nil then
			bubble = v6.Bubble
		end

		local v7

		if bubble then
			local v8 = eventPropagationEvent.new(p2, v5, p3, "Bubble", synthetic, p4)
			bubble(v8)

			v7 = v8.cancelled
		else
			v7 = false
		end

		if v7 then
			break
		end
	end
end

function EventPropagationService.new()
	local v = {
		eventHandlerRegistry = setmetatable({}, { __mode = "k" })
	}

	setmetatable(v, EventPropagationService)
	return v
end

return EventPropagationService
