local TransformOperation = {}
local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

require(script.Parent.Parent.core.types)

local utilities = require(script.Parent.Parent.Parent.utilities)
local getOperationName = utilities.getOperationName

function TransformOperation.transformOperation(data)
	local v = {
		variables = Boolean.toJSBoolean(data.variables) and data.variables or {},
		extensions = Boolean.toJSBoolean(data.extensions) and data.extensions or {},
		operationName = data.operationName,
		query = data.query
	}

	if Boolean.toJSBoolean(v.operationName) then
		return v
	end

	if typeof(v.query) == "string" then
		v.operationName = ""

		return v
	end

	local operationName

	if Boolean.toJSBoolean(getOperationName(v.query)) then
		operationName = getOperationName(v.query) or nil
	end

	v.operationName = operationName
	return v
end
return TransformOperation
