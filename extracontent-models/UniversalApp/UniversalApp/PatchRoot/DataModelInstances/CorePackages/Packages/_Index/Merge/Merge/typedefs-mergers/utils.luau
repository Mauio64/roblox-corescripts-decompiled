local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local instanceof = LuauPolyfill.instanceof
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLSource = GraphQL.Source
local Kind = GraphQL.Kind

function t1.isStringTypes(p1) -- line: 20
	return typeof(p1) == "string"
end
function t1.isSourceTypes(p2) -- line: 26
	-- upvalues: instanceof (copy), GraphQLSource (copy)
	return instanceof(p2, GraphQLSource)
end
function t1.extractType(p3) -- line: 34
	-- upvalues: Kind (copy)
	while p3.kind == Kind.LIST_TYPE or p3.kind == "NonNullType" do
		p3 = p3.type
	end

	return p3
end
function t1.isWrappingTypeNode(p4) -- line: 47
	-- upvalues: Kind (copy)
	return p4.kind ~= Kind.NAMED_TYPE
end
function t1.isListTypeNode(p5) -- line: 56
	-- upvalues: Kind (copy)
	return p5.kind == Kind.LIST_TYPE
end
function t1.isNonNullTypeNode(p6) -- line: 65
	-- upvalues: Kind (copy)
	return p6.kind == Kind.NON_NULL_TYPE
end

local function printTypeNode(p7) -- line: 74
	-- upvalues: Boolean (copy), Kind (copy), printTypeNode (copy)
	if Boolean.toJSBoolean(p7.kind == Kind.LIST_TYPE) then
		return ("[%s]"):format(printTypeNode(p7.type))
	end

	if Boolean.toJSBoolean(p7.kind == Kind.NON_NULL_TYPE) then
		return ("%s!"):format(printTypeNode(p7.type))
	end

	return p7.name.value
end

t1.printTypeNode = printTypeNode

local t2 = {
	A_SMALLER_THAN_B = -1,
	A_EQUALS_B = 0,
	A_GREATER_THAN_B = 1
}

t1.CompareVal = t2

function t1.defaultStringComparator(s1: string?, s2: string?) -- line: 100
	-- upvalues: t2 (copy)
	if s1 == nil and s2 == nil then
		return t2.A_EQUALS_B
	end

	if s1 == nil then
		return t2.A_SMALLER_THAN_B
	end

	if s2 == nil then
		return t2.A_GREATER_THAN_B
	end

	if s1 < s2 then
		return t2.A_SMALLER_THAN_B
	end

	if s2 < s1 then
		return t2.A_GREATER_THAN_B
	end

	return t2.A_EQUALS_B
end

return t1
