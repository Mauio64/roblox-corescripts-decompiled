local parent = script.Parent.Parent
local luaUtils = parent.luaUtils
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error

local null = require(luaUtils.null)

local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish

local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local devAssert = require(parent.jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local keyValMap = require(parent.jsutils.keyValMap)
local keyValMap2 = keyValMap.keyValMap
local isObjectLike = require(parent.jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike

local parser = require(parent.language.parser)
local parseValue = parser.parseValue

local schema = require(parent.type.schema)

local definition = require(parent.type.definition)

local graphQLSchema = schema.GraphQLSchema
local directives = require(parent.type.directives)
local graphQLDirective = directives.GraphQLDirective
local scalars = require(parent.type.scalars)
local specifiedScalarTypes = scalars.specifiedScalarTypes
local introspection = require(parent.type.introspection)
local introspectionTypes = introspection.introspectionTypes
local typeKind = introspection.TypeKind
local isInputType = definition.isInputType
local isOutputType = definition.isOutputType
local graphQLList = definition.GraphQLList
local graphQLNonNull = definition.GraphQLNonNull

local graphQLScalarType = definition.GraphQLScalarType

local graphQLObjectType = definition.GraphQLObjectType

local graphQLInterfaceType = definition.GraphQLInterfaceType

local graphQLUnionType = definition.GraphQLUnionType

local graphQLEnumType = definition.GraphQLEnumType

local graphQLInputObjectType = definition.GraphQLInputObjectType
local assertNullableType = definition.assertNullableType
local assertObjectType = definition.assertObjectType
local assertInterfaceType = definition.assertInterfaceType

require(script.Parent.getIntrospectionQuery)

local valueFromAST = require(script.Parent.valueFromAST)
local valueFromAST2 = valueFromAST.valueFromAST

return {
	buildClientSchema = function(p, p2)
		local getNamedType

		local buildScalarDef

		local buildObjectDef
		local buildInterfaceDef
		local buildUnionDef
		local buildEnumDef
		local buildInputObjectDef
		local buildFieldDefMap
		local buildField
		local buildInputValueDefMap
		local buildInputValue

		local v = nil
		local function getType(kind)
			if kind.kind == typeKind.LIST then
				local ofType = kind.ofType

				if not ofType then
					error(Error.new("Decorated type deeper than introspection query."))
				end

				return graphQLList.new(getType(ofType))
			else
				if kind.kind ~= typeKind.NON_NULL then
					return getNamedType(kind)
				end

				local ofType = kind.ofType

				if not ofType then
					error(Error.new("Decorated type deeper than introspection query."))
				end

				local v2 = getType(ofType)

				return graphQLNonNull.new(assertNullableType(v2))
			end
		end

		getNamedType = function(p3)
			local name = p3.name

			if isNillish2(name) then
				error(Error.new(("Unknown type reference: %s."):format(inspect2(p3))))
			end

			local namedType = v:get(name)

			if isNillish2(namedType) then
				error(Error.new(("Invalid or incomplete schema, unknown type: %s. Ensure that a full introspection query is used in order to build a client schema."):format(name)))
			end

			return namedType
		end

		local function getObjectType(p3)
			return assertObjectType(getNamedType(p3))
		end

		local function getInterfaceType(p3)
			return assertInterfaceType(getNamedType(p3))
		end

		local function buildType(p3)
			if isNotNillish(p3) and isNotNillish(p3.name) and isNotNillish(p3.kind) then
				if p3.kind == typeKind.SCALAR then
					return buildScalarDef(p3)
				end

				if p3.kind == typeKind.OBJECT then
					return buildObjectDef(p3)
				end

				if p3.kind == typeKind.INTERFACE then
					return buildInterfaceDef(p3)
				end

				if p3.kind == typeKind.UNION then
					return buildUnionDef(p3)
				end

				if p3.kind == typeKind.ENUM then
					return buildEnumDef(p3)
				end

				if p3.kind == typeKind.INPUT_OBJECT then
					return buildInputObjectDef(p3)
				end
			end

			local v2 = inspect2(p3)
			error(Error.new(("Invalid or incomplete introspection result. Ensure that a full introspection query is used in order to build a client schema: %s."):format(v2)))
		end

		buildScalarDef = function(data)
			return graphQLScalarType.new({
				name = data.name,
				description = data.description,
				specifiedByUrl = data.specifiedByUrl
			})
		end

		local function buildImplementationsList(p3)
			if p3.interfaces == nil and p3.kind == typeKind.INTERFACE then
				return {}
			end

			if not p3.interfaces then
				local v2 = inspect2(p3)
				error(Error.new(("Introspection result missing interfaces: %s."):format(v2)))
			end

			return Array.map(p3.interfaces, getInterfaceType)
		end

		buildObjectDef = function(p3)
			return graphQLObjectType.new({
				name = p3.name,
				description = p3.description,
				interfaces = function()
					return buildImplementationsList(p3)
				end,
				fields = function()
					return buildFieldDefMap(p3)
				end
			})
		end

		buildInterfaceDef = function(p3)
			return graphQLInterfaceType.new({
				name = p3.name,
				description = p3.description,
				interfaces = function()
					return buildImplementationsList(p3)
				end,
				fields = function()
					return buildFieldDefMap(p3)
				end
			})
		end

		buildUnionDef = function(data)
			if not data.possibleTypes then
				local v2 = inspect2(data)
				error(Error.new(("Introspection result missing possibleTypes: %s."):format(v2)))
			end

			return graphQLUnionType.new({
				name = data.name,
				description = data.description,
				types = function()
					return Array.map(data.possibleTypes, getObjectType)
				end
			})
		end

		buildEnumDef = function(data)
			if not data.enumValues then
				local v2 = inspect2(data)
				error(Error.new(("Introspection result missing enumValues: %s."):format(v2)))
			end

			return graphQLEnumType.new({
				name = data.name,
				description = data.description,
				values = keyValMap2(data.enumValues, function(p3)
					return p3.name
				end, function(p3)
					return {
						description = p3.description,
						deprecationReason = p3.deprecationReason
					}
				end)
			})
		end

		buildInputObjectDef = function(data)
			if not data.inputFields then
				local v2 = inspect2(data)
				error(Error.new(("Introspection result missing inputFields: %s."):format(v2)))
			end

			return graphQLInputObjectType.new({
				name = data.name,
				description = data.description,
				fields = function()
					return buildInputValueDefMap(data.inputFields)
				end
			})
		end

		buildFieldDefMap = function(p3)
			if not p3.fields then
				error(Error.new(("Introspection result missing fields: %s."):format(inspect2(p3))))
			end

			return keyValMap2(p3.fields, function(p4)
				return p4.name
			end, buildField)
		end

		buildField = function(data)
			local kind = getType(data.type)

			if not isOutputType(kind) then
				local v2 = inspect2(kind)
				error(Error.new(("Introspection must provide output type for fields, but received: %s."):format(v2)))
			end

			if not data.args then
				local v2 = inspect2(data)

				error(Error.new(("Introspection result missing field args: %s."):format(v2)))
			end

			return {
				description = data.description,
				deprecationReason = data.deprecationReason,
				type = kind,
				args = buildInputValueDefMap(data.args)
			}
		end

		buildInputValueDefMap = function(p3)
			return keyValMap2(p3, function(p4)
				return p4.name
			end, buildInputValue)
		end

		buildInputValue = function(data)
			local kind = getType(data.type)

			if not isInputType(kind) then
				local v2 = inspect2(kind)
				error(Error.new(("Introspection must provide input type for arguments, but received: %s."):format(v2)))
			end

			local defaultValue

			if isNotNillish(data.defaultValue) then
				defaultValue = valueFromAST2(parseValue(data.defaultValue), kind)
			end

			return {
				description = data.description,
				type = kind,
				defaultValue = defaultValue,
				deprecationReason = data.deprecationReason
			}
		end

		local function buildDirective(data)
			if not data.args then
				local v2 = inspect2(data)

				error(Error.new(("Introspection result missing directive args: %s."):format(v2)))
			end

			if not data.locations then
				local v2 = inspect2(data)
				error(Error.new(("Introspection result missing directive locations: %s."):format(v2)))
			end

			return graphQLDirective.new({
				name = data.name,
				description = data.description,
				isRepeatable = data.isRepeatable,
				locations = Array.slice(data.locations),
				args = buildInputValueDefMap(data.args)
			})
		end

		devAssert2(
			isObjectLike2(p) and isObjectLike2(p.__schema),
			("Invalid or incomplete introspection result. Ensure that you are passing \"data\" property of introspection response and no \"errors\" was returned alongside: %s."):format(inspect2(p))
		)

		local __schema = p.__schema

		v = keyValMap2(__schema.types, function(p3)
			return p3.name
		end, function(p3)
			return buildType(p3)
		end)

		for _, v2 in ipairs(Array.concat(specifiedScalarTypes, introspectionTypes)) do
			local name = v2.name

			if not v:get(name) then
				continue
			end

			local name2 = v2.name
			v:set(name2, v2)
		end

		local query

		if isNotNillish(__schema.queryType) then
			query = getObjectType(__schema.queryType)
		else
			query = null
		end

		local mutation

		if isNotNillish(__schema.mutationType) then
			mutation = getObjectType(__schema.mutationType)
		else
			mutation = null
		end

		local subscription

		if isNotNillish(__schema.subscriptionType) then
			subscription = getObjectType(__schema.subscriptionType)
		else
			subscription = null
		end

		local directives2 = not isNotNillish(__schema.directives) and {}
			or Array.map(__schema.directives, buildDirective)

		local new = graphQLSchema.new
		local v2 = {
			description = __schema.description,
			query = query,
			mutation = mutation,
			subscription = subscription,
			types = v:values(),
			directives = directives2,
			assumeValid = 0
		}
		local assumeValid

		if p2 then
			assumeValid = p2.assumeValid
		end

		v2.assumeValid = assumeValid
		return new(v2)
	end
}
