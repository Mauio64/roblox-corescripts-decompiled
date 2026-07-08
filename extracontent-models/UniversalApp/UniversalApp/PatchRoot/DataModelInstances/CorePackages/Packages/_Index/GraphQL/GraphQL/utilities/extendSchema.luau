local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local coerceToMap = LuauPolyfill.coerceToMap
local mapValueOrdered = require(ParentParent.luaUtils.mapValueOrdered).mapValueOrdered

require(ParentParent.luaUtils.null)

local jsutils = ParentParent.jsutils
local keyMap = require(jsutils.keyMap).keyMap
local inspect = require(jsutils.inspect).inspect
local devAssert = require(jsutils.devAssert).devAssert

require(jsutils.ObjMap)
require(ParentParent.language.ast)

local Kind = require(ParentParent.language.kinds).Kind
local predicates = require(ParentParent.language.predicates)
local isTypeDefinitionNode = predicates.isTypeDefinitionNode
local isTypeExtensionNode = predicates.isTypeExtensionNode
local assertValidSDLExtension = require(ParentParent.validation.validate).assertValidSDLExtension
local getDirectiveValues = require(ParentParent.execution.values).getDirectiveValues
local type = ParentParent.type
local schema = require(type.schema)
local assertSchema = schema.assertSchema
local GraphQLSchema = schema.GraphQLSchema
local scalars = require(type.scalars)
local specifiedScalarTypes = scalars.specifiedScalarTypes
local isSpecifiedScalarType = scalars.isSpecifiedScalarType
local introspection = require(type.introspection)
local introspectionTypes = introspection.introspectionTypes
local isIntrospectionType = introspection.isIntrospectionType
local directives = require(type.directives)
local GraphQLDirective = directives.GraphQLDirective
local GraphQLDeprecatedDirective = directives.GraphQLDeprecatedDirective
local GraphQLSpecifiedByDirective = directives.GraphQLSpecifiedByDirective
local definition = require(type.definition)
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local GraphQLList = definition.GraphQLList
local GraphQLNonNull = definition.GraphQLNonNull
local GraphQLScalarType = definition.GraphQLScalarType
local GraphQLObjectType = definition.GraphQLObjectType
local GraphQLInterfaceType = definition.GraphQLInterfaceType
local GraphQLUnionType = definition.GraphQLUnionType
local GraphQLEnumType = definition.GraphQLEnumType
local GraphQLInputObjectType = definition.GraphQLInputObjectType
local valueFromAST = require(script.Parent.valueFromAST).valueFromAST
local u52 = nil
local getDeprecationReason = nil
local getSpecifiedByUrl = nil

function extendSchemaImpl(p1, p2, p3) -- line: 175
	-- upvalues: Map (copy), Kind (copy), isTypeDefinitionNode (copy), isTypeExtensionNode (copy), Array (copy), isListType (copy), GraphQLList (copy), isNonNullType (copy), GraphQLNonNull (copy), GraphQLDirective (copy), Object (copy), mapValueOrdered (copy), coerceToMap (copy), isIntrospectionType (copy), isSpecifiedScalarType (copy), isScalarType (copy), isObjectType (copy), isInterfaceType (copy), isUnionType (copy), isEnumType (copy), isInputObjectType (copy), inspect (copy), GraphQLInputObjectType (copy), GraphQLEnumType (copy), getSpecifiedByUrl (ref), GraphQLScalarType (copy), GraphQLObjectType (copy), GraphQLInterfaceType (copy), GraphQLUnionType (copy), u52 (ref), Error (copy), getDeprecationReason (ref), valueFromAST (copy)
	local t1 = {}
	local v64 = Map.new()
	local t2 = {}
	local v66 = nil
	local t3 = {}

	for _, v in ipairs(p2.definitions) do
		if v.kind == Kind.SCHEMA_DEFINITION then
			v66 = v
		elseif v.kind == Kind.SCHEMA_EXTENSION then
			table.insert(t3, v)
		elseif isTypeDefinitionNode(v) then
			table.insert(t1, v)
		elseif isTypeExtensionNode(v) then
			local value = v.name.value
			local v71 = v64:get(value)

			v64:set(value, if not v71 then { v } else Array.concat(v71, { v }))
		elseif v.kind == Kind.DIRECTIVE_DEFINITION then
			table.insert(t2, v)
		end
	end

	if #v64:keys() == 0 and #t1 == 0 and #t2 == 0 and #t3 == 0 and v66 == nil then
		return p1
	end

	local v72 = Map.new()
	local replaceNamedType = nil
	local extendArg = nil
	local extendField = nil
	local extendScalarType = nil
	local extendObjectType = nil
	local extendInterfaceType = nil
	local extendUnionType = nil
	local extendEnumType = nil
	local extendInputObjectType = nil
	local buildInputFieldMap = nil
	local buildEnumValueMap = nil
	local buildInterfaces = nil
	local buildUnionTypes = nil
	local getNamedType = nil
	local buildArgumentMap = nil
	local buildFieldMap = nil

	local function replaceType(p4) -- line: 279
		-- upvalues: isListType (copy), GraphQLList (copy), replaceType (copy), isNonNullType (copy), GraphQLNonNull (copy), replaceNamedType (ref)
		if isListType(p4) then
			return GraphQLList.new(replaceType(p4.ofType))
		end

		if isNonNullType(p4) then
			return GraphQLNonNull.new(replaceType(p4.ofType))
		end

		return replaceNamedType(p4)
	end

	function replaceNamedType(p5) -- line: 291
		-- upvalues: v72 (copy)
		return v72:get(p5.name)
	end

	local function replaceDirective(p6) -- line: 299
		-- upvalues: GraphQLDirective (copy), Object (copy), mapValueOrdered (copy), coerceToMap (copy), extendArg (ref)
		local v113 = p6:toConfig()

		return GraphQLDirective.new(Object.assign({}, v113, {
			args = mapValueOrdered(coerceToMap(v113.args), extendArg)
		}))
	end
	local function extendNamedType(p7) -- line: 310
		-- upvalues: isIntrospectionType (copy), isSpecifiedScalarType (copy), isScalarType (copy), extendScalarType (ref), isObjectType (copy), extendObjectType (ref), isInterfaceType (copy), extendInterfaceType (ref), isUnionType (copy), extendUnionType (ref), isEnumType (copy), extendEnumType (ref), isInputObjectType (copy), extendInputObjectType (ref), inspect (copy)
		if isIntrospectionType(p7) or isSpecifiedScalarType(p7) then
			return p7
		end

		if isScalarType(p7) then
			return extendScalarType(p7)
		end

		if isObjectType(p7) then
			return extendObjectType(p7)
		end

		if isInterfaceType(p7) then
			return extendInterfaceType(p7)
		end

		if isUnionType(p7) then
			return extendUnionType(p7)
		end

		if isEnumType(p7) then
			return extendEnumType(p7)
		end

		if isInputObjectType(p7) then
			return extendInputObjectType(p7)
		end

		assert(false, "Unexpected type: " .. inspect(p7))
	end

	function extendInputObjectType(p8) -- line: 341
		-- upvalues: v64 (copy), GraphQLInputObjectType (copy), Object (copy), Map (copy), Array (copy), mapValueOrdered (copy), coerceToMap (copy), replaceType (copy), buildInputFieldMap (ref)
		local v116 = p8:toConfig()
		local v117 = v64[v116.name] or {}

		return GraphQLInputObjectType.new(Object.assign({}, v116, {
			fields = function() -- line: 347
				-- upvalues: Map (copy), Array (copy), mapValueOrdered (copy), coerceToMap (copy), v116 (copy), Object (copy), replaceType (copy), buildInputFieldMap (ref), v117 (copy)
				return Map.new(Array.concat(mapValueOrdered(coerceToMap(v116.fields), function(p9) -- line: 349
					-- upvalues: Object (copy), replaceType (copy)
					return Object.assign({}, p9, {
						type = replaceType(p9.type)
					})
				end):entries(), buildInputFieldMap(v117):entries()))
			end,
			extensionASTNodes = Array.concat(v116.extensionASTNodes, v117)
		}))
	end
	function extendEnumType(p10) -- line: 360
		-- upvalues: v64 (copy), GraphQLEnumType (copy), Object (copy), Map (copy), Array (copy), buildEnumValueMap (ref)
		local v119 = p10:toConfig()
		local v120 = v64:get(p10.name) or {}

		return GraphQLEnumType.new(Object.assign({}, v119, {
			values = Map.new(Array.concat(v119.values:entries(), buildEnumValueMap(v120):entries())),
			extensionASTNodes = Array.concat(v119.extensionASTNodes, v120)
		}))
	end
	function extendScalarType(p11) -- line: 378
		-- upvalues: v64 (copy), getSpecifiedByUrl (ref), GraphQLScalarType (copy), Object (copy), Array (copy)
		local v122 = p11:toConfig()
		local v123 = v64:get(v122.name) or {}
		local specifiedByUrl = v122.specifiedByUrl

		for _, v in ipairs(v123) do
			specifiedByUrl = getSpecifiedByUrl(v) or specifiedByUrl
		end

		return GraphQLScalarType.new(Object.assign({}, v122, {
			specifiedByUrl = specifiedByUrl,
			extensionASTNodes = Array.concat(v122.extensionASTNodes, v123)
		}))
	end
	function extendObjectType(p12) -- line: 394
		-- upvalues: v64 (copy), GraphQLObjectType (copy), Object (copy), Array (copy), replaceNamedType (ref), buildInterfaces (ref), Map (copy), mapValueOrdered (copy), coerceToMap (copy), extendField (ref), buildFieldMap (ref)
		local v128 = p12:toConfig()
		local v129 = v64:get(v128.name) or {}

		return GraphQLObjectType.new(Object.assign({}, v128, {
			interfaces = function() -- line: 400
				-- upvalues: Array (copy), p12 (copy), replaceNamedType (ref), buildInterfaces (ref), v129 (copy)
				return Array.concat(Array.map(p12:getInterfaces(), replaceNamedType), buildInterfaces(v129))
			end,
			fields = function() -- line: 407
				-- upvalues: Map (copy), Array (copy), mapValueOrdered (copy), coerceToMap (copy), v128 (copy), extendField (ref), buildFieldMap (ref), v129 (copy)
				return Map.new(Array.concat(mapValueOrdered(coerceToMap(v128.fields), extendField):entries(), buildFieldMap(v129):entries()))
			end,
			extensionASTNodes = Array.concat(v128.extensionASTNodes, v129)
		}))
	end
	function extendInterfaceType(p13) -- line: 419
		-- upvalues: v64 (copy), GraphQLInterfaceType (copy), Object (copy), Array (copy), replaceNamedType (ref), buildInterfaces (ref), Map (copy), mapValueOrdered (copy), coerceToMap (copy), extendField (ref), buildFieldMap (ref)
		local v131 = p13:toConfig()
		local v132 = v64:get(v131.name) or {}

		return GraphQLInterfaceType.new(Object.assign({}, v131, {
			interfaces = function() -- line: 425
				-- upvalues: Array (copy), p13 (copy), replaceNamedType (ref), buildInterfaces (ref), v132 (copy)
				return Array.concat(Array.map(p13:getInterfaces(), replaceNamedType), buildInterfaces(v132))
			end,
			fields = function() -- line: 432
				-- upvalues: Map (copy), Array (copy), mapValueOrdered (copy), coerceToMap (copy), v131 (copy), extendField (ref), buildFieldMap (ref), v132 (copy)
				return Map.new(Array.concat(mapValueOrdered(coerceToMap(v131.fields), extendField):entries(), buildFieldMap(v132):entries()))
			end,
			extensionASTNodes = Array.concat(v131.extensionASTNodes, v132)
		}))
	end
	function extendUnionType(p14) -- line: 444
		-- upvalues: v64 (copy), GraphQLUnionType (copy), Object (copy), Array (copy), replaceNamedType (ref), buildUnionTypes (ref)
		local v134 = p14:toConfig()
		local v135 = v64:get(v134.name) or {}

		return GraphQLUnionType.new(Object.assign({}, v134, {
			types = function() -- line: 450
				-- upvalues: Array (copy), p14 (copy), replaceNamedType (ref), buildUnionTypes (ref), v135 (copy)
				return Array.concat(Array.map(p14:getTypes(), replaceNamedType), buildUnionTypes(v135))
			end,
			extensionASTNodes = Array.concat(v134.extensionASTNodes, v135)
		}))
	end
	function extendField(p15) -- line: 461
		-- upvalues: Object (copy), replaceType (copy), mapValueOrdered (copy), extendArg (ref)
		return Object.assign({}, p15, {
			type = replaceType(p15.type),
			args = if not p15.args then nil else mapValueOrdered(p15.args, extendArg)
		})
	end
	function extendArg(p16) -- line: 469
		-- upvalues: Object (copy), replaceType (copy)
		return Object.assign({}, p16, {
			type = replaceType(p16.type)
		})
	end

	local function getOperationTypes(p17) -- line: 473
		-- upvalues: getNamedType (ref)
		local t4 = {}

		for _, v in ipairs(p17) do
			local v142 = v.operationTypes or {}

			for _, v2 in ipairs(v142) do
				t4[v2.operation] = getNamedType(v2.type)
			end
		end

		return t4
	end

	function getNamedType(p18) -- line: 496
		-- upvalues: u52 (ref), v72 (copy), Error (copy)
		local value = p18.name.value
		local v147 = u52[value] or v72[value]

		if v147 == nil then
			error(Error.new(("Unknown type: \"%s\"."):format(value)))
		end

		return v147
	end

	local function getWrappedType(p19) -- line: 508
		-- upvalues: Kind (copy), GraphQLList (copy), getWrappedType (copy), GraphQLNonNull (copy), getNamedType (ref)
		if p19.kind == Kind.LIST_TYPE then
			return GraphQLList.new(getWrappedType(p19.type))
		end

		if p19.kind == Kind.NON_NULL_TYPE then
			return GraphQLNonNull.new(getWrappedType(p19.type))
		end

		return getNamedType(p19)
	end
	local function buildDirective(p20) -- line: 519
		-- upvalues: Array (copy), GraphQLDirective (copy), buildArgumentMap (ref)
		local v150 = Array.map(p20.locations, function(p21) -- line: 520
			return p21.value
		end)

		return GraphQLDirective.new({
			name = p20.name.value,
			description = if not p20.description then nil else p20.description.value,
			locations = v150,
			isRepeatable = p20.repeatable,
			args = buildArgumentMap(p20.arguments),
			astNode = p20
		})
	end

	function buildFieldMap(p22) -- line: 537
		-- upvalues: Map (copy), getWrappedType (copy), buildArgumentMap (ref), getDeprecationReason (ref)
		local v152 = Map.new()

		for _, v in ipairs(p22) do
			local v155 = if not v.fields then {} else v.fields

			for _, v3 in ipairs(v155) do
				v152:set(v3.name.value, {
					type = getWrappedType(v3.type),
					description = if not v3.description then nil else v3.description.value,
					args = buildArgumentMap(v3.arguments),
					deprecationReason = getDeprecationReason(v3),
					astNode = v3
				})
			end
		end

		return v152
	end
	function buildArgumentMap(p23) -- line: 565
		-- upvalues: Map (copy), getWrappedType (copy), valueFromAST (copy), getDeprecationReason (ref)
		local v159 = p23 or {}
		local v160 = Map.new()

		for _, v in ipairs(v159) do
			local v163 = getWrappedType(v.type)

			v160:set(v.name.value, {
				type = v163,
				description = if not v.description then nil else v.description.value,
				defaultValue = valueFromAST(v.defaultValue, v163),
				deprecationReason = getDeprecationReason(v),
				astNode = v
			})
		end

		return v160
	end
	function buildInputFieldMap(p24) -- line: 589
		-- upvalues: Map (copy), getWrappedType (copy), valueFromAST (copy), getDeprecationReason (ref)
		local v165 = Map.new()

		for _, v in ipairs(p24) do
			local v168 = if not v.fields then {} else v.fields

			for _, v4 in ipairs(v168) do
				local v171 = getWrappedType(v4.type)

				v165:set(v4.name.value, {
					type = v171,
					description = if not v4.description then nil else v4.description.value,
					defaultValue = valueFromAST(v4.defaultValue, v171),
					deprecationReason = getDeprecationReason(v4),
					astNode = v4
				})
			end
		end

		return v165
	end
	function buildEnumValueMap(p25) -- line: 621
		-- upvalues: Map (copy), getDeprecationReason (ref)
		local v173 = Map.new()

		for _, v in ipairs(p25) do
			local v176 = if not v.values then {} else v.values

			for _, v5 in ipairs(v176) do
				v173:set(v5.name.value, {
					description = if not v5.description then nil else v5.description.value,
					deprecationReason = getDeprecationReason(v5),
					astNode = v5
				})
			end
		end

		return v173
	end
	function buildInterfaces(p26) -- line: 644
		-- upvalues: getNamedType (ref)
		local t5 = {}

		for _, v in ipairs(p26) do
			if v.interfaces then
				for _, v6 in ipairs(v.interfaces) do
					table.insert(t5, (getNamedType(v6)))
				end
			end
		end

		return t5
	end
	function buildUnionTypes(p27) -- line: 670
		-- upvalues: getNamedType (ref)
		local t6 = {}

		for _, v in ipairs(p27) do
			if v.types then
				for _, v7 in ipairs(v.types) do
					table.insert(t6, (getNamedType(v7)))
				end
			end
		end

		return t6
	end

	local function buildType(p28) -- line: 691
		-- upvalues: v64 (copy), Kind (copy), Array (copy), GraphQLObjectType (copy), buildInterfaces (ref), buildFieldMap (ref), GraphQLInterfaceType (copy), GraphQLEnumType (copy), buildEnumValueMap (ref), GraphQLUnionType (copy), buildUnionTypes (ref), GraphQLScalarType (copy), getSpecifiedByUrl (ref), GraphQLInputObjectType (copy), buildInputFieldMap (ref), inspect (copy)
		local value = p28.name.value
		local v193 = v64[value] or {}
		local kind = p28.kind

		if kind == Kind.OBJECT_TYPE_DEFINITION then
			local v195 = Array.concat(p28, v193)

			return GraphQLObjectType.new({
				name = value,
				description = if not p28.description then nil else p28.description.value,
				interfaces = function() -- line: 704
					-- upvalues: buildInterfaces (ref), v195 (copy)
					return buildInterfaces(v195)
				end,
				fields = function() -- line: 707
					-- upvalues: buildFieldMap (ref), v195 (copy)
					return buildFieldMap(v195)
				end,
				astNode = p28,
				extensionASTNodes = v193
			})
		end

		if kind == Kind.INTERFACE_TYPE_DEFINITION then
			local v196 = Array.concat(p28, v193)

			return GraphQLInterfaceType.new({
				name = value,
				description = if not p28.description then nil else p28.description.value,
				interfaces = function() -- line: 724
					-- upvalues: buildInterfaces (ref), v196 (copy)
					return buildInterfaces(v196)
				end,
				fields = function() -- line: 727
					-- upvalues: buildFieldMap (ref), v196 (copy)
					return buildFieldMap(v196)
				end,
				astNode = p28,
				extensionASTNodes = v193
			})
		end

		if kind == Kind.ENUM_TYPE_DEFINITION then
			local v197 = Array.concat(p28, v193)

			return GraphQLEnumType.new({
				name = value,
				description = if not p28.description then nil else p28.description.value,
				values = buildEnumValueMap(v197),
				astNode = p28,
				extensionASTNodes = v193
			})
		end

		if kind == Kind.UNION_TYPE_DEFINITION then
			local v198 = Array.concat(p28, v193)

			return GraphQLUnionType.new({
				name = value,
				description = if not p28.description then nil else p28.description.value,
				types = function() -- line: 750
					-- upvalues: buildUnionTypes (ref), v198 (copy)
					return buildUnionTypes(v198)
				end,
				astNode = p28,
				extensionASTNodes = v193
			})
		end

		if kind == Kind.SCALAR_TYPE_DEFINITION then
			return GraphQLScalarType.new({
				name = value,
				description = if not p28.description then nil else p28.description.value,
				specifiedByUrl = getSpecifiedByUrl(p28),
				astNode = p28,
				extensionASTNodes = v193
			})
		end

		if kind == Kind.INPUT_OBJECT_TYPE_DEFINITION then
			local v199 = Array.concat(p28, v193)

			return GraphQLInputObjectType.new({
				name = value,
				description = if not p28.description then nil else p28.description.value,
				fields = function() -- line: 773
					-- upvalues: buildInputFieldMap (ref), v199 (copy)
					return buildInputFieldMap(v199)
				end,
				astNode = p28,
				extensionASTNodes = v193
			})
		end

		assert(false, "Unexpected type definition node: " .. inspect(p28))
	end

	for _, v in ipairs(p1.types) do
		v72:set(v.name, extendNamedType(v))
	end

	for _, v in ipairs(t1) do
		local value = v.name.value

		v72:set(value, u52[value] or buildType(v))
	end

	local v101 = Object.assign({}, {
		query = p1.query and replaceNamedType(p1.query),
		mutation = p1.mutation and replaceNamedType(p1.mutation),
		subscription = p1.subscription and replaceNamedType(p1.subscription)
	}, v66 and getOperationTypes({ v66 }) or {}, (getOperationTypes(t3)))
	local value = nil

	if v66 ~= nil and v66.description ~= nil then
		value = v66.description.value
	end

	local v103 = p3 ~= nil and (p3.assumeValid == nil or p3.assumeValid)
	local v104 = Object.assign({}, {
		description = value
	}, v101, {
		types = v72:values(),
		directives = Array.concat(Array.map(p1.directives, replaceDirective), Array.map(t2, buildDirective)),
		astNode = v66 or p1.astNode,
		extensionASTNodes = Array.concat(p1.extensionASTNodes, t3),
		assumeValid = v103
	})

	v104.extensions = nil

	return v104
end

u52 = keyMap(Array.concat(specifiedScalarTypes, introspectionTypes), function(p29) -- line: 846
	return p29.name
end)

function getDeprecationReason(p30) -- line: 854
	-- upvalues: getDirectiveValues (copy), GraphQLDeprecatedDirective (copy)
	local v107 = getDirectiveValues(GraphQLDeprecatedDirective, p30)

	return v107 and v107.reason
end
function getSpecifiedByUrl(p31) -- line: 864
	-- upvalues: getDirectiveValues (copy), GraphQLSpecifiedByDirective (copy)
	local v109 = getDirectiveValues(GraphQLSpecifiedByDirective, p31)

	return v109 and v109.url
end

return {
	extendSchema = function(p32, p33, p34) -- line: 152
		-- upvalues: assertSchema (copy), devAssert (copy), Kind (copy), assertValidSDLExtension (copy), GraphQLSchema (copy)
		assertSchema(p32)
		devAssert(p33 ~= nil and p33.kind == Kind.DOCUMENT, "Must provide valid Document AST.")

		if (p34 and p34.assumeValid) ~= true and (p34 and p34.assumeValidSDL) ~= true then
			assertValidSDLExtension(p33, p32)
		end

		local v58 = p32:toConfig()
		local v59 = extendSchemaImpl(v58, p33, p34)

		if v58 == v59 then
			return p32
		end

		return (GraphQLSchema.new(v59))
	end,
	extendSchemaImpl = extendSchemaImpl
}
