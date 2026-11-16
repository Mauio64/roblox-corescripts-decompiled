local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local Error = LuauPolyfill.Error

local object = setmetatable({}, { __index = Error })

object.__index = object
function object.new(errors, p: string?)
	local v = p == nil and "" or p

	local self = setmetatable(Error.new(v), object)

	self.errors = errors

	self.name = "AggregateError"

	Error.captureStackTrace(self, object.new)

	return self
end

return {
	["AggregateError"] = setmetatable(object, {
		__call = function(_, p, p2: string?)
			return object.new(p, p2)
		end
	}),
	isAggregateError = function(p)
		return Array.indexOf(Object.keys(p), "errors") ~= -1 and Array.isArray(p.errors)
	end
}
