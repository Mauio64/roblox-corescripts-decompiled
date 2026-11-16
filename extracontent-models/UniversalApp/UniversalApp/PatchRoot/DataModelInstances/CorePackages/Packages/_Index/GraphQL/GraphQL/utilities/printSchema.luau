local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Boolean = LuauPolyfill.Boolean

local inspect = require(script.Parent.Parent.jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(script.Parent.Parent.jsutils.invariant)
local invariant2 = invariant.invariant

local printer = require(script.Parent.Parent.language.printer)
local Print = printer.print
local blockString = require(script.Parent.Parent.language.blockString)
local printBlockString = blockString.printBlockString

local introspection = require(script.Parent.Parent.type.introspection)
local isIntrospectionType = introspection.isIntrospectionType
local scalars = require(script.Parent.Parent.type.scalars)
local graphQLString = scalars.GraphQLString
local scalars2 = require(script.Parent.Parent.type.scalars)
local isSpecifiedScalarType = scalars2.isSpecifiedScalarType
local directives = require(script.Parent.Parent.type.directives)

local DEFAULT_DEPRECATION_REASON = directives.DEFAULT_DEPRECATION_REASON
local isSpecifiedDirective = directives.isSpecifiedDirective
local definition = require(script.Parent.Parent.type.definition)
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType

require(script.Parent.Parent.type.schema)

require(script.Parent.Parent.language.ast)

local astFromValue = require(script.Parent.astFromValue)
local astFromValue2 = astFromValue.astFromValue
local astFromValue3 = require(script.Parent.astFromValue)
local null = astFromValue3.NULL
local isNillish = require(script.Parent.Parent.luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish

local printScalar
local printDescription
local printFilteredSchema
local isDefinedType
local printSchemaDefinition
local printDirective
local printType
local isSchemaOfCommonNames
local printObject
local printArgs
local printInputValue
local printDeprecated
local printBlock
local printInterface
local printUnion
local printEnum
local printInputObject
local printSpecifiedByUrl
local printFields
local function printSchema(p)
	return printFilteredSchema(p, function(p2): boolean
		return not isSpecifiedDirective(p2)
	end, isDefinedType)
end

local function printIntrospectionSchema(p)
	return printFilteredSchema(p, isSpecifiedDirective, isIntrospectionType)
end

isDefinedType = function(p): boolean
	return not (isSpecifiedScalarType(p) or isIntrospectionType(p))
end

printFilteredSchema = function(object, callback, callback2)
	local filtered = Array.filter(object:getDirectives(), callback)

	local filtered2 = Array.filter(object:getTypeMap():values(), callback2)

	local joined = Array.concat({ printSchemaDefinition(object) }, Array.map(filtered, function(p)
		return printDirective(p)
	end), Array.map(filtered2, function(p)
		return printType(p)
	end))

	local filtered3 = Array.filter(joined, function(p)
		return Boolean.toJSBoolean(p)
	end)

	return Array.join(filtered3, "\n\n") .. "\n"
end

printSchemaDefinition = function(object)
	if isNillish2(object.description) and isSchemaOfCommonNames(object) then
		return
	end

	local v = {}
	local queryType = object:getQueryType()

	if isNotNillish(queryType) then
		table.insert(v, ("  query: %s"):format(queryType.name))
	end

	local mutationType = object:getMutationType()

	if isNotNillish(mutationType) then
		table.insert(v, ("  mutation: %s"):format(mutationType.name))
	end

	local subscriptionType = object:getSubscriptionType()

	if isNotNillish(subscriptionType) then
		table.insert(v, ("  subscription: %s"):format(subscriptionType.name))
	end

	return printDescription(object) .. ("schema {\n%s\n}"):format(Array.join(v, "\n"))
end

isSchemaOfCommonNames = function(object): boolean
	local queryType = object:getQueryType()

	if isNotNillish(queryType) and queryType.name ~= "Query" then
		return false
	end

	local mutationType = object:getMutationType()

	if isNotNillish(mutationType) and mutationType.name ~= "Mutation" then
		return false
	end

	local subscriptionType = object:getSubscriptionType()

	return not isNotNillish(subscriptionType) or subscriptionType.name == "Subscription"
end

printType = function(p)
	if isScalarType(p) then
		return printScalar(p)
	end

	if isObjectType(p) then
		return printObject(p)
	end

	if isInterfaceType(p) then
		return printInterface(p)
	end

	if isUnionType(p) then
		return printUnion(p)
	end

	if isEnumType(p) then
		return printEnum(p)
	end

	if isInputObjectType(p) then
		return printInputObject(p)
	end

	invariant2(false, "Unexpected type: " .. inspect2(p))

	return ""
end

printScalar = function(p)
	return printDescription(p) .. ("scalar %s"):format(p.name) .. printSpecifiedByUrl(p)
end

local function printImplementedInterfaces(p)
	local interfaces = p.getInterfaces(p)

	if #interfaces > 0 then
		return " implements " .. Array.join(Array.map(interfaces, function(p2)
			return p2.name
		end), " & ")
	end

	return ""
end

printObject = function(p)
	return printDescription(p) .. ("type %s"):format(p.name) .. printImplementedInterfaces(p) .. printFields(p)
end

printInterface = function(p)
	return printDescription(p) .. ("interface %s"):format(p.name) .. printImplementedInterfaces(p) .. printFields(p)
end

printUnion = function(object)
	local types = object:getTypes()
	local v = not (#types > 0) and "" or " = " .. Array.join(types, " | ")

	return printDescription(object) .. "union " .. object.name .. v
end

printEnum = function(object)
	local mapped = Array.map(object:getValues(), function(p, p2)
		return printDescription(p, "  ", p2 == 1) .. "  " .. p.name .. printDeprecated(p.deprecationReason)
	end)

	return printDescription(object) .. ("enum %s"):format(object.name) .. printBlock(mapped)
end

printInputObject = function(object)
	local mapped = Array.map(object:getFields():values(), function(p, p2)
		return printDescription(p, "  ", p2 == 1) .. "  " .. printInputValue(p)
	end)

	return printDescription(object) .. ("input %s"):format(object.name) .. printBlock(mapped)
end

printFields = function(p)
	local mapped = Array.map(p.getFields(p):values(), function(data, p2)
		return printDescription(data, "  ", p2 == 1) .. "  " .. data.name .. printArgs(data.args, "  ") .. ": " .. tostring(data.type) .. printDeprecated(data.deprecationReason)
	end)

	return printBlock(mapped)
end

printBlock = function(mapped)
	if #mapped == 0 then
		return ""
	end

	return " {\n" .. Array.join(mapped, "\n") .. "\n}"
end

printArgs = function(args, p: string?)
	local v = p == nil and "" or p

	if #args == 0 then
		return ""
	end

	if Array.every(args, function(p2)
		return isNillish2(p2.description)
	end) then
		return "(" .. Array.join(Array.map(args, printInputValue), ", ") .. ")"
	end

	return "(\n" .. Array.join(Array.map(args, function(p2, p3)
		return printDescription(p2, "  " .. v, p3 == 1) .. "  " .. v .. printInputValue(p2)
	end), "\n") .. "\n" .. v .. ")"
end

printInputValue = function(data)
	local v = astFromValue2(data.defaultValue, data.type)
	local v2 = data.name .. ": " .. tostring(data.type)

	if isNotNillish(v) then
		v2 ..= (" = %s"):format(Print(v))
	end

	return v2 .. printDeprecated(data.deprecationReason)
end

printDirective = function(data)
	return printDescription(data) .. "directive @" .. data.name .. printArgs(data.args) .. (data.isRepeatable and " repeatable" or "") .. " on " .. Array.join(data.locations, " | ")
end

printDeprecated = function(deprecationReason: string?)
	if isNillish2(deprecationReason) then
		return ""
	end

	local v = astFromValue2(deprecationReason, graphQLString)

	if v and deprecationReason ~= DEFAULT_DEPRECATION_REASON then
		return " @deprecated(reason: " .. Print(v) .. ")"
	end

	return " @deprecated"
end

printSpecifiedByUrl = function(p)
	if isNillish2(p.specifiedByUrl) then
		return ""
	end

	local v = astFromValue2(p.specifiedByUrl, graphQLString)

	invariant2(v, "Unexpected null value returned from `astFromValue` for specifiedByUrl")

	return " @specifiedBy(url: " .. Print(v) .. ")"
end

printDescription = function(p, p2: string?, flag: boolean?)
	local v = p2 == nil and "" or p2

	local v2 = flag == nil or flag

	local description = p.description

	if isNillish2(description) then
		return ""
	end

	local v3 = printBlockString(description, "", string.len(description) > 70)
	local v4

	if Boolean.toJSBoolean(v) and not v2 then
		v4 = "\n" .. v
	else
		v4 = v
	end

	local v5, _ = string.gsub(v3, "\n", "\n" .. v)
	return v4 .. v5 .. "\n"
end

return {
	printSchema = printSchema,
	printIntrospectionSchema = printIntrospectionSchema,
	printType = printType,
	NULL = null
}
