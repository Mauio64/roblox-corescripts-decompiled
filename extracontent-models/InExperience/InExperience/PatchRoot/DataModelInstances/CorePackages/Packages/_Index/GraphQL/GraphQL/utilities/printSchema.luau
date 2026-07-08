local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local inspect = require(script.Parent.Parent.jsutils.inspect).inspect
local invariant = require(script.Parent.Parent.jsutils.invariant).invariant
local print = require(script.Parent.Parent.language.printer).print
local printBlockString = require(script.Parent.Parent.language.blockString).printBlockString
local isIntrospectionType = require(script.Parent.Parent.type.introspection).isIntrospectionType
local GraphQLString = require(script.Parent.Parent.type.scalars).GraphQLString
local isSpecifiedScalarType = require(script.Parent.Parent.type.scalars).isSpecifiedScalarType
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

local astFromValue = require(script.Parent.astFromValue).astFromValue
local NULL = require(script.Parent.astFromValue).NULL
local isNillish = require(script.Parent.Parent.luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish
local printScalar = nil
local printDescription = nil
local printFilteredSchema = nil
local isDefinedType = nil
local printSchemaDefinition = nil
local printDirective = nil
local printType = nil
local isSchemaOfCommonNames = nil
local printObject = nil
local printArgs = nil
local printInputValue = nil
local printDeprecated = nil
local printBlock = nil
local printInterface = nil
local printUnion = nil
local printEnum = nil
local printInputObject = nil
local printSpecifiedByUrl = nil
local printFields = nil

function isDefinedType(p1) -- line: 86
	-- upvalues: isSpecifiedScalarType (copy), isIntrospectionType (copy)
	return not isSpecifiedScalarType(p1) and not isIntrospectionType(p1)
end
function printFilteredSchema(p2, p3: ((...any) -> ...any), p4: ((...any) -> ...any)) -- line: 90
	-- upvalues: Array (copy), printSchemaDefinition (ref), printDirective (ref), printType (ref), Boolean (copy)
	local v53 = Array.filter(p2:getDirectives(), p3)
	local v54 = Array.filter(p2:getTypeMap():values(), p4)
	local v55 = Array.concat({ printSchemaDefinition(p2) }, Array.map(v53, function(p5) -- line: 103
		-- upvalues: printDirective (ref)
		return printDirective(p5)
	end), Array.map(v54, function(p6) -- line: 106
		-- upvalues: printType (ref)
		return printType(p6)
	end))
	local v56 = Array.filter(v55, function(p7) -- line: 111
		-- upvalues: Boolean (copy)
		return Boolean.toJSBoolean(p7)
	end)

	return Array.join(v56, "\n\n") .. "\n"
end
function printSchemaDefinition(p8) -- line: 118
	-- upvalues: isNillish2 (copy), isSchemaOfCommonNames (ref), isNotNillish (copy), printDescription (ref), Array (copy)
	if isNillish2(p8.description) and isSchemaOfCommonNames(p8) then
		return
	end

	local t1 = {}
	local v59 = p8:getQueryType()

	if isNotNillish(v59) then
		table.insert(t1, ("  query: %s"):format(v59.name))
	end

	local v60 = p8:getMutationType()

	if isNotNillish(v60) then
		table.insert(t1, ("  mutation: %s"):format(v60.name))
	end

	local v61 = p8:getSubscriptionType()

	if isNotNillish(v61) then
		table.insert(t1, ("  subscription: %s"):format(v61.name))
	end

	return printDescription(p8) .. ("schema {\n%s\n}"):format(Array.join(t1, "\n"))
end
function isSchemaOfCommonNames(p9) -- line: 164
	-- upvalues: isNotNillish (copy)
	local v63 = p9:getQueryType()

	if isNotNillish(v63) and v63.name ~= "Query" then
		return false
	end

	local v64 = p9:getMutationType()

	if isNotNillish(v64) and v64.name ~= "Mutation" then
		return false
	end

	local v65 = p9:getSubscriptionType()

	if isNotNillish(v65) and v65.name ~= "Subscription" then
		return false
	end

	return true
end
function printType(p10) -- line: 190
	-- upvalues: isScalarType (copy), printScalar (ref), isObjectType (copy), printObject (ref), isInterfaceType (copy), printInterface (ref), isUnionType (copy), printUnion (ref), isEnumType (copy), printEnum (ref), isInputObjectType (copy), printInputObject (ref), invariant (copy), inspect (copy)
	if isScalarType(p10) then
		return printScalar(p10)
	end

	if isObjectType(p10) then
		return printObject(p10)
	end

	if isInterfaceType(p10) then
		return printInterface(p10)
	end

	if isUnionType(p10) then
		return printUnion(p10)
	end

	if isEnumType(p10) then
		return printEnum(p10)
	end

	if isInputObjectType(p10) then
		return printInputObject(p10)
	end

	invariant(false, "Unexpected type: " .. inspect(p10))

	return ""
end
function printScalar(p11) -- line: 218
	-- upvalues: printDescription (ref), printSpecifiedByUrl (ref)
	return printDescription(p11) .. ("scalar %s"):format(p11.name) .. printSpecifiedByUrl(p11)
end

local function printImplementedInterfaces(p12) -- line: 222
	-- upvalues: Array (copy)
	local v69 = p12:getInterfaces()

	if #v69 > 0 then
		return " implements " .. Array.join(Array.map(v69, function(p13) -- line: 230
			return p13.name
		end), " & ")
	end

	return ""
end

function printObject(p14) -- line: 238
	-- upvalues: printDescription (ref), printImplementedInterfaces (copy), printFields (ref)
	return printDescription(p14) .. ("type %s"):format(p14.name) .. printImplementedInterfaces(p14) .. printFields(p14)
end
function printInterface(p15) -- line: 245
	-- upvalues: printDescription (ref), printImplementedInterfaces (copy), printFields (ref)
	return printDescription(p15) .. ("interface %s"):format(p15.name) .. printImplementedInterfaces(p15) .. printFields(p15)
end
function printUnion(p16) -- line: 252
	-- upvalues: Array (copy), printDescription (ref)
	local v73 = p16:getTypes()
	local v74 = not (#v73 > 0) and "" or " = " .. Array.join(v73, " | ")

	return printDescription(p16) .. "union " .. p16.name .. v74
end
function printEnum(p17) -- line: 259
	-- upvalues: Array (copy), printDescription (ref), printDeprecated (ref), printBlock (ref)
	local v76 = Array.map(p17:getValues(), function(p18, p19) -- line: 261
		-- upvalues: printDescription (ref), printDeprecated (ref)
		return printDescription(p18, "  ", p19 == 1) .. "  " .. p18.name .. printDeprecated(p18.deprecationReason)
	end)

	return printDescription(p17) .. ("enum %s"):format(p17.name) .. printBlock(v76)
end
function printInputObject(p20) -- line: 271
	-- upvalues: Array (copy), printDescription (ref), printInputValue (ref), printBlock (ref)
	local v78 = Array.map(p20:getFields():values(), function(p21, p22) -- line: 274
		-- upvalues: printDescription (ref), printInputValue (ref)
		return printDescription(p21, "  ", p22 == 1) .. "  " .. printInputValue(p21)
	end)

	return printDescription(p20) .. ("input %s"):format(p20.name) .. printBlock(v78)
end
function printFields(p23) -- line: 281
	-- upvalues: Array (copy), printDescription (ref), printArgs (ref), printDeprecated (ref), printBlock (ref)
	local v80 = Array.map(p23:getFields():values(), function(p24, p25) -- line: 287
		-- upvalues: printDescription (ref), printArgs (ref), printDeprecated (ref)
		return printDescription(p24, "  ", p25 == 1) .. "  " .. p24.name .. printArgs(p24.args, "  ") .. ": " .. tostring(p24.type) .. printDeprecated(p24.deprecationReason)
	end)

	return printBlock(v80)
end
function printBlock(p26) -- line: 301
	-- upvalues: Array (copy)
	if #p26 ~= 0 then
		return " {\n" .. Array.join(p26, "\n") .. "\n}"
	end

	return ""
end
function printArgs(p27, s1: string?) -- line: 305
	-- upvalues: Array (copy), isNillish2 (copy), printInputValue (ref), printDescription (ref)
	local v84 = s1 == nil and "" or s1

	if #p27 == 0 then
		return ""
	end

	if Array.every(p27, function(p28) -- line: 314
		-- upvalues: isNillish2 (copy)
		return isNillish2(p28.description)
	end) then
		return "(" .. Array.join(Array.map(p27, printInputValue), ", ") .. ")"
	end

	return "(\n" .. Array.join(Array.map(p27, function(p29, p30) -- line: 326
		-- upvalues: printDescription (ref), v84 (copy), printInputValue (ref)
		return printDescription(p29, "  " .. v84, p30 == 1) .. "  " .. v84 .. printInputValue(p29)
	end), "\n") .. "\n" .. v84 .. ")"
end
function printInputValue(p31) -- line: 339
	-- upvalues: astFromValue (copy), isNotNillish (copy), print (copy), printDeprecated (ref)
	local v86 = astFromValue(p31.defaultValue, p31.type)
	local v87 = p31.name .. ": " .. tostring(p31.type)

	if isNotNillish(v86) then
		v87 ..= (" = %s"):format(print(v86))
	end

	return v87 .. printDeprecated(p31.deprecationReason)
end
function printDirective(p32) -- line: 351
	-- upvalues: printDescription (ref), printArgs (ref), Array (copy)
	return printDescription(p32) .. "directive @" .. p32.name .. printArgs(p32.args) .. (not p32.isRepeatable and "" or " repeatable") .. " on " .. Array.join(p32.locations, " | ")
end
function printDeprecated(s2: string?) -- line: 361
	-- upvalues: isNillish2 (copy), astFromValue (copy), GraphQLString (copy), DEFAULT_DEPRECATION_REASON (copy), print (copy)
	if isNillish2(s2) then
		return ""
	end

	local v90 = astFromValue(s2, GraphQLString)

	if v90 and s2 ~= DEFAULT_DEPRECATION_REASON then
		return " @deprecated(reason: " .. print(v90) .. ")"
	end

	return " @deprecated"
end
function printSpecifiedByUrl(p33) -- line: 376
	-- upvalues: isNillish2 (copy), astFromValue (copy), GraphQLString (copy), invariant (copy), print (copy)
	if isNillish2(p33.specifiedByUrl) then
		return ""
	end

	local specifiedByUrl = p33.specifiedByUrl
	local v93 = astFromValue(specifiedByUrl, GraphQLString)

	invariant(v93, "Unexpected null value returned from `astFromValue` for specifiedByUrl")

	return " @specifiedBy(url: " .. print(v93) .. ")"
end
function printDescription(t2: {[any]: any}, s3: string?, b1: boolean?) -- line: 390
	-- upvalues: isNillish2 (copy), printBlockString (copy), Boolean (copy)
	local v97 = s3 == nil and "" or s3
	local v98 = b1 == nil or b1
	local description = t2.description

	if isNillish2(description) then
		return ""
	end

	local v100 = string.len(description) > 70
	local v101 = printBlockString(description, "", v100)
	local v102 = if not Boolean.toJSBoolean(v97) or v98 then v97 else "\n" .. v97
	local result, _ = string.gsub(v101, "\n", "\n" .. v97)

	return v102 .. result .. "\n"
end

return {
	printSchema = function(p34) -- line: 76
		-- upvalues: printFilteredSchema (ref), isSpecifiedDirective (copy), isDefinedType (ref)
		return printFilteredSchema(p34, function(p35) -- line: 77
			-- upvalues: isSpecifiedDirective (copy)
			return not isSpecifiedDirective(p35)
		end, isDefinedType)
	end,
	printIntrospectionSchema = function(p36) -- line: 82
		-- upvalues: printFilteredSchema (ref), isSpecifiedDirective (copy), isIntrospectionType (copy)
		return printFilteredSchema(p36, isSpecifiedDirective, isIntrospectionType)
	end,
	printType = printType,
	NULL = NULL
}
