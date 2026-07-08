local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local isNonNullType = GraphQL.isNonNullType
local Kind = GraphQL.Kind
local isListType = GraphQL.isListType
local inspect = require(script.Parent.inspect).inspect

local function astFromType(p1) -- line: 25
	-- upvalues: Boolean (copy), isNonNullType (copy), astFromType (copy), Kind (copy), Error (copy), inspect (copy), isListType (copy)
	if Boolean.toJSBoolean(isNonNullType(p1)) then
		local v13 = astFromType(p1.ofType)

		if v13.kind == Kind.NON_NULL_TYPE then
			error(Error.new(("Invalid type node %s. Inner type of non-null type cannot be a non-null type."):format((tostring(inspect(p1))))))
		end

		return {
			kind = Kind.NON_NULL_TYPE,
			type = v13
		}
	end

	if Boolean.toJSBoolean(isListType(p1)) then
		return {
			kind = Kind.LIST_TYPE,
			type = astFromType(p1.ofType)
		}
	end

	return {
		kind = Kind.NAMED_TYPE,
		name = {
			kind = Kind.NAME,
			value = p1.name
		}
	}
end

t1.astFromType = astFromType

return t1
