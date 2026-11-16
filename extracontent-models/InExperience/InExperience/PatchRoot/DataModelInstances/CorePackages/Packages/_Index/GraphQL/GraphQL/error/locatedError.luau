local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local LuauPolyfill = require(parent3.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local instanceof = LuauPolyfill.instanceof

local inspect = require(parent2.jsutils.inspect)
local inspect2 = inspect.inspect

require(parent2.language.ast)

local GraphQLError = require(parent.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	locatedError = function(data, p, p2)
		if not instanceof(data, Error) then
			if typeof(data) == "table" and typeof(data.message) == "string" and data.stack ~= nil then
				data = Error.new(data.message)
			elseif typeof(data) == "table" and typeof(data.error) == "string" then
				data = Error.new("Unexpected error value: " .. inspect2(data.error))
			else
				data = Error.new("Unexpected error value: " .. inspect2(data))
			end
		end

		if Array.isArray(data.path) then
			return data
		end

		return (graphQLError.new(data.message, data.nodes or p, data.source, data.positions, p2, data))
	end
}
