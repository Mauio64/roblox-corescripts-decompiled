local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean

require(script.Parent.Parent.core.types)

local getOperationName = require(script.Parent.Parent.Parent.utilities).getOperationName

function t1.transformOperation(p1) -- line: 20
	-- upvalues: Boolean (copy), getOperationName (copy)
	local t2 = {
		variables = Boolean.toJSBoolean(p1.variables) and p1.variables or {},
		extensions = Boolean.toJSBoolean(p1.extensions) and p1.extensions or {},
		operationName = p1.operationName,
		query = p1.query
	}

	if not Boolean.toJSBoolean(t2.operationName) then
		if typeof(t2.query) ~= "string" then
			t2.operationName = Boolean.toJSBoolean(getOperationName(t2.query)) and getOperationName(t2.query) or nil

			return t2
		end

		t2.operationName = ""
	end

	return t2
end

return t1
