local module = require("@luauforge/bundled/hWz")
local module2 = require("@luauforge/bundled/hWA")

local class = {}
class.__index = class

function class.new(data)
	assert(data.generateId, "RoRum requires config.generateId")
	assert(data.generateTraceId, "RoRum requires config.generateTraceId")
	assert(data.generateSpanId, "RoRum requires config.generateSpanId")

	local v5 = module2.new(data.maxLatestSpans or 100)

	return (setmetatable({
		config = data,
		generateId = data.generateId,
		generateTraceId = data.generateTraceId,
		generateSpanId = data.generateSpanId,
		latestSpans = v5
	}, class))
end

function class:startSpan(p2)
	local clone = table.clone(p2)
	clone.rorum = self
	return module.new(clone)
end

function class:recordCompletedSpan(p3)
	self.latestSpans:push(p3)
end

function class:getLatestSpans(p3)
	return self.latestSpans:toArray(p3)
end

return class
