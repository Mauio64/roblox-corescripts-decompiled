local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local coerceToMap = LuauPolyfill.coerceToMap

local null = require(parent.luaUtils.null)

local frozen = Object.freeze({})
local luaUtils = parent.luaUtils

local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish

local jsutils = parent.jsutils
require(jsutils.ObjMap)

local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local keyMap = require(jsutils.keyMap)
local keyMap2 = keyMap.keyMap
local toObjMap = require(jsutils.toObjMap)
local toObjMap2 = toObjMap.toObjMap
local keyValMap = require(jsutils.keyValMap)
local keyValMap2 = keyValMap.keyValMap
local devAssert = require(jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local instanceOf = require(jsutils.instanceOf)
local didYouMean = require(jsutils.didYouMean)
local didYouMean2 = didYouMean.didYouMean
local isObjectLike = require(jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike
local identityFunc = require(jsutils.identityFunc)
local identityFunc2 = identityFunc.identityFunc
local suggestionList = require(jsutils.suggestionList)
local suggestionList2 = suggestionList.suggestionList
require(jsutils.PromiseOrValue)

require(jsutils.Path)

local mapValueOrdered = require(parent.luaUtils.mapValueOrdered)
local mapValueOrdered2 = mapValueOrdered.mapValueOrdered

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local language = parent.language
local kinds = require(language.kinds)
local kind = kinds.Kind
local printer = require(language.printer)
local Print = printer.print

require(parent.language.ast)

local valueFromASTUntyped = require(parent.utilities.valueFromASTUntyped)
local valueFromASTUntyped2 = valueFromASTUntyped.valueFromASTUntyped

local isScalarType

local isObjectType

local isInterfaceType

local isUnionType

local isEnumType

local isInputObjectType

local isListType

local isNonNullType

local isWrappingType

local isNullableType

local argsToArgsConfig

local defineInputFieldMap
local defineTypes
local isPlainObj
local didYouMeanEnumValue
local defineEnumValues
local fieldsToFieldsConfig
local defineInterfaces
local defineFieldMap

local class = nil
local class2 = nil
local class3 = {}
local class4 = {}
local class5 = {}
local class6 = {}
local class7 = {}
local class8 = {}

local function isType(p)
	return isScalarType(p)
		or isObjectType(p)
		or isInterfaceType(p)
		or isUnionType(p)
		or isEnumType(p)
		or isInputObjectType(p)
		or isListType(p)
		or isNonNullType(p)
end

local function assertType(p)
	if not isType(p) then
		error(Error.new(("Expected %s to be a GraphQL type."):format(inspect2(p))))
	end

	return p
end

isScalarType = function(p)
	return instanceOf(p, class3)
end

local function assertScalarType(p)
	if not isScalarType(p) then
		error(Error.new(("Expected %s to be a GraphQL Scalar type."):format(inspect2(p))))
	end

	return p
end

isObjectType = function(p)
	return instanceOf(p, class4)
end

local function assertObjectType(p)
	if not isObjectType(p) then
		error(Error.new(("Expected %s to be a GraphQL Object type."):format(inspect2(p))))
	end

	return p
end

isInterfaceType = function(p)
	return instanceOf(p, class5)
end

local function assertInterfaceType(p)
	if not isInterfaceType(p) then
		error(Error.new(("Expected %s to be a GraphQL Interface type."):format(inspect2(p))))
	end

	return p
end

isUnionType = function(p)
	return instanceOf(p, class6)
end

local function assertUnionType(p)
	if not isUnionType(p) then
		error(Error.new(("Expected %s to be a GraphQL Union type."):format(inspect2(p))))
	end

	return p
end

isEnumType = function(p)
	return instanceOf(p, class7)
end

local function assertEnumType(p)
	if not isEnumType(p) then
		error(Error.new(("Expected %s to be a GraphQL Enum type."):format(inspect2(p))))
	end

	return p
end

isInputObjectType = function(p)
	return instanceOf(p, class8)
end

local function assertInputObjectType(p)
	if not isInputObjectType(p) then
		error(Error.new(("Expected %s to be a GraphQL Input Object type."):format(inspect2(p))))
	end

	return p
end

isListType = function(p)
	return instanceOf(p, class)
end

local function assertListType(p)
	if not isListType(p) then
		error(Error.new(("Expected %s to be a GraphQL List type."):format(inspect2(p))))
	end

	return p
end

isNonNullType = function(p)
	return instanceOf(p, class2)
end

local function assertNonNullType(p)
	if not isNonNullType(p) then
		error(Error.new(("Expected %s to be a GraphQL Non-Null type."):format(inspect2(p))))
	end

	return p
end

local function isInputType(p)
	return isScalarType(p) or isEnumType(p) or isInputObjectType(p) or isWrappingType(p) and isInputType(p.ofType)
end

local function assertInputType(p)
	if not isInputType(p) then
		error(Error.new(("Expected %s to be a GraphQL input type."):format(inspect2(p))))
	end

	return p
end

local function isOutputType(p)
	return isScalarType(p)
		or isObjectType(p)
		or isInterfaceType(p)
		or isUnionType(p)
		or isEnumType(p)
		or isWrappingType(p) and isOutputType(p.ofType)
end

local function assertOutputType(p)
	if not isOutputType(p) then
		error(Error.new(("Expected %s to be a GraphQL output type."):format(inspect2(p))))
	end

	return p
end

local function isLeafType(p)
	return isScalarType(p) or isEnumType(p)
end

local function assertLeafType(p)
	if not isLeafType(p) then
		error(Error.new(("Expected %s to be a GraphQL leaf type."):format(inspect2(p))))
	end

	return p
end

local function isCompositeType(p)
	return isObjectType(p) or isInterfaceType(p) or isUnionType(p)
end

local function assertCompositeType(p)
	if not isCompositeType(p) then
		error(Error.new(("Expected %s to be a GraphQL composite type."):format(inspect2(p))))
	end

	return p
end

local function isAbstractType(p)
	return isInterfaceType(p) or isUnionType(p)
end

local function assertAbstractType(p)
	if not isAbstractType(p) then
		error(Error.new(("Expected %s to be a GraphQL abstract type."):format(inspect2(p))))
	end

	return p
end

class = {}

class.__index = class

function class.new(ofType)
	devAssert2(isType(ofType), ("Expected %s to be a GraphQL type."):format(inspect2(ofType)))
	return (setmetatable({ ofType = ofType }, class))
end

function class:__tostring()
	return self:toString()
end

function class:toString()
	return "[" .. tostring(self.ofType) .. "]"
end

function class:toJSON()
	return self:toString()
end

class2 = {}

class2.__index = class2

function class2.new(ofType)
	devAssert2(isNullableType(ofType), ("Expected %s to be a GraphQL nullable type."):format(inspect2(ofType)))
	return (setmetatable({ ofType = ofType }, class2))
end

function class2:__tostring()
	return self:toString()
end

function class2:toString()
	return tostring(self.ofType) .. "!"
end

function class2:toJSON()
	return self:toString()
end

isWrappingType = function(p)
	return isListType(p) or isNonNullType(p)
end

local function assertWrappingType(p)
	if not isWrappingType(p) then
		error(Error.new(("Expected %s to be a GraphQL wrapping type."):format(inspect2(p))))
	end

	return p
end

isNullableType = function(p)
	return isType(p) and not isNonNullType(p)
end

local function assertNullableType(p)
	if not isNullableType(p) then
		error(Error.new(("Expected %s to be a GraphQL nullable type."):format(inspect2(p))))
	end

	return p
end

local function getNullableType(p)
	if not p then
		return nil
	end

	return if isNonNullType(p) then p.ofType else p
end

local function isNamedType(p)
	return isScalarType(p)
		or isObjectType(p)
		or isInterfaceType(p)
		or isUnionType(p)
		or isEnumType(p)
		or isInputObjectType(p)
end

local function assertNamedType(p)
	if not isNamedType(p) then
		error(Error.new(("Expected %s to be a GraphQL named type."):format(inspect2(p))))
	end

	return p
end

local function getNamedType(p)
	if not p then
		return nil
	end

	while isWrappingType(p) do
		p = p.ofType
	end

	return p
end

local function resolveThunk(callback) -- 4 equivalent calls inferred from this helper
	if typeof(callback) == "function" then
		return (callback())
	end

	return callback
end

local function undefineIfEmpty(extensionASTNodes) -- 6 equivalent calls inferred from this helper
	if extensionASTNodes and #extensionASTNodes > 0 then
		return extensionASTNodes
	end

	return nil
end

class3.__index = class3

function class3.new(data)
	local v = {}
	local v2

	if data.parseValue then
		v2 = data.parseValue
	else
		v2 = identityFunc2
	end

	v.name = data.name
	v.description = data.description
	v.specifiedByUrl = data.specifiedByUrl
	local v3

	if data.serialize then
		v3 = data.serialize
	else
		v3 = identityFunc2
	end

	function v.serialize(_, ...)
		return v3(...)
	end

	function v.parseValue(_, ...)
		return v2(...)
	end

	local v4

	if data.parseLiteral then
		v4 = data.parseLiteral
	else
		v4 = function(p, p2)
			return v2(valueFromASTUntyped2(p, p2))
		end
	end

	function v.parseLiteral(_, ...)
		return v4(...)
	end

	local extensions

	if data.extensions then
		extensions = toObjMap2(data.extensions)
	end

	v.extensions = extensions
	v.astNode = data.astNode
	v.extensionASTNodes = undefineIfEmpty(data.extensionASTNodes) -- inferred equivalent call

	devAssert2(typeof(data.name) == "string", "Must provide name.")

	devAssert2(
		isNillish2(data.specifiedByUrl) or typeof(data.specifiedByUrl) == "string",
		("%s must provide \"specifiedByUrl\" as a string, "):format(v.name) .. ("but got: %s."):format(inspect2(data.specifiedByUrl))
	)

	devAssert2(
		data.serialize == nil or typeof(data.serialize) == "function",
		("%s must provide \"serialize\" function. If this custom Scalar is also used as an input type, ensure \"parseValue\" and \"parseLiteral\" functions are also provided."):format(v.name)
	)

	if data.parseLiteral then
		devAssert2(
			typeof(data.parseValue) == "function" and typeof(data.parseLiteral) == "function",
			("%s must provide both \"parseValue\" and \"parseLiteral\" functions."):format(v.name)
		)
	end

	return (setmetatable(v, class3))
end

function class3.toConfig(data)
	return {
		name = data.name,
		description = data.description,
		specifiedByUrl = data.specifiedByUrl,
		serialize = data.serialize,
		parseValue = data.parseValue,
		parseLiteral = data.parseLiteral,
		extensions = data.extensions,
		astNode = data.astNode,
		extensionASTNodes = not data.extensionASTNodes and {} or data.extensionASTNodes
	}
end

function class3:__tostring()
	return self:toString()
end

function class3:toString()
	return self.name
end

function class3:toJSON()
	return self:toString()
end

class4.__index = class4

function class4.new(data)
	local v = {}
	v.name = data.name
	v.description = data.description
	v.isTypeOf = data.isTypeOf
	local extensions

	if data.extensions then
		extensions = toObjMap2(data.extensions)
	end

	v.extensions = extensions
	v.astNode = data.astNode
	v.extensionASTNodes = undefineIfEmpty(data.extensionASTNodes) -- inferred equivalent call

	function v._fields()
		return defineFieldMap(data)
	end

	function v._interfaces()
		return defineInterfaces(data)
	end

	devAssert2(typeof(data.name) == "string", "Must provide name.")
	devAssert2(
		data.isTypeOf == nil or typeof(data.isTypeOf) == "function",
		("%s must provide \"isTypeOf\" as a function, but got: %s."):format(v.name, inspect2(data.isTypeOf))
	)

	return (setmetatable(v, class4))
end

function class4:getFields()
	if typeof(self._fields) == "function" then
		self._fields = self._fields()
	end

	return self._fields
end

function class4:getInterfaces()
	if typeof(self._interfaces) == "function" then
		self._interfaces = self._interfaces()
	end

	return self._interfaces
end

function class4:toConfig()
	return {
		name = self.name,
		description = self.description,
		interfaces = self:getInterfaces(),
		fields = fieldsToFieldsConfig(self:getFields()),
		isTypeOf = self.isTypeOf,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {}
	}
end

function class4:__tostring()
	return self:toString()
end

function class4:toString()
	return self.name
end

function class4:toJSON()
	return self:toString()
end

defineInterfaces = function(data)
	local selected = resolveThunk(data.interfaces) or {} -- inferred equivalent call

	devAssert2(
		Array.isArray(selected),
		("%s interfaces must be an Array or a function which returns an Array."):format(data.name)
	)

	return selected
end

defineFieldMap = function(data)
	local thunk = resolveThunk(data.fields) -- inferred equivalent call

	devAssert2(
		isPlainObj(thunk) or instanceOf(thunk, Map),
		("%s fields must be an object with field names as keys or a function which returns such an object."):format(data.name)
	)

	return mapValueOrdered2(coerceToMap(thunk), function(data2, name)
		devAssert2(isPlainObj(data2), ("%s.%s field config must be an object."):format(data.name, name))

		devAssert2(
			data2.resolve == nil or typeof(data2.resolve) == "function",
			("%s.%s field resolver must be a function if "):format(data.name, name) .. ("provided, but got: %s."):format(inspect2(data2.resolve))
		)

		local v = not data2.args and {} or data2.args

		devAssert2(
			isPlainObj(v) or instanceOf(v, Map),
			("%s.%s args must be an object with argument names as keys."):format(data.name, name)
		)

		local mapped = Array.map(coerceToMap(v):entries(), function(list)
			local item = list[1]
			local item2 = list[2]

			local v2 = {
				name = item,
				description = item2.description,
				type = item2.type,
				defaultValue = item2.defaultValue,
				deprecationReason = item2.deprecationReason,
				extensions = 0,
				astNode = 0
			}
			local extensions

			if item2.extensions then
				extensions = toObjMap2(item2.extensions)
			end

			v2.extensions = extensions
			v2.astNode = item2.astNode
			return v2
		end)

		local v2 = {
			name = name,
			description = data2.description,
			type = data2.type,
			args = mapped,
			resolve = data2.resolve,
			subscribe = data2.subscribe,
			deprecationReason = data2.deprecationReason,
			extensions = 0,
			astNode = 0
		}
		local extensions

		if data2.extensions then
			extensions = toObjMap2(data2.extensions)
		end

		v2.extensions = extensions
		v2.astNode = data2.astNode
		return v2
	end)
end

isPlainObj = function(items)
	return items ~= null and isObjectLike2(items) and (not Array.isArray(items) or next(items) == nil)
end

fieldsToFieldsConfig = function(p)
	return mapValueOrdered2(p, function(data)
		return {
			description = data.description,
			type = data.type,
			args = argsToArgsConfig(data.args),
			resolve = data.resolve,
			subscribe = data.subscribe,
			deprecationReason = data.deprecationReason,
			extensions = data.extensions,
			astNode = data.astNode
		}
	end)
end

argsToArgsConfig = function(args)
	return keyValMap2(args, function(p)
		return p.name
	end, function(data)
		return {
			description = data.description,
			type = data.type,
			defaultValue = data.defaultValue,
			deprecationReason = data.deprecationReason,
			extensions = data.extensions,
			astNode = data.astNode
		}
	end)
end

local function isRequiredArgument(p)
	return isNonNullType(p.type) and p.defaultValue == nil
end

class5.__index = class5

function class5.new(data)
	local v = {}
	v.name = data.name
	v.description = data.description
	v.resolveType = data.resolveType
	local extensions

	if data.extensions then
		extensions = toObjMap2(data.extensions)
	end

	v.extensions = extensions
	v.astNode = data.astNode
	v.extensionASTNodes = undefineIfEmpty(data.extensionASTNodes) -- inferred equivalent call

	function v._fields()
		return defineFieldMap(data)
	end

	function v._interfaces()
		return defineInterfaces(data)
	end

	devAssert2(typeof(data.name) == "string", "Must provide name.")
	devAssert2(
		data.resolveType == nil or typeof(data.resolveType) == "function",
		("%s must provide \"resolveType\" as a function, but got: %s."):format(v.name, inspect2(data.resolveType))
	)

	return (setmetatable(v, class5))
end

function class5:getFields()
	if typeof(self._fields) == "function" then
		self._fields = self._fields()
	end

	return self._fields
end

function class5:getInterfaces()
	if typeof(self._interfaces) == "function" then
		self._interfaces = self._interfaces()
	end

	return self._interfaces
end

function class5:toConfig()
	return {
		name = self.name,
		description = self.description,
		interfaces = self:getInterfaces(),
		fields = fieldsToFieldsConfig(self:getFields()),
		resolveType = self.resolveType,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {}
	}
end

function class5:__tostring()
	return self:toString()
end

function class5:toString()
	return self.name
end

function class5:toJSON()
	return self:toString()
end

class6.__index = class6

function class6.new(data)
	local v = {}
	v.name = data.name
	v.description = data.description
	v.resolveType = data.resolveType
	local extensions

	if data.extensions then
		extensions = toObjMap2(data.extensions)
	end

	v.extensions = extensions
	v.astNode = data.astNode
	v.extensionASTNodes = undefineIfEmpty(data.extensionASTNodes) -- inferred equivalent call

	function v._types()
		return defineTypes(data)
	end

	devAssert2(typeof(data.name) == "string", "Must provide name.")
	devAssert2(
		data.resolveType == nil or typeof(data.resolveType) == "function",
		("%s must provide \"resolveType\" as a function, but got: %s."):format(v.name, inspect2(data.resolveType))
	)

	return (setmetatable(v, class6))
end

function class6:getTypes()
	if typeof(self._types) == "function" then
		self._types = self._types()
	end

	return self._types
end

function class6:toConfig()
	return {
		name = self.name,
		description = self.description,
		types = self:getTypes(),
		resolveType = self.resolveType,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {}
	}
end

function class6:__tostring()
	return self:toString()
end

function class6:toString()
	return self.name
end

function class6:toJSON()
	return self:toString()
end

defineTypes = function(data)
	local types = data.types
	types = resolveThunk(types) -- inferred equivalent call
	devAssert2(
		Array.isArray(types),
		("Must provide Array of types or a function which returns such an array for Union %s."):format(data.name)
	)

	return types
end

class7.__index = class7

function class7.new(data)
	local v = {}
	v.name = data.name
	v.description = data.description
	local extensions

	if data.extensions then
		extensions = toObjMap2(data.extensions)
	end

	v.extensions = extensions
	v.astNode = data.astNode
	v.extensionASTNodes = undefineIfEmpty(data.extensionASTNodes) -- inferred equivalent call

	v._values = defineEnumValues(v.name, data.values)
	v._valueLookup = {}

	Array.forEach(v._values, function(p)
		if p.value == p.value then
			v._valueLookup[p.value] = p
		else
			v._valueLookup[frozen] = p
		end
	end)
	v._nameLookup = keyMap2(v._values, function(p)
		return p.name
	end)

	devAssert2(typeof(data.name) == "string", "Must provide name.")

	return (setmetatable(v, class7))
end

function class7:getValues()
	return self._values
end

function class7:getValue(p: string)
	return self._nameLookup[p]
end

function class7:serialize(p)
	local v

	if p == p then
		v = self._valueLookup[p]
	else
		v = self._valueLookup[frozen]
	end

	if v == nil then
		error(graphQLError.new(("Enum \"%s\" cannot represent value: %s"):format(self.name, inspect2(p))))
	end

	return v.name
end

function class7:parseValue(value)
	if typeof(value) ~= "string" then
		local v = inspect2(value)
		error(graphQLError.new(("Enum \"%s\" cannot represent non-string value: %s." .. didYouMeanEnumValue(self, v)):format(
			self.name,
			v
		)))
	end

	local value2 = self:getValue(value)

	if value2 == nil then
		error(graphQLError.new(("Value \"%s\" does not exist in \"%s\" enum."):format(value, self.name) .. didYouMeanEnumValue(self, value)))
	end

	return value2.value
end

function class7:parseLiteral(p, _)
	if p.kind ~= kind.ENUM then
		local Print2 = Print(p)
		error(graphQLError.new(
			("Enum \"%s\" cannot represent non-enum value: %s."):format(self.name, Print2) .. didYouMeanEnumValue(self, Print2),
			p
		))
	end

	local value = self:getValue(p.value)

	if value == nil then
		local Print2 = Print(p)
		error(graphQLError.new(
			("Value \"%s\" does not exist in \"%s\" enum."):format(Print2, self.name) .. didYouMeanEnumValue(self, Print2),
			p
		))
	end

	return value.value
end

function class7:toConfig()
	local values = keyValMap2(self:getValues(), function(p)
		return p.name
	end, function(data)
		return {
			description = data.description,
			value = data.value,
			deprecationReason = data.deprecationReason,
			extensions = data.extensions,
			astNode = data.astNode
		}
	end)

	return {
		name = self.name,
		description = self.description,
		values = values,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {}
	}
end

function class7:__tostring()
	return self:toString()
end

function class7:toString()
	return self.name
end

function class7:toJSON()
	return self:toString()
end

didYouMeanEnumValue = function(object, p: string)
	return didYouMean2("the enum value", (suggestionList2(p, (Array.map(object:getValues(), function(p2)
		return p2.name
	end)))))
end

defineEnumValues = function(name: string, values)
	devAssert2(
		isPlainObj(values) or instanceOf(values, Map),
		("%s values must be an object with value names as keys."):format((tostring(name)))
	)

	local entries = coerceToMap(values):entries()

	return Array.map(entries, function(list)
		local v = list[1]
		local item = list[2]

		devAssert2(
			isPlainObj(item),
			("%s.%s must refer to an object with a \"value\" key "):format(tostring(name), (tostring(v))) .. ("representing an internal value but got: %s."):format(inspect2(item))
		)

		local v2 = {
			name = tostring(v),
			description = item.description,
			value = 0,
			deprecationReason = 0,
			extensions = 0,
			astNode = 0
		}

		if item.value ~= nil then
			v = item.value
		end

		v2.value = v
		v2.deprecationReason = item.deprecationReason
		local extensions

		if item.extensions then
			extensions = toObjMap2(item.extensions)
		end

		v2.extensions = extensions
		v2.astNode = item.astNode
		return v2
	end)
end

class8.__index = class8

function class8.new(data)
	local v = {}
	v.name = data.name
	v.description = data.description
	local extensions

	if data.extensions then
		extensions = toObjMap2(data.extensions)
	end

	v.extensions = extensions
	v.astNode = data.astNode
	v.extensionASTNodes = undefineIfEmpty(data.extensionASTNodes) -- inferred equivalent call

	function v._fields()
		return defineInputFieldMap(data)
	end

	devAssert2(typeof(data.name) == "string", "Must provide name.")
	return (setmetatable(v, class8))
end

function class8:getFields()
	if typeof(self._fields) == "function" then
		self._fields = self._fields()
	end

	return self._fields
end

function class8:toConfig()
	local fields = mapValueOrdered2(self:getFields(), function(data)
		return {
			description = data.description,
			type = data.type,
			defaultValue = data.defaultValue,
			extensions = data.extensions,
			astNode = data.astNode
		}
	end)

	return {
		name = self.name,
		description = self.description,
		fields = fields,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {}
	}
end

function class8:__tostring()
	return self:toString()
end

function class8:toString()
	return self.name
end

function class8:toJSON()
	return self:toString()
end

defineInputFieldMap = function(data)
	local thunk = resolveThunk(data.fields) -- inferred equivalent call

	devAssert2(
		isPlainObj(thunk) or instanceOf(thunk, Map),
		("%s fields must be an object with field names as keys or a function which returns such an object."):format(data.name)
	)

	return mapValueOrdered2(coerceToMap(thunk), function(data2, name)
		devAssert2(
			data2.resolve == nil,
			("%s.%s field has a resolve property, but Input Types cannot define resolvers."):format(data.name, name)
		)

		local v = {
			name = name,
			description = data2.description,
			type = data2.type,
			defaultValue = data2.defaultValue,
			deprecationReason = data2.deprecationReason,
			extensions = 0,
			astNode = 0
		}
		local extensions

		if data2.extensions then
			extensions = toObjMap2(data2.extensions)
		end

		v.extensions = extensions
		v.astNode = data2.astNode
		return v
	end)
end

local function isRequiredInputField(p)
	return isNonNullType(p.type) and p.defaultValue == nil
end

local _ = {
	new = function()
		return {}
	end
}

return {
	GraphQLList = class,
	GraphQLNonNull = class2,
	GraphQLScalarType = class3,
	GraphQLObjectType = class4,
	GraphQLInterfaceType = class5,
	GraphQLUnionType = class6,
	GraphQLEnumType = class7,
	GraphQLInputObjectType = class8,
	isType = isType,
	assertType = assertType,
	isScalarType = isScalarType,
	assertScalarType = assertScalarType,
	isObjectType = isObjectType,
	assertObjectType = assertObjectType,
	isInterfaceType = isInterfaceType,
	assertInterfaceType = assertInterfaceType,
	isUnionType = isUnionType,
	assertUnionType = assertUnionType,
	isEnumType = isEnumType,
	assertEnumType = assertEnumType,
	isInputObjectType = isInputObjectType,
	assertInputObjectType = assertInputObjectType,
	isListType = isListType,
	assertListType = assertListType,
	isNonNullType = isNonNullType,
	assertNonNullType = assertNonNullType,
	isInputType = isInputType,
	assertInputType = assertInputType,
	isOutputType = isOutputType,
	assertOutputType = assertOutputType,
	isLeafType = isLeafType,
	assertLeafType = assertLeafType,
	isCompositeType = isCompositeType,
	assertCompositeType = assertCompositeType,
	isAbstractType = isAbstractType,
	assertAbstractType = assertAbstractType,
	isWrappingType = isWrappingType,
	assertWrappingType = assertWrappingType,
	isNullableType = isNullableType,
	assertNullableType = assertNullableType,
	getNullableType = getNullableType,
	isNamedType = isNamedType,
	assertNamedType = assertNamedType,
	getNamedType = getNamedType,
	argsToArgsConfig = argsToArgsConfig,
	isRequiredArgument = isRequiredArgument,
	isRequiredInputField = isRequiredInputField,
	NULL = null
}
