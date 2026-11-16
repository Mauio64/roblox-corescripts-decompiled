local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error

local GraphQL = require(parent.GraphQL)
local isNonNullType = GraphQL.isNonNullType
local Kind = GraphQL.Kind

local isListType = GraphQL.isListType

local inspect = require(script.Parent.inspect)
local inspect2 = inspect.inspect
local function astFromType(ofType)
	if Boolean.toJSBoolean(isNonNullType(ofType)) then
		local v = astFromType(ofType.ofType)

		if v.kind == Kind.NON_NULL_TYPE then
			error(Error.new(("Invalid type node %s. Inner type of non-null type cannot be a non-null type."):format((tostring(inspect2(ofType))))))
		end

		return { kind = Kind.NON_NULL_TYPE, type = v }
	elseif Boolean.toJSBoolean(isListType(ofType)) then
		return { kind = Kind.LIST_TYPE, type = astFromType(ofType.ofType) }
	else
		return {
			kind = Kind.NAMED_TYPE,
			name = { kind = Kind.NAME, value = ofType.name }
		}
	end
end

return { astFromType = astFromType }
