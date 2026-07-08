local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local LuauPolyfill = require(scriptParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local instanceof = LuauPolyfill.instanceof
local inspect = require(scriptParentParent.jsutils.inspect).inspect

require(scriptParentParent.language.ast)

local GraphQLError = require(scriptParent.GraphQLError).GraphQLError

return {
	locatedError = function(p1, p2, p3) -- line: 30
		-- upvalues: instanceof (copy), Error (copy), inspect (copy), Array (copy), GraphQLError (copy)
		local v13 = if not instanceof(p1, Error) then if typeof(p1) ~= "table" or (typeof(p1.message) ~= "string" or p1.stack == nil) then if typeof(p1) ~= "table" or typeof(p1.error) ~= "string" then Error.new("Unexpected error value: " .. inspect(p1)) else Error.new("Unexpected error value: " .. inspect(p1.error)) else Error.new(p1.message) else p1

		if Array.isArray(v13.path) then
			return v13
		end

		return (GraphQLError.new(v13.message, v13.nodes or p2, v13.source, v13.positions, p3, v13))
	end
}
