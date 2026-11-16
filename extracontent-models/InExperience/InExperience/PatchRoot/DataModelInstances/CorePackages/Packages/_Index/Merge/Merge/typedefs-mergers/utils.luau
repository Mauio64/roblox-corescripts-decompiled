local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local instanceof = LuauPolyfill.instanceof

local GraphQL = require(parent.GraphQL)

local Source = GraphQL.Source
local Kind = GraphQL.Kind
local Utils = {}

function Utils.isStringTypes(value): boolean
	return typeof(value) == "string"
end

function Utils.isSourceTypes(p)
	return instanceof(p, Source)
end

function Utils.extractType(p)
	while p.kind == Kind.LIST_TYPE or p.kind == "NonNullType" do
		p = p.type
	end

	return p
end

function Utils.isWrappingTypeNode(p): boolean
	return p.kind ~= Kind.NAMED_TYPE
end

local function isListTypeNode(p): boolean -- 1 equivalent call inferred from this helper
	return p.kind == Kind.LIST_TYPE
end

Utils.isListTypeNode = isListTypeNode
local function isNonNullTypeNode(p): boolean -- 1 equivalent call inferred from this helper
	return p.kind == Kind.NON_NULL_TYPE
end

Utils.isNonNullTypeNode = isNonNullTypeNode
local function printTypeNode(kind)
	if Boolean.toJSBoolean(isListTypeNode(kind)) then -- inferred equivalent call
		return ("[%s]"):format(printTypeNode(kind.type))
	end

	if Boolean.toJSBoolean(isNonNullTypeNode(kind)) then -- inferred equivalent call
		return ("%s!"):format(printTypeNode(kind.type))
	end

	return kind.name.value
end

Utils.printTypeNode = printTypeNode
local compareVal = { A_SMALLER_THAN_B = -1, A_EQUALS_B = 0, A_GREATER_THAN_B = 1 }

Utils.CompareVal = compareVal

function Utils.defaultStringComparator(p: string?, p2: string?)
	if p == nil and p2 == nil then
		return compareVal.A_EQUALS_B
	end

	if p == nil then
		return compareVal.A_SMALLER_THAN_B
	end

	if p2 == nil then
		return compareVal.A_GREATER_THAN_B
	end

	if p < p2 then
		return compareVal.A_SMALLER_THAN_B
	end

	if p2 < p then
		return compareVal.A_GREATER_THAN_B
	end

	return compareVal.A_EQUALS_B
end
return Utils
