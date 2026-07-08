local ParentParent = script.Parent.Parent
local luaUtils = ParentParent.luaUtils
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local null = require(luaUtils.null)
local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish
local inspect = require(ParentParent.jsutils.inspect).inspect
local devAssert = require(ParentParent.jsutils.devAssert).devAssert
local keyValMap = require(ParentParent.jsutils.keyValMap).keyValMap
local isObjectLike = require(ParentParent.jsutils.isObjectLike).isObjectLike
local parseValue = require(ParentParent.language.parser).parseValue
local schema = require(ParentParent.type.schema)
local definition = require(ParentParent.type.definition)
local GraphQLSchema = schema.GraphQLSchema
local GraphQLDirective = require(ParentParent.type.directives).GraphQLDirective
local specifiedScalarTypes = require(ParentParent.type.scalars).specifiedScalarTypes
local introspection = require(ParentParent.type.introspection)
local introspectionTypes = introspection.introspectionTypes
local TypeKind = introspection.TypeKind
local isInputType = definition.isInputType
local isOutputType = definition.isOutputType
local GraphQLList = definition.GraphQLList
local GraphQLNonNull = definition.GraphQLNonNull
local GraphQLScalarType = definition.GraphQLScalarType
local GraphQLObjectType = definition.GraphQLObjectType
local GraphQLInterfaceType = definition.GraphQLInterfaceType
local GraphQLUnionType = definition.GraphQLUnionType
local GraphQLEnumType = definition.GraphQLEnumType
local GraphQLInputObjectType = definition.GraphQLInputObjectType
local assertNullableType = definition.assertNullableType
local assertObjectType = definition.assertObjectType
local assertInterfaceType = definition.assertInterfaceType

require(script.Parent.getIntrospectionQuery)

local valueFromAST = require(script.Parent.valueFromAST).valueFromAST

return {
	buildClientSchema = function(p1, p2) -- line: 100
		-- upvalues: TypeKind (copy), Error (copy), GraphQLList (copy), GraphQLNonNull (copy), assertNullableType (copy), isNillish2 (copy), inspect (copy), assertObjectType (copy), assertInterfaceType (copy), isNotNillish (copy), GraphQLScalarType (copy), Array (copy), GraphQLObjectType (copy), GraphQLInterfaceType (copy), GraphQLUnionType (copy), GraphQLEnumType (copy), keyValMap (copy), GraphQLInputObjectType (copy), isOutputType (copy), isInputType (copy), valueFromAST (copy), parseValue (copy), GraphQLDirective (copy), devAssert (copy), isObjectLike (copy), specifiedScalarTypes (copy), introspectionTypes (copy), null (copy), GraphQLSchema (copy)
		local getNamedType = nil
		local buildScalarDef = nil
		local buildObjectDef = nil
		local buildInterfaceDef = nil
		local buildUnionDef = nil
		local buildEnumDef = nil
		local buildInputObjectDef = nil
		local buildFieldDefMap = nil
		local buildField = nil
		local buildInputValueDefMap = nil
		local buildInputValue = nil
		local u51 = nil

		local function getType(p3) -- line: 132
			-- upvalues: TypeKind (copy), Error (copy), GraphQLList (copy), getType (ref), GraphQLNonNull (copy), assertNullableType (copy), getNamedType (ref)
			if p3.kind == TypeKind.LIST then
				local ofType = p3.ofType

				if not ofType then
					error(Error.new("Decorated type deeper than introspection query."))
				end

				return GraphQLList.new(getType(ofType))
			end

			if p3.kind == TypeKind.NON_NULL then
				local ofType = p3.ofType

				if not ofType then
					error(Error.new("Decorated type deeper than introspection query."))
				end

				local v68 = getType(ofType)

				return GraphQLNonNull.new(assertNullableType(v68))
			end

			return getNamedType(p3)
		end

		function getNamedType(p4) -- line: 155
			-- upvalues: isNillish2 (copy), Error (copy), inspect (copy), u51 (ref)
			local name = p4.name

			if isNillish2(name) then
				error(Error.new(("Unknown type reference: %s."):format(inspect(p4))))
			end

			local v71 = u51:get(name)

			if isNillish2(v71) then
				error(Error.new(("Invalid or incomplete schema, unknown type: %s. Ensure that a full introspection query is used in order to build a client schema."):format(name)))
			end

			return v71
		end

		local function getObjectType(p5) -- line: 176
			-- upvalues: assertObjectType (copy), getNamedType (ref)
			return assertObjectType(getNamedType(p5))
		end
		local function getInterfaceType(p6) -- line: 182
			-- upvalues: assertInterfaceType (copy), getNamedType (ref)
			return assertInterfaceType(getNamedType(p6))
		end
		local function buildType(p7) -- line: 190
			-- upvalues: isNotNillish (copy), TypeKind (copy), buildScalarDef (ref), buildObjectDef (ref), buildInterfaceDef (ref), buildUnionDef (ref), buildEnumDef (ref), buildInputObjectDef (ref), inspect (copy), Error (copy)
			if isNotNillish(p7) and (isNotNillish(p7.name) and isNotNillish(p7.kind)) then
				if p7.kind == TypeKind.SCALAR then
					return buildScalarDef(p7)
				end

				if p7.kind == TypeKind.OBJECT then
					return buildObjectDef(p7)
				end

				if p7.kind == TypeKind.INTERFACE then
					return buildInterfaceDef(p7)
				end

				if p7.kind == TypeKind.UNION then
					return buildUnionDef(p7)
				end

				if p7.kind == TypeKind.ENUM then
					return buildEnumDef(p7)
				end

				if p7.kind == TypeKind.INPUT_OBJECT then
					return buildInputObjectDef(p7)
				end
			end

			local v75 = inspect(p7)

			error(Error.new(("Invalid or incomplete introspection result. Ensure that a full introspection query is used in order to build a client schema: %s."):format(v75)))
		end

		function buildScalarDef(p8) -- line: 217
			-- upvalues: GraphQLScalarType (copy)
			return GraphQLScalarType.new({
				name = p8.name,
				description = p8.description,
				specifiedByUrl = p8.specifiedByUrl
			})
		end

		local function buildImplementationsList(p9) -- line: 225
			-- upvalues: TypeKind (copy), inspect (copy), Error (copy), Array (copy), getInterfaceType (ref)
			if p9.interfaces == nil and p9.kind == TypeKind.INTERFACE then
				return {}
			end

			if not p9.interfaces then
				local v78 = inspect(p9)

				error(Error.new(("Introspection result missing interfaces: %s."):format(v78)))
			end

			return Array.map(p9.interfaces, getInterfaceType)
		end

		function buildObjectDef(p10) -- line: 251
			-- upvalues: GraphQLObjectType (copy), buildImplementationsList (ref), buildFieldDefMap (ref)
			return GraphQLObjectType.new({
				name = p10.name,
				description = p10.description,
				interfaces = function() -- line: 255
					-- upvalues: buildImplementationsList (ref), p10 (copy)
					return buildImplementationsList(p10)
				end,
				fields = function() -- line: 258
					-- upvalues: buildFieldDefMap (ref), p10 (copy)
					return buildFieldDefMap(p10)
				end
			})
		end
		function buildInterfaceDef(p11) -- line: 264
			-- upvalues: GraphQLInterfaceType (copy), buildImplementationsList (ref), buildFieldDefMap (ref)
			return GraphQLInterfaceType.new({
				name = p11.name,
				description = p11.description,
				interfaces = function() -- line: 270
					-- upvalues: buildImplementationsList (ref), p11 (copy)
					return buildImplementationsList(p11)
				end,
				fields = function() -- line: 273
					-- upvalues: buildFieldDefMap (ref), p11 (copy)
					return buildFieldDefMap(p11)
				end
			})
		end
		function buildUnionDef(p12) -- line: 279
			-- upvalues: inspect (copy), Error (copy), GraphQLUnionType (copy), Array (copy), getObjectType (ref)
			if not p12.possibleTypes then
				local v82 = inspect(p12)

				error(Error.new(("Introspection result missing possibleTypes: %s."):format(v82)))
			end

			return GraphQLUnionType.new({
				name = p12.name,
				description = p12.description,
				types = function() -- line: 294
					-- upvalues: Array (copy), p12 (copy), getObjectType (ref)
					return Array.map(p12.possibleTypes, getObjectType)
				end
			})
		end
		function buildEnumDef(p13) -- line: 300
			-- upvalues: inspect (copy), Error (copy), GraphQLEnumType (copy), keyValMap (copy)
			if not p13.enumValues then
				local v84 = inspect(p13)

				error(Error.new(("Introspection result missing enumValues: %s."):format(v84)))
			end

			return GraphQLEnumType.new({
				name = p13.name,
				description = p13.description,
				values = keyValMap(p13.enumValues, function(p14) -- line: 312
					return p14.name
				end, function(p15) -- line: 314
					return {
						description = p15.description,
						deprecationReason = p15.deprecationReason
					}
				end)
			})
		end
		function buildInputObjectDef(p16) -- line: 324
			-- upvalues: inspect (copy), Error (copy), GraphQLInputObjectType (copy), buildInputValueDefMap (ref)
			if not p16.inputFields then
				local v86 = inspect(p16)

				error(Error.new(("Introspection result missing inputFields: %s."):format(v86)))
			end

			return GraphQLInputObjectType.new({
				name = p16.name,
				description = p16.description,
				fields = function() -- line: 340
					-- upvalues: buildInputValueDefMap (ref), p16 (copy)
					return buildInputValueDefMap(p16.inputFields)
				end
			})
		end
		function buildFieldDefMap(p17) -- line: 346
			-- upvalues: Error (copy), inspect (copy), keyValMap (copy), buildField (ref)
			if not p17.fields then
				error(Error.new(("Introspection result missing fields: %s."):format(inspect(p17))))
			end

			return keyValMap(p17.fields, function(p18) -- line: 358
				return p18.name
			end, buildField)
		end
		function buildField(p19) -- line: 363
			-- upvalues: getType (ref), isOutputType (copy), inspect (copy), Error (copy), buildInputValueDefMap (ref)
			local v89 = getType(p19.type)

			if not isOutputType(v89) then
				local v90 = inspect(v89)

				error(Error.new(("Introspection must provide output type for fields, but received: %s."):format(v90)))
			end

			if not p19.args then
				local v91 = inspect(p19)

				error(Error.new(("Introspection result missing field args: %s."):format(v91)))
			end

			return {
				description = p19.description,
				deprecationReason = p19.deprecationReason,
				type = v89,
				args = buildInputValueDefMap(p19.args)
			}
		end
		function buildInputValueDefMap(p20) -- line: 394
			-- upvalues: keyValMap (copy), buildInputValue (ref)
			return keyValMap(p20, function(p21) -- line: 395
				return p21.name
			end, buildInputValue)
		end
		function buildInputValue(p22) -- line: 400
			-- upvalues: getType (ref), isInputType (copy), inspect (copy), Error (copy), isNotNillish (copy), valueFromAST (copy), parseValue (copy)
			local v94 = getType(p22.type)

			if not isInputType(v94) then
				local v95 = inspect(v94)

				error(Error.new(("Introspection must provide input type for arguments, but received: %s."):format(v95)))
			end

			local v96 = if not isNotNillish(p22.defaultValue) then nil else valueFromAST(parseValue(p22.defaultValue), v94)

			return {
				description = p22.description,
				type = v94,
				defaultValue = v96,
				deprecationReason = p22.deprecationReason
			}
		end

		local function buildDirective(p23) -- line: 429
			-- upvalues: inspect (copy), Error (copy), GraphQLDirective (copy), Array (copy), buildInputValueDefMap (ref)
			if not p23.args then
				local v98 = inspect(p23)

				error(Error.new(("Introspection result missing directive args: %s."):format(v98)))
			end

			if not p23.locations then
				local v99 = inspect(p23)

				error(Error.new(("Introspection result missing directive locations: %s."):format(v99)))
			end

			return GraphQLDirective.new({
				name = p23.name,
				description = p23.description,
				isRepeatable = p23.isRepeatable,
				locations = Array.slice(p23.locations),
				args = buildInputValueDefMap(p23.args)
			})
		end

		devAssert(isObjectLike(p1) and isObjectLike(p1.__schema), ("Invalid or incomplete introspection result. Ensure that you are passing \"data\" property of introspection response and no \"errors\" was returned alongside: %s."):format(inspect(p1)))

		local __schema = p1.__schema

		u51 = keyValMap(__schema.types, function(p24) -- line: 471
			return p24.name
		end, function(p25) -- line: 473
			-- upvalues: buildType (ref)
			return buildType(p25)
		end)

		for _, v in ipairs(Array.concat(specifiedScalarTypes, introspectionTypes)) do
			if u51:get(v.name) then
				u51:set(v.name, v)
			end
		end

		local v61 = if not isNotNillish(__schema.queryType) then null else getObjectType(__schema.queryType)
		local v62 = if not isNotNillish(__schema.mutationType) then null else getObjectType(__schema.mutationType)
		local v63 = if not isNotNillish(__schema.subscriptionType) then null else getObjectType(__schema.subscriptionType)
		local v64 = if not isNotNillish(__schema.directives) then {} else Array.map(__schema.directives, buildDirective)

		return GraphQLSchema.new({
			description = __schema.description,
			query = v61,
			mutation = v62,
			subscription = v63,
			types = u51:values(),
			directives = v64,
			assumeValid = if not p2 then nil else p2.assumeValid
		})
	end
}
