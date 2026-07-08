local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Error = LuauPolyfill.Error
local t1 = {}
local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function self.new(p1, s1: string?) -- line: 47
	-- upvalues: Error (copy), self (ref)
	local v10 = s1 == nil and "" or s1
	local v11 = setmetatable(Error.new(v10), self)

	v11.errors = p1
	v11.name = "AggregateError"
	Error.captureStackTrace(v11, self.new)

	return v11
end

t1.AggregateError = setmetatable(self, {
	__call = function(_, p3, s2: string?) -- line: 68
		-- upvalues: self (ref)
		return self.new(p3, s2)
	end
})

function t1.isAggregateError(p4) -- line: 86
	-- upvalues: Array (copy), Object (copy)
	return Array.indexOf(Object.keys(p4), "errors") ~= -1 and Array.isArray(p4.errors)
end

return t1
