local ValidateOperation = {}
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local invariant = require(parent.jsutils.invariant)
local invariantError = invariant.InvariantError

require(script.Parent.Parent.core.types)

function ValidateOperation.validateOperation(p)
	local v = { "query", "operationName", "variables", "extensions", "context" }

	for _, v2 in ipairs(Object.keys(p)) do
		if Array.indexOf(v, v2) < 0 then
			error(invariantError.new(("illegal argument: %s"):format(v2)))
		end
	end

	return p
end
return ValidateOperation
