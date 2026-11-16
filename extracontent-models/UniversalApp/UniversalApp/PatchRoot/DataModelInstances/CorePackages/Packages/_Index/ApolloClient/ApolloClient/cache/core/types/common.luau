local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Error = LuauPolyfill.Error

require(parent2.GraphQL)

require(parent.utilities.graphql.types)

local object = setmetatable({}, { __index = Error })
object.__index = object

function object.new(message: string, path, query, variables)
	local v = Error.new(message)
	v.message = message
	v.path = path
	v.query = query
	v.variables = variables

	return (setmetatable(v, object))
end

return { MissingFieldError = object }
