local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local coerceToMap = LuauPolyfill.coerceToMap
local null = require(ParentParent.luaUtils.null)
local v10 = Object.freeze({})
local luaUtils = ParentParent.luaUtils
local isNillish = require(luaUtils.isNillish).isNillish
local jsutils = ParentParent.jsutils

require(jsutils.ObjMap)

local inspect = require(jsutils.inspect).inspect
local keyMap = require(jsutils.keyMap).keyMap
local toObjMap = require(jsutils.toObjMap).toObjMap
local keyValMap = require(jsutils.keyValMap).keyValMap
local devAssert = require(jsutils.devAssert).devAssert
local instanceOf = require(jsutils.instanceOf)
local didYouMean = require(jsutils.didYouMean).didYouMean
local isObjectLike = require(jsutils.isObjectLike).isObjectLike
local identityFunc = require(jsutils.identityFunc).identityFunc
local suggestionList = require(jsutils.suggestionList).suggestionList

require(jsutils.PromiseOrValue)
require(jsutils.Path)

local mapValueOrdered = require(ParentParent.luaUtils.mapValueOrdered).mapValueOrdered
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local Kind = require(language.kinds).Kind
local print = require(language.printer).print

require(ParentParent.language.ast)

local valueFromASTUntyped = require(ParentParent.utilities.valueFromASTUntyped).valueFromASTUntyped
local isScalarType = nil
local isObjectType = nil
local isInterfaceType = nil
local isUnionType = nil
local isEnumType = nil
local isInputObjectType = nil
local isListType = nil
local isNonNullType = nil
local isWrappingType = nil
local isNullableType = nil
local argsToArgsConfig = nil
local defineInputFieldMap = nil
local defineTypes = nil
local isPlainObj = nil
local didYouMeanEnumValue = nil
local defineEnumValues = nil
local fieldsToFieldsConfig = nil
local defineInterfaces = nil
local defineFieldMap = nil
local t7 = nil
local t9 = nil
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}

local function isType(p1) -- line: 167
	-- upvalues: isScalarType (ref), isObjectType (ref), isInterfaceType (ref), isUnionType (ref), isEnumType (ref), isInputObjectType (ref), isListType (ref), isNonNullType (ref)
	return isScalarType(p1) or (isObjectType(p1) or (isInterfaceType(p1) or (isUnionType(p1) or (isEnumType(p1) or (isInputObjectType(p1) or (isListType(p1) or isNonNullType(p1)))))))
end

function isScalarType(p2) -- line: 190
	-- upvalues: instanceOf (copy), t1 (copy)
	return instanceOf(p2, t1)
end
function isObjectType(p3) -- line: 202
	-- upvalues: instanceOf (copy), t2 (copy)
	return instanceOf(p3, t2)
end
function isInterfaceType(p4) -- line: 214
	-- upvalues: instanceOf (copy), t3 (copy)
	return instanceOf(p4, t3)
end
function isUnionType(p5) -- line: 226
	-- upvalues: instanceOf (copy), t4 (copy)
	return instanceOf(p5, t4)
end
function isEnumType(p6) -- line: 238
	-- upvalues: instanceOf (copy), t5 (copy)
	return instanceOf(p6, t5)
end
function isInputObjectType(p7) -- line: 250
	-- upvalues: instanceOf (copy), t6 (copy)
	return instanceOf(p7, t6)
end
function isListType(p8) -- line: 262
	-- upvalues: instanceOf (copy), t7 (ref)
	return instanceOf(p8, t7)
end
function isNonNullType(p9) -- line: 274
	-- upvalues: instanceOf (copy), t9 (ref)
	return instanceOf(p9, t9)
end

local function isInputType(p10) -- line: 324
	-- upvalues: isScalarType (ref), isEnumType (ref), isInputObjectType (ref), isWrappingType (ref), isInputType (ref)
	return isScalarType(p10) or (isEnumType(p10) or (isInputObjectType(p10) or isWrappingType(p10) and isInputType(p10.ofType)))
end
local function isOutputType(p11) -- line: 358
	-- upvalues: isScalarType (ref), isObjectType (ref), isInterfaceType (ref), isUnionType (ref), isEnumType (ref), isWrappingType (ref), isOutputType (ref)
	return isScalarType(p11) or (isObjectType(p11) or (isInterfaceType(p11) or (isUnionType(p11) or (isEnumType(p11) or isWrappingType(p11) and isOutputType(p11.ofType)))))
end
local function isLeafType(p12) -- line: 380
	-- upvalues: isScalarType (ref), isEnumType (ref)
	return isScalarType(p12) or isEnumType(p12)
end
local function isCompositeType(p13) -- line: 397
	-- upvalues: isObjectType (ref), isInterfaceType (ref), isUnionType (ref)
	return isObjectType(p13) or (isInterfaceType(p13) or isUnionType(p13))
end
local function isAbstractType(p14) -- line: 414
	-- upvalues: isInterfaceType (ref), isUnionType (ref)
	return isInterfaceType(p14) or isUnionType(p14)
end

t7 = {}
t7.__index = t7

function t7.new(p15) -- line: 452
	-- upvalues: devAssert (copy), isType (ref), inspect (copy), t7 (ref)
	local t8 = {}

	devAssert(isType(p15), ("Expected %s to be a GraphQL type."):format(inspect(p15)))
	t8.ofType = p15

	return (setmetatable(t8, t7))
end
function t7.__tostring(p16) -- line: 462
	return p16:toString()
end
function t7.toString(p17) -- line: 466
	return "[" .. tostring(p17.ofType) .. "]"
end
function t7.toJSON(p18) -- line: 470
	return p18:toString()
end

t9 = {}
t9.__index = t9

function t9.new(p19) -- line: 509
	-- upvalues: devAssert (copy), isNullableType (ref), inspect (copy), t9 (ref)
	local t10 = {}

	devAssert(isNullableType(p19), ("Expected %s to be a GraphQL nullable type."):format(inspect(p19)))
	t10.ofType = p19

	return (setmetatable(t10, t9))
end
function t9.__tostring(p20) -- line: 520
	return p20:toString()
end
function t9.toString(p21) -- line: 524
	return tostring(p21.ofType) .. "!"
end
function t9.toJSON(p22) -- line: 528
	return p22:toString()
end
function isWrappingType(p23) -- line: 545
	-- upvalues: isListType (ref), isNonNullType (ref)
	return isListType(p23) or isNonNullType(p23)
end
function isNullableType(p24) -- line: 569
	-- upvalues: isType (ref), isNonNullType (ref)
	return isType(p24) and not isNonNullType(p24)
end

local function isNamedType(p25) -- line: 604
	-- upvalues: isScalarType (ref), isObjectType (ref), isInterfaceType (ref), isUnionType (ref), isEnumType (ref), isInputObjectType (ref)
	return isScalarType(p25) or (isObjectType(p25) or (isInterfaceType(p25) or (isUnionType(p25) or (isEnumType(p25) or isInputObjectType(p25)))))
end
local function resolveThunk(p26) -- line: 643
	if typeof(p26) == "function" then
		return (p26())
	end

	return p26
end
local function undefineIfEmpty(p27) -- line: 647
	if p27 and #p27 > 0 then
		return p27
	end

	return nil
end

t1.__index = t1

function t1.new(t11: {[any]: any}) -- line: 702
	-- upvalues: identityFunc (copy), valueFromASTUntyped (copy), toObjMap (copy), devAssert (copy), isNillish (copy), inspect (copy), t1 (copy)
	local t12 = {}
	local v116 = if not t11.parseValue then identityFunc else t11.parseValue

	t12.name = t11.name
	t12.description = t11.description
	t12.specifiedByUrl = t11.specifiedByUrl

	local v117 = if not t11.serialize then identityFunc else t11.serialize

	function t12.serialize(_, ...) -- line: 716
		-- upvalues: v117 (copy)
		return v117(...)
	end
	function t12.parseValue(_, ...) -- line: 720
		-- upvalues: v116 (copy)
		return v116(...)
	end

	local v118 = not t11.parseLiteral and function(p30, p31) -- line: 725
		-- upvalues: v116 (copy), valueFromASTUntyped (copy)
		return v116(valueFromASTUntyped(p30, p31))
	end or t11.parseLiteral

	function t12.parseLiteral(_, ...) -- line: 729
		-- upvalues: v118 (copy)
		return v118(...)
	end

	t12.extensions = if not t11.extensions then nil else toObjMap(t11.extensions)
	t12.astNode = t11.astNode

	local extensionASTNodes = t11.extensionASTNodes

	t12.extensionASTNodes = if not extensionASTNodes or not (#extensionASTNodes > 0) then nil else extensionASTNodes
	devAssert(typeof(t11.name) == "string", "Must provide name.")
	devAssert(isNillish(t11.specifiedByUrl) or typeof(t11.specifiedByUrl) == "string", ("%s must provide \"specifiedByUrl\" as a string, "):format(t12.name) .. ("but got: %s."):format(inspect(t11.specifiedByUrl)))
	devAssert(t11.serialize == nil or typeof(t11.serialize) == "function", ("%s must provide \"serialize\" function. If this custom Scalar is also used as an input type, ensure \"parseValue\" and \"parseLiteral\" functions are also provided."):format(t12.name))

	if t11.parseLiteral then
		devAssert(typeof(t11.parseValue) == "function" and typeof(t11.parseLiteral) == "function", ("%s must provide both \"parseValue\" and \"parseLiteral\" functions."):format(t12.name))
	end

	return (setmetatable(t12, t1))
end
function t1.toConfig(p33) -- line: 761
	return {
		name = p33.name,
		description = p33.description,
		specifiedByUrl = p33.specifiedByUrl,
		serialize = p33.serialize,
		parseValue = p33.parseValue,
		parseLiteral = p33.parseLiteral,
		extensions = p33.extensions,
		astNode = p33.astNode,
		extensionASTNodes = if not p33.extensionASTNodes then {} else p33.extensionASTNodes
	}
end
function t1.__tostring(p34) -- line: 775
	return p34:toString()
end
function t1.toString(p35) -- line: 779
	return p35.name
end
function t1.toJSON(p36) -- line: 783
	return p36:toString()
end

t2.__index = t2

function t2.new(t13: {[any]: any}) -- line: 917
	-- upvalues: toObjMap (copy), defineFieldMap (ref), defineInterfaces (ref), devAssert (copy), inspect (copy), t2 (copy)
	local t14 = {
		name = t13.name,
		description = t13.description,
		isTypeOf = t13.isTypeOf,
		extensions = if not t13.extensions then nil else toObjMap(t13.extensions),
		astNode = t13.astNode
	}
	local extensionASTNodes = t13.extensionASTNodes

	t14.extensionASTNodes = if not extensionASTNodes or not (#extensionASTNodes > 0) then nil else extensionASTNodes

	function t14._fields() -- line: 928
		-- upvalues: defineFieldMap (ref), t13 (copy)
		return defineFieldMap(t13)
	end
	function t14._interfaces() -- line: 931
		-- upvalues: defineInterfaces (ref), t13 (copy)
		return defineInterfaces(t13)
	end

	devAssert(typeof(t13.name) == "string", "Must provide name.")
	devAssert(t13.isTypeOf == nil or typeof(t13.isTypeOf) == "function", ("%s must provide \"isTypeOf\" as a function, but got: %s."):format(t14.name, inspect(t13.isTypeOf)))

	return (setmetatable(t14, t2))
end
function t2.getFields(p37) -- line: 946
	if typeof(p37._fields) == "function" then
		p37._fields = p37._fields()
	end

	return p37._fields
end
function t2.getInterfaces(p38) -- line: 953
	if typeof(p38._interfaces) == "function" then
		p38._interfaces = p38._interfaces()
	end

	return p38._interfaces
end
function t2.toConfig(p39) -- line: 960
	-- upvalues: fieldsToFieldsConfig (ref)
	return {
		name = p39.name,
		description = p39.description,
		interfaces = p39:getInterfaces(),
		fields = fieldsToFieldsConfig(p39:getFields()),
		isTypeOf = p39.isTypeOf,
		extensions = p39.extensions,
		astNode = p39.astNode,
		extensionASTNodes = p39.extensionASTNodes or {}
	}
end
function t2.__tostring(p40) -- line: 973
	return p40:toString()
end
function t2.toString(p41) -- line: 977
	return p41.name
end
function t2.toJSON(p42) -- line: 981
	return p42:toString()
end
function defineInterfaces(t15: {[any]: any}) -- line: 992
	-- upvalues: devAssert (copy), Array (copy)
	local interfaces = t15.interfaces
	local v135 = ((if typeof(interfaces) ~= "function" then interfaces else interfaces())) or {}

	devAssert(Array.isArray(v135), ("%s interfaces must be an Array or a function which returns an Array."):format(t15.name))

	return v135
end
function defineFieldMap(t16: {[any]: any}) -- line: 1006
	-- upvalues: devAssert (copy), isPlainObj (ref), instanceOf (copy), Map (copy), coerceToMap (copy), mapValueOrdered (copy), inspect (copy), Array (copy), toObjMap (copy)
	local fields = t16.fields
	local v138 = if typeof(fields) ~= "function" then fields else fields()

	devAssert(isPlainObj(v138) or instanceOf(v138, Map), ("%s fields must be an object with field names as keys or a function which returns such an object."):format(t16.name))

	local v139 = coerceToMap(v138)

	return mapValueOrdered(v139, function(p43, p44) -- line: 1022
		-- upvalues: devAssert (copy), isPlainObj (ref), t16 (copy), inspect (copy), instanceOf (copy), Map (copy), Array (copy), coerceToMap (copy), toObjMap (copy)
		devAssert(isPlainObj(p43), ("%s.%s field config must be an object."):format(t16.name, p44))
		devAssert(p43.resolve == nil or typeof(p43.resolve) == "function", ("%s.%s field resolver must be a function if "):format(t16.name, p44) .. ("provided, but got: %s."):format(inspect(p43.resolve)))

		local v216 = if not p43.args then {} else p43.args

		devAssert(isPlainObj(v216) or instanceOf(v216, Map), ("%s.%s args must be an object with argument names as keys."):format(t16.name, p44))

		local v217 = Array.map(coerceToMap(v216):entries(), function(p45) -- line: 1043
			-- upvalues: toObjMap (copy)
			local v233 = p45[1]
			local v234 = p45[2]

			return {
				name = v233,
				description = v234.description,
				type = v234.type,
				defaultValue = v234.defaultValue,
				deprecationReason = v234.deprecationReason,
				extensions = if not v234.extensions then nil else toObjMap(v234.extensions),
				astNode = v234.astNode
			}
		end)

		return {
			name = p44,
			description = p43.description,
			type = p43.type,
			args = v217,
			resolve = p43.resolve,
			subscribe = p43.subscribe,
			deprecationReason = p43.deprecationReason,
			extensions = if not p43.extensions then nil else toObjMap(p43.extensions),
			astNode = p43.astNode
		}
	end)
end
function isPlainObj(p46) -- line: 1071
	-- upvalues: null (copy), isObjectLike (copy), Array (copy)
	return p46 ~= null and (isObjectLike(p46) and (not Array.isArray(p46) or next(p46) == nil))
end
function fieldsToFieldsConfig(p47) -- line: 1080
	-- upvalues: mapValueOrdered (copy), argsToArgsConfig (ref)
	return mapValueOrdered(p47, function(p48) -- line: 1084
		-- upvalues: argsToArgsConfig (ref)
		return {
			description = p48.description,
			type = p48.type,
			args = argsToArgsConfig(p48.args),
			resolve = p48.resolve,
			subscribe = p48.subscribe,
			deprecationReason = p48.deprecationReason,
			extensions = p48.extensions,
			astNode = p48.astNode
		}
	end)
end
function argsToArgsConfig(p49) -- line: 1101
	-- upvalues: keyValMap (copy)
	return keyValMap(p49, function(p50) -- line: 1102
		return p50.name
	end, function(p51) -- line: 1104
		return {
			description = p51.description,
			type = p51.type,
			defaultValue = p51.defaultValue,
			deprecationReason = p51.deprecationReason,
			extensions = p51.extensions,
			astNode = p51.astNode
		}
	end)
end

t3.__index = t3

function t3.new(t17: {[any]: any}) -- line: 1277
	-- upvalues: toObjMap (copy), defineFieldMap (ref), defineInterfaces (ref), devAssert (copy), inspect (copy), t3 (copy)
	local t18 = {
		name = t17.name,
		description = t17.description,
		resolveType = t17.resolveType,
		extensions = if not t17.extensions then nil else toObjMap(t17.extensions),
		astNode = t17.astNode
	}
	local extensionASTNodes = t17.extensionASTNodes

	t18.extensionASTNodes = if not extensionASTNodes or not (#extensionASTNodes > 0) then nil else extensionASTNodes

	function t18._fields() -- line: 1288
		-- upvalues: defineFieldMap (ref), t17 (copy)
		return defineFieldMap(t17)
	end
	function t18._interfaces() -- line: 1291
		-- upvalues: defineInterfaces (ref), t17 (copy)
		return defineInterfaces(t17)
	end

	devAssert(typeof(t17.name) == "string", "Must provide name.")
	devAssert(t17.resolveType == nil or typeof(t17.resolveType) == "function", ("%s must provide \"resolveType\" as a function, but got: %s."):format(t18.name, inspect(t17.resolveType)))

	return (setmetatable(t18, t3))
end
function t3.getFields(p52) -- line: 1306
	if typeof(p52._fields) == "function" then
		p52._fields = p52._fields()
	end

	return p52._fields
end
function t3.getInterfaces(p53) -- line: 1313
	if typeof(p53._interfaces) == "function" then
		p53._interfaces = p53._interfaces()
	end

	return p53._interfaces
end
function t3.toConfig(p54) -- line: 1320
	-- upvalues: fieldsToFieldsConfig (ref)
	return {
		name = p54.name,
		description = p54.description,
		interfaces = p54:getInterfaces(),
		fields = fieldsToFieldsConfig(p54:getFields()),
		resolveType = p54.resolveType,
		extensions = p54.extensions,
		astNode = p54.astNode,
		extensionASTNodes = p54.extensionASTNodes or {}
	}
end
function t3.__tostring(p55) -- line: 1333
	return p55:toString()
end
function t3.toString(p56) -- line: 1337
	return p56.name
end
function t3.toJSON(p57) -- line: 1341
	return p57:toString()
end

t4.__index = t4

function t4.new(t19: {[any]: any}) -- line: 1452
	-- upvalues: toObjMap (copy), defineTypes (ref), devAssert (copy), inspect (copy), t4 (copy)
	local t20 = {
		name = t19.name,
		description = t19.description,
		resolveType = t19.resolveType,
		extensions = if not t19.extensions then nil else toObjMap(t19.extensions),
		astNode = t19.astNode
	}
	local extensionASTNodes = t19.extensionASTNodes

	t20.extensionASTNodes = if not extensionASTNodes or not (#extensionASTNodes > 0) then nil else extensionASTNodes

	function t20._types() -- line: 1461
		-- upvalues: defineTypes (ref), t19 (copy)
		return defineTypes(t19)
	end

	devAssert(typeof(t19.name) == "string", "Must provide name.")
	devAssert(t19.resolveType == nil or typeof(t19.resolveType) == "function", ("%s must provide \"resolveType\" as a function, but got: %s."):format(t20.name, inspect(t19.resolveType)))

	return (setmetatable(t20, t4))
end
function t4.getTypes(p58) -- line: 1476
	if typeof(p58._types) == "function" then
		p58._types = p58._types()
	end

	return p58._types
end
function t4.toConfig(p59) -- line: 1483
	return {
		name = p59.name,
		description = p59.description,
		types = p59:getTypes(),
		resolveType = p59.resolveType,
		extensions = p59.extensions,
		astNode = p59.astNode,
		extensionASTNodes = p59.extensionASTNodes or {}
	}
end
function t4.__tostring(p60) -- line: 1495
	return p60:toString()
end
function t4.toString(p61) -- line: 1499
	return p61.name
end
function t4.toJSON(p62) -- line: 1503
	return p62:toString()
end
function defineTypes(t21: {[any]: any}) -- line: 1514
	-- upvalues: devAssert (copy), Array (copy)
	local types = t21.types
	local v163 = if typeof(types) ~= "function" then types else types()

	devAssert(Array.isArray(v163), ("Must provide Array of types or a function which returns such an array for Union %s."):format(t21.name))

	return v163
end

t5.__index = t5

function t5.new(t22: {[any]: any}) -- line: 1601
	-- upvalues: toObjMap (copy), defineEnumValues (ref), Array (copy), v10 (copy), keyMap (copy), devAssert (copy), t5 (copy)
	local t23 = {
		name = t22.name,
		description = t22.description,
		extensions = if not t22.extensions then nil else toObjMap(t22.extensions),
		astNode = t22.astNode
	}
	local extensionASTNodes = t22.extensionASTNodes

	t23.extensionASTNodes = if not extensionASTNodes or not (#extensionASTNodes > 0) then nil else extensionASTNodes
	t23._values = defineEnumValues(t23.name, t22.values)
	t23._valueLookup = {}
	Array.forEach(t23._values, function(p63) -- line: 1612
		-- upvalues: t23 (copy), v10 (copy)
		if p63.value == p63.value then
			t23._valueLookup[p63.value] = p63

			return
		end

		t23._valueLookup[v10] = p63
	end)
	t23._nameLookup = keyMap(t23._values, function(p64) -- line: 1624
		return p64.name
	end)
	devAssert(typeof(t22.name) == "string", "Must provide name.")

	return (setmetatable(t23, t5))
end
function t5.getValues(p65) -- line: 1633
	return p65._values
end
function t5.getValue(t24: {[any]: any}, s1: string) -- line: 1637
	return t24._nameLookup[s1]
end
function t5.serialize(p66, p67) -- line: 1641
	-- upvalues: v10 (copy), GraphQLError (copy), inspect (copy)
	local v172 = if p67 ~= p67 then p66._valueLookup[v10] else p66._valueLookup[p67]

	if v172 == nil then
		error(GraphQLError.new(("Enum \"%s\" cannot represent value: %s"):format(p66.name, inspect(p67))))
	end

	return v172.name
end
function t5.parseValue(p68, p69) -- line: 1663
	-- upvalues: inspect (copy), GraphQLError (copy), didYouMeanEnumValue (ref)
	if typeof(p69) ~= "string" then
		local v175 = inspect(p69)

		error(GraphQLError.new(("Enum \"%s\" cannot represent non-string value: %s." .. didYouMeanEnumValue(p68, v175)):format(p68.name, v175)))
	end

	local v176 = p68:getValue(p69)

	if v176 == nil then
		error(GraphQLError.new(("Value \"%s\" does not exist in \"%s\" enum."):format(p69, p68.name) .. didYouMeanEnumValue(p68, p69)))
	end

	return v176.value
end
function t5.parseLiteral(p70, p71, _) -- line: 1688
	-- upvalues: Kind (copy), print (copy), GraphQLError (copy), didYouMeanEnumValue (ref)
	if p71.kind ~= Kind.ENUM then
		local v180 = print(p71)

		error(GraphQLError.new(("Enum \"%s\" cannot represent non-enum value: %s."):format(p70.name, v180) .. didYouMeanEnumValue(p70, v180), p71))
	end

	local v181 = p70:getValue(p71.value)

	if v181 == nil then
		local v182 = print(p71)

		error(GraphQLError.new(("Value \"%s\" does not exist in \"%s\" enum."):format(v182, p70.name) .. didYouMeanEnumValue(p70, v182), p71))
	end

	return v181.value
end
function t5.toConfig(p73) -- line: 1715
	-- upvalues: keyValMap (copy)
	local v184 = keyValMap(p73:getValues(), function(p74) -- line: 1717
		return p74.name
	end, function(p75) -- line: 1719
		return {
			description = p75.description,
			value = p75.value,
			deprecationReason = p75.deprecationReason,
			extensions = p75.extensions,
			astNode = p75.astNode
		}
	end)

	return {
		name = p73.name,
		description = p73.description,
		values = v184,
		extensions = p73.extensions,
		astNode = p73.astNode,
		extensionASTNodes = p73.extensionASTNodes or {}
	}
end
function t5.__tostring(p76) -- line: 1741
	return p76:toString()
end
function t5.toString(p77) -- line: 1745
	return p77.name
end
function t5.toJSON(p78) -- line: 1749
	return p78:toString()
end
function didYouMeanEnumValue(t25: {[any]: any}, s2: string) -- line: 1760
	-- upvalues: Array (copy), suggestionList (copy), didYouMean (copy)
	local v190 = Array.map(t25:getValues(), function(p79) -- line: 1761
		return p79.name
	end)
	local v191 = suggestionList(s2, v190)

	return didYouMean("the enum value", v191)
end
function defineEnumValues(s3: string, p80) -- line: 1770
	-- upvalues: devAssert (copy), isPlainObj (ref), instanceOf (copy), Map (copy), coerceToMap (copy), Array (copy), inspect (copy), toObjMap (copy)
	devAssert(isPlainObj(p80) or instanceOf(p80, Map), ("%s values must be an object with value names as keys."):format((tostring(s3))))

	local v194 = coerceToMap(p80):entries()

	return Array.map(v194, function(p81) -- line: 1781
		-- upvalues: devAssert (copy), isPlainObj (ref), s3 (copy), inspect (copy), toObjMap (copy)
		local v227 = p81[1]
		local v228 = p81[2]

		devAssert(isPlainObj(v228), ("%s.%s must refer to an object with a \"value\" key "):format(tostring(s3), (tostring(v227))) .. ("representing an internal value but got: %s."):format(inspect(v228)))

		return {
			name = tostring(v227),
			description = v228.description,
			value = if v228.value == nil then v227 else v228.value,
			deprecationReason = v228.deprecationReason,
			extensions = if not v228.extensions then nil else toObjMap(v228.extensions),
			astNode = v228.astNode
		}
	end)
end

t6.__index = t6

function t6.new(t26: {[any]: any}) -- line: 1883
	-- upvalues: toObjMap (copy), defineInputFieldMap (ref), devAssert (copy), t6 (copy)
	local t27 = {
		name = t26.name,
		description = t26.description,
		extensions = if not t26.extensions then nil else toObjMap(t26.extensions),
		astNode = t26.astNode
	}
	local extensionASTNodes = t26.extensionASTNodes

	t27.extensionASTNodes = if not extensionASTNodes or not (#extensionASTNodes > 0) then nil else extensionASTNodes

	function t27._fields() -- line: 1891
		-- upvalues: defineInputFieldMap (ref), t26 (copy)
		return defineInputFieldMap(t26)
	end

	devAssert(typeof(t26.name) == "string", "Must provide name.")

	return (setmetatable(t27, t6))
end
function t6.getFields(p82) -- line: 1898
	if typeof(p82._fields) == "function" then
		p82._fields = p82._fields()
	end

	return p82._fields
end
function t6.toConfig(p83) -- line: 1905
	-- upvalues: mapValueOrdered (copy)
	local v200 = mapValueOrdered(p83:getFields(), function(p84) -- line: 1907
		return {
			description = p84.description,
			type = p84.type,
			defaultValue = p84.defaultValue,
			extensions = p84.extensions,
			astNode = p84.astNode
		}
	end)

	return {
		name = p83.name,
		description = p83.description,
		fields = v200,
		extensions = p83.extensions,
		astNode = p83.astNode,
		extensionASTNodes = p83.extensionASTNodes or {}
	}
end
function t6.__tostring(p85) -- line: 1927
	return p85:toString()
end
function t6.toString(p86) -- line: 1931
	return p86.name
end
function t6.toJSON(p87) -- line: 1935
	return p87:toString()
end
function defineInputFieldMap(t28: {[any]: any}) -- line: 1946
	-- upvalues: devAssert (copy), isPlainObj (ref), instanceOf (copy), Map (copy), coerceToMap (copy), mapValueOrdered (copy), toObjMap (copy)
	local fields = t28.fields
	local v206 = if typeof(fields) ~= "function" then fields else fields()

	devAssert(isPlainObj(v206) or instanceOf(v206, Map), ("%s fields must be an object with field names as keys or a function which returns such an object."):format(t28.name))

	local v207 = coerceToMap(v206)

	return mapValueOrdered(v207, function(p88, p89) -- line: 1960
		-- upvalues: devAssert (copy), t28 (copy), toObjMap (copy)
		devAssert(p88.resolve == nil, ("%s.%s field has a resolve property, but Input Types cannot define resolvers."):format(t28.name, p89))

		return {
			name = p89,
			description = p88.description,
			type = p88.type,
			defaultValue = p88.defaultValue,
			deprecationReason = p88.deprecationReason,
			extensions = if not p88.extensions then nil else toObjMap(p88.extensions),
			astNode = p88.astNode
		}
	end)
end;

({}).new = function() -- line: 2030
	return {}
end

return {
	GraphQLList = t7,
	GraphQLNonNull = t9,
	GraphQLScalarType = t1,
	GraphQLObjectType = t2,
	GraphQLInterfaceType = t3,
	GraphQLUnionType = t4,
	GraphQLEnumType = t5,
	GraphQLInputObjectType = t6,
	isType = isType,
	assertType = function(p90) -- line: 178
		-- upvalues: isType (ref), Error (copy), inspect (copy)
		if not isType(p90) then
			error(Error.new(("Expected %s to be a GraphQL type."):format(inspect(p90))))
		end

		return p90
	end,
	isScalarType = isScalarType,
	assertScalarType = function(p91) -- line: 194
		-- upvalues: isScalarType (ref), Error (copy), inspect (copy)
		if not isScalarType(p91) then
			error(Error.new(("Expected %s to be a GraphQL Scalar type."):format(inspect(p91))))
		end

		return p91
	end,
	isObjectType = isObjectType,
	assertObjectType = function(p92) -- line: 206
		-- upvalues: isObjectType (ref), Error (copy), inspect (copy)
		if not isObjectType(p92) then
			error(Error.new(("Expected %s to be a GraphQL Object type."):format(inspect(p92))))
		end

		return p92
	end,
	isInterfaceType = isInterfaceType,
	assertInterfaceType = function(p93) -- line: 218
		-- upvalues: isInterfaceType (ref), Error (copy), inspect (copy)
		if not isInterfaceType(p93) then
			error(Error.new(("Expected %s to be a GraphQL Interface type."):format(inspect(p93))))
		end

		return p93
	end,
	isUnionType = isUnionType,
	assertUnionType = function(p94) -- line: 230
		-- upvalues: isUnionType (ref), Error (copy), inspect (copy)
		if not isUnionType(p94) then
			error(Error.new(("Expected %s to be a GraphQL Union type."):format(inspect(p94))))
		end

		return p94
	end,
	isEnumType = isEnumType,
	assertEnumType = function(p95) -- line: 242
		-- upvalues: isEnumType (ref), Error (copy), inspect (copy)
		if not isEnumType(p95) then
			error(Error.new(("Expected %s to be a GraphQL Enum type."):format(inspect(p95))))
		end

		return p95
	end,
	isInputObjectType = isInputObjectType,
	assertInputObjectType = function(p96) -- line: 254
		-- upvalues: isInputObjectType (ref), Error (copy), inspect (copy)
		if not isInputObjectType(p96) then
			error(Error.new(("Expected %s to be a GraphQL Input Object type."):format(inspect(p96))))
		end

		return p96
	end,
	isListType = isListType,
	assertListType = function(p97) -- line: 266
		-- upvalues: isListType (ref), Error (copy), inspect (copy)
		if not isListType(p97) then
			error(Error.new(("Expected %s to be a GraphQL List type."):format(inspect(p97))))
		end

		return p97
	end,
	isNonNullType = isNonNullType,
	assertNonNullType = function(p98) -- line: 278
		-- upvalues: isNonNullType (ref), Error (copy), inspect (copy)
		if not isNonNullType(p98) then
			error(Error.new(("Expected %s to be a GraphQL Non-Null type."):format(inspect(p98))))
		end

		return p98
	end,
	isInputType = isInputType,
	assertInputType = function(p99) -- line: 331
		-- upvalues: isInputType (ref), Error (copy), inspect (copy)
		if not isInputType(p99) then
			error(Error.new(("Expected %s to be a GraphQL input type."):format(inspect(p99))))
		end

		return p99
	end,
	isOutputType = isOutputType,
	assertOutputType = function(p100) -- line: 367
		-- upvalues: isOutputType (ref), Error (copy), inspect (copy)
		if not isOutputType(p100) then
			error(Error.new(("Expected %s to be a GraphQL output type."):format(inspect(p100))))
		end

		return p100
	end,
	isLeafType = isLeafType,
	assertLeafType = function(p101) -- line: 384
		-- upvalues: isLeafType (ref), Error (copy), inspect (copy)
		if not isLeafType(p101) then
			error(Error.new(("Expected %s to be a GraphQL leaf type."):format(inspect(p101))))
		end

		return p101
	end,
	isCompositeType = isCompositeType,
	assertCompositeType = function(p102) -- line: 401
		-- upvalues: isCompositeType (ref), Error (copy), inspect (copy)
		if not isCompositeType(p102) then
			error(Error.new(("Expected %s to be a GraphQL composite type."):format(inspect(p102))))
		end

		return p102
	end,
	isAbstractType = isAbstractType,
	assertAbstractType = function(p103) -- line: 418
		-- upvalues: isAbstractType (ref), Error (copy), inspect (copy)
		if not isAbstractType(p103) then
			error(Error.new(("Expected %s to be a GraphQL abstract type."):format(inspect(p103))))
		end

		return p103
	end,
	isWrappingType = isWrappingType,
	assertWrappingType = function(p104) -- line: 549
		-- upvalues: isWrappingType (ref), Error (copy), inspect (copy)
		if not isWrappingType(p104) then
			error(Error.new(("Expected %s to be a GraphQL wrapping type."):format(inspect(p104))))
		end

		return p104
	end,
	isNullableType = isNullableType,
	assertNullableType = function(p105) -- line: 573
		-- upvalues: isNullableType (ref), Error (copy), inspect (copy)
		if not isNullableType(p105) then
			error(Error.new(("Expected %s to be a GraphQL nullable type."):format(inspect(p105))))
		end

		return p105
	end,
	getNullableType = function(p106) -- line: 581
		-- upvalues: isNonNullType (ref)
		if p106 then
			if isNonNullType(p106) then
				return p106.ofType
			end

			return p106
		end

		return nil
	end,
	isNamedType = isNamedType,
	assertNamedType = function(p107) -- line: 613
		-- upvalues: isNamedType (ref), Error (copy), inspect (copy)
		if not isNamedType(p107) then
			error(Error.new(("Expected %s to be a GraphQL named type."):format(inspect(p107))))
		end

		return p107
	end,
	getNamedType = function(p108) -- line: 621
		-- upvalues: isWrappingType (ref)
		if p108 then
			while isWrappingType(p108) do
				p108 = p108.ofType
			end

			return p108
		end

		return nil
	end,
	argsToArgsConfig = argsToArgsConfig,
	isRequiredArgument = function(t29: {[any]: any}) -- line: 1228
		-- upvalues: isNonNullType (ref)
		return isNonNullType(t29.type) and t29.defaultValue == nil
	end,
	isRequiredInputField = function(t30: {[any]: any}) -- line: 2020
		-- upvalues: isNonNullType (ref)
		return isNonNullType(t30.type) and t30.defaultValue == nil
	end,
	NULL = null
}
