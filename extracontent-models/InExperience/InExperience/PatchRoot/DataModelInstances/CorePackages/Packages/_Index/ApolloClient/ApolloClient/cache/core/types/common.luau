local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Error = require(ParentParentParent.LuauPolyfill).Error

require(ParentParentParent.GraphQL)
require(ParentParent.utilities.graphql.types)

local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function self.new(s1: string, p1, p2, t2: {[any]: any}?) -- line: 62
	-- upvalues: Error (copy), self (copy)
	local v10 = Error.new(s1)

	v10.message = s1
	v10.path = p1
	v10.query = p2
	v10.variables = t2

	return (setmetatable(v10, self))
end

t1.MissingFieldError = self

return t1
