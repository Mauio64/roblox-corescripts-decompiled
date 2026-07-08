local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local InvariantError = require(ParentParent.jsutils.invariant).InvariantError

require(script.Parent.Parent.core.types)

function t1.validateOperation(p1) -- line: 19
	-- upvalues: Object (copy), Array (copy), InvariantError (copy)
	for _, v in ipairs(Object.keys(p1)) do
		if Array.indexOf({
			"query",
			"operationName",
			"variables",
			"extensions",
			"context"
		}, v) < 0 then
			error(InvariantError.new(("illegal argument: %s"):format(v)))
		end
	end

	return p1
end

return t1
