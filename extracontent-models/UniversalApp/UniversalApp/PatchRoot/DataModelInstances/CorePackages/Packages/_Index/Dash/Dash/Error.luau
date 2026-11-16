local parent = script.Parent
require(parent.Types)
local class = require(parent.class)
local format = require(parent.format)
local join = require(parent.join)

local v = class("Error", function(name: string, value: string, options)
	return {
		name = name,
		message = value or "An error occurred",
		tags = options or {}
	}
end)

function v.toString(data)
	return format("{}: {}\n{}", data.name, format(data.message, data.tags), data.stack)
end

function v:joinTags(options)
	return v.new(self.name, self.message, join(self.tags, options or {}))
end

function v:throw(p)
	local joinTags = self:joinTags(p)
	joinTags.stack = debug.traceback()
	error(joinTags)
end

return v
