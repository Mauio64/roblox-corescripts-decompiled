local parent = script.Parent.Parent

local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local devAssert = require(parent.jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local instanceOf = require(parent.jsutils.instanceOf)

local class = {}
class.__index = class

function class.new(body: string, value: string?, p)
	devAssert2(typeof(body) == "string", "Body must be a string. Received: " .. inspect2(body) .. ".")
	local v = {
		["body"] = body,
		name = value or "GraphQL request",
		locationOffset = p or { line = 1, column = 1 }
	}

	devAssert2(v.locationOffset.line > 0, "line in locationOffset is 1-indexed and must be positive.")

	devAssert2(v.locationOffset.column > 0, "column in locationOffset is 1-indexed and must be positive.")

	return (setmetatable(v, class))
end

function class.__tostring(_): string
	return "{table Source}"
end

function isSource(p)
	return instanceOf(p, class)
end

return { Source = class, isSource = isSource }
