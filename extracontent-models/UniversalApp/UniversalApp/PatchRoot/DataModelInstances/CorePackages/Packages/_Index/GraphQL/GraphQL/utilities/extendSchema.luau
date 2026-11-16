local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local coerceToMap = LuauPolyfill.coerceToMap

local mapValueOrdered = require(parent.luaUtils.mapValueOrdered)
local mapValueOrdered2 = mapValueOrdered.mapValueOrdered
require(parent.luaUtils.null)

local jsutils = parent.jsutils
local keyMap = require(jsutils.keyMap)
local keyMap2 = keyMap.keyMap
local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local devAssert = require(jsutils.devAssert)
local devAssert2 = devAssert.devAssert
require(jsutils.ObjMap)

require(parent.language.ast)

local kinds = require(parent.language.kinds)
local kind = kinds.Kind

local predicates = require(parent.language.predicates)
local isTypeDefinitionNode = predicates.isTypeDefinitionNode
local isTypeExtensionNode = predicates.isTypeExtensionNode

local validate = require(parent.validation.validate)
local assertValidSDLExtension = validate.assertValidSDLExtension

local values = require(parent.execution.values)
local getDirectiveValues = values.getDirectiveValues

local kind2 = parent.type
local schema = require(kind2.schema)

local assertSchema = schema.assertSchema
local graphQLSchema = schema.GraphQLSchema
local scalars = require(kind2.scalars)
local specifiedScalarTypes = scalars.specifiedScalarTypes
local isSpecifiedScalarType = scalars.isSpecifiedScalarType
local introspection = require(kind2.introspection)
local introspectionTypes = introspection.introspectionTypes
local isIntrospectionType = introspection.isIntrospectionType
local directives = require(kind2.directives)

local graphQLDirective = directives.GraphQLDirective
local graphQLDeprecatedDirective = directives.GraphQLDeprecatedDirective
local graphQLSpecifiedByDirective = directives.GraphQLSpecifiedByDirective

local definition = require(kind2.definition)

local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local graphQLList = definition.GraphQLList
local graphQLNonNull = definition.GraphQLNonNull
local graphQLScalarType = definition.GraphQLScalarType

local graphQLObjectType = definition.GraphQLObjectType

local graphQLInterfaceType = definition.GraphQLInterfaceType

local graphQLUnionType = definition.GraphQLUnionType

local graphQLEnumType = definition.GraphQLEnumType

local graphQLInputObjectType = definition.GraphQLInputObjectType

local valueFromAST = require(script.Parent.valueFromAST)
local valueFromAST2 = valueFromAST.valueFromAST

local v = nil
local getDeprecationReason
local getSpecifiedByUrl

function extendSchemaImpl(data, p, p2)
	local v2 = Map.new()

	local definitions = {}
	local definitions2 = {}

	local definitions3 = {}
	local v3 = nil

	for _, definition2 in ipairs(p.definitions) do
		if definition2.kind == kind.SCHEMA_DEFINITION then
			v3 = definition2
		elseif definition2.kind == kind.SCHEMA_EXTENSION then
			table.insert(definitions, definition2)
		elseif isTypeDefinitionNode(definition2) then
			table.insert(definitions2, definition2)
		elseif isTypeExtensionNode(definition2) then
			local value = definition2.name.value

			local v4 = v2:get(value)
			v2:set(value, not v4 and { definition2 } or Array.concat(v4, { definition2 }))
		elseif definition2.kind == kind.DIRECTIVE_DEFINITION then
			table.insert(definitions3, definition2)
		end
	end

	if #v2:keys() == 0 and #definitions2 == 0 and #definitions3 == 0 and #definitions == 0 and v3 == nil then
		return data
	end

	local v4 = Map.new()

	local replaceNamedType
	local extendArg
	local extendField
	local extendScalarType
	local extendObjectType
	local extendInterfaceType
	local extendUnionType
	local extendEnumType
	local extendInputObjectType
	local buildInputFieldMap

	local buildEnumValueMap

	local buildInterfaces

	local buildUnionTypes
	local getNamedType
	local buildArgumentMap
	local buildFieldMap
	local function replaceType(kind3)
		if isListType(kind3) then
			return graphQLList.new(replaceType(kind3.ofType))
		end

		if isNonNullType(kind3) then
			return graphQLNonNull.new(replaceType(kind3.ofType))
		end

		return replaceNamedType(kind3)
	end

	replaceNamedType = function(p3)
		return v4:get(p3.name)
	end

	local function replaceDirective(object)
		local config = object:toConfig()
		return graphQLDirective.new(Object.assign({}, config, {
			args = mapValueOrdered2(coerceToMap(config.args), extendArg)
		}))
	end

	local function extendNamedType(kind3)
		if isIntrospectionType(kind3) or isSpecifiedScalarType(kind3) then
			return kind3
		end

		if isScalarType(kind3) then
			return extendScalarType(kind3)
		end

		if isObjectType(kind3) then
			return extendObjectType(kind3)
		end

		if isInterfaceType(kind3) then
			return extendInterfaceType(kind3)
		end

		if isUnionType(kind3) then
			return extendUnionType(kind3)
		end

		if isEnumType(kind3) then
			return extendEnumType(kind3)
		end

		if isInputObjectType(kind3) then
			return extendInputObjectType(kind3)
		end

		assert(false, "Unexpected type: " .. inspect2(kind3))
	end

	extendInputObjectType = function(object)
		local config = object:toConfig()

		local v5 = v2[config.name] or {}

		return graphQLInputObjectType.new(Object.assign({}, config, {
			fields = function()
				return Map.new(Array.concat(mapValueOrdered2(coerceToMap(config.fields), function(p3)
					return Object.assign({}, p3, { type = replaceType(p3.type) })
				end):entries(), buildInputFieldMap(v5):entries()))
			end,
			extensionASTNodes = Array.concat(config.extensionASTNodes, v5)
		}))
	end

	extendEnumType = function(object)
		local config = object:toConfig()

		local v5 = v2:get(object.name) or {}

		return graphQLEnumType.new(Object.assign({}, config, {
			values = Map.new(Array.concat(config.values:entries(), buildEnumValueMap(v5):entries())),
			extensionASTNodes = Array.concat(config.extensionASTNodes, v5)
		}))
	end

	extendScalarType = function(object)
		local config = object:toConfig()

		local v5 = v2:get(config.name) or {}

		local specifiedByUrl = config.specifiedByUrl

		for _, v6 in ipairs(v5) do
			specifiedByUrl = getSpecifiedByUrl(v6) or specifiedByUrl
		end

		return graphQLScalarType.new(Object.assign({}, config, {
			specifiedByUrl = specifiedByUrl,
			extensionASTNodes = Array.concat(config.extensionASTNodes, v5)
		}))
	end

	extendObjectType = function(object)
		local config = object:toConfig()

		local v5 = v2:get(config.name) or {}

		return graphQLObjectType.new(Object.assign({}, config, {
			interfaces = function()
				return Array.concat(Array.map(object:getInterfaces(), replaceNamedType), buildInterfaces(v5))
			end,
			fields = function()
				return Map.new(Array.concat(
					mapValueOrdered2(coerceToMap(config.fields), extendField):entries(),
					buildFieldMap(v5):entries()
				))
			end,
			extensionASTNodes = Array.concat(config.extensionASTNodes, v5)
		}))
	end

	extendInterfaceType = function(object)
		local config = object:toConfig()

		local v5 = v2:get(config.name) or {}

		return graphQLInterfaceType.new(Object.assign({}, config, {
			interfaces = function()
				return Array.concat(Array.map(object:getInterfaces(), replaceNamedType), buildInterfaces(v5))
			end,
			fields = function()
				return Map.new(Array.concat(
					mapValueOrdered2(coerceToMap(config.fields), extendField):entries(),
					buildFieldMap(v5):entries()
				))
			end,
			extensionASTNodes = Array.concat(config.extensionASTNodes, v5)
		}))
	end

	extendUnionType = function(object)
		local config = object:toConfig()

		local v5 = v2:get(config.name) or {}

		return graphQLUnionType.new(Object.assign({}, config, {
			types = function()
				return Array.concat(Array.map(object:getTypes(), replaceNamedType), buildUnionTypes(v5))
			end,
			extensionASTNodes = Array.concat(config.extensionASTNodes, v5)
		}))
	end

	extendField = function(p3)
		local assign = Object.assign
		local v5 = { type = replaceType(p3.type), args = 0 }
		local args

		if p3.args then
			args = mapValueOrdered2(p3.args, extendArg)
		end

		v5.args = args
		return assign({}, p3, v5)
	end

	extendArg = function(p3)
		return Object.assign({}, p3, { type = replaceType(p3.type) })
	end

	local function getOperationTypes(list)
		local operationTypes = {}

		for _, item in ipairs(list) do
			local operationTypes2 = item.operationTypes or {}

			for _, operationType in ipairs(operationTypes2) do
				operationTypes[operationType.operation] = getNamedType(operationType.type)
			end
		end

		return operationTypes
	end

	getNamedType = function(p3)
		local value = p3.name.value

		local namedType = v[value] or v4[value]

		if namedType == nil then
			error(Error.new(("Unknown type: \"%s\"."):format(value)))
		end

		return namedType
	end

	local function getWrappedType(kind3)
		if kind3.kind == kind.LIST_TYPE then
			return graphQLList.new(getWrappedType(kind3.type))
		end

		if kind3.kind == kind.NON_NULL_TYPE then
			return graphQLNonNull.new(getWrappedType(kind3.type))
		end

		return getNamedType(kind3)
	end

	local function buildDirective(astNode)
		local mapped = Array.map(astNode.locations, function(p3)
			return p3.value
		end)

		local new = graphQLDirective.new
		local v5 = {
			name = astNode.name.value,
			description = 0,
			locations = 0,
			isRepeatable = 0,
			args = 0,
			astNode = 0
		}
		local description

		if astNode.description then
			description = astNode.description.value
		end

		v5.description = description
		v5.locations = mapped
		v5.isRepeatable = astNode.repeatable
		v5.args = buildArgumentMap(astNode.arguments)
		v5.astNode = astNode
		return new(v5)
	end

	buildFieldMap = function(list)
		local fieldMap = Map.new()

		for _, item in ipairs(list) do
			local v5 = not item.fields and {} or item.fields

			for _, astNode in ipairs(v5) do
				local value = astNode.name.value
				local v6 = {
					type = getWrappedType(astNode.type),
					description = 0,
					args = 0,
					deprecationReason = 0,
					astNode = 0
				}
				local description

				if astNode.description then
					description = astNode.description.value
				end

				v6.description = description
				v6.args = buildArgumentMap(astNode.arguments)
				v6.deprecationReason = getDeprecationReason(astNode)
				v6.astNode = astNode
				fieldMap:set(value, v6)
			end
		end

		return fieldMap
	end

	buildArgumentMap = function(arguments)
		local argumentMap = Map.new()

		for _, astNode in ipairs(arguments or {}) do
			local wrappedType = getWrappedType(astNode.type)

			local value = astNode.name.value
			local description

			if astNode.description then
				description = astNode.description.value
			end

			argumentMap:set(value, {
				type = wrappedType,
				description = description,
				defaultValue = valueFromAST2(astNode.defaultValue, wrappedType),
				deprecationReason = getDeprecationReason(astNode),
				astNode = astNode
			})
		end

		return argumentMap
	end

	buildInputFieldMap = function(list)
		local inputFieldMap = Map.new()

		for _, item in ipairs(list) do
			local v5 = not item.fields and {} or item.fields

			for _, astNode in ipairs(v5) do
				local wrappedType = getWrappedType(astNode.type)

				local value = astNode.name.value
				local description

				if astNode.description then
					description = astNode.description.value
				end

				inputFieldMap:set(value, {
					type = wrappedType,
					description = description,
					defaultValue = valueFromAST2(astNode.defaultValue, wrappedType),
					deprecationReason = getDeprecationReason(astNode),
					astNode = astNode
				})
			end
		end

		return inputFieldMap
	end

	buildEnumValueMap = function(list)
		local enumValueMap = Map.new()

		for _, item in ipairs(list) do
			local v5 = not item.values and {} or item.values

			for _, astNode in ipairs(v5) do
				local value = astNode.name.value
				local description

				if astNode.description then
					description = astNode.description.value
				end

				enumValueMap:set(value, {
					description = description,
					deprecationReason = getDeprecationReason(astNode),
					astNode = astNode
				})
			end
		end

		return enumValueMap
	end

	buildInterfaces = function(list)
		local interfaces = {}

		for _, item in ipairs(list) do
			if not item.interfaces then
				continue
			end

			for _, interface in ipairs(item.interfaces) do
				table.insert(interfaces, (getNamedType(interface)))
			end
		end

		return interfaces
	end

	buildUnionTypes = function(list)
		local unionTypes = {}

		for _, item in ipairs(list) do
			if not item.types then
				continue
			end

			for _, kind3 in ipairs(item.types) do
				table.insert(unionTypes, (getNamedType(kind3)))
			end
		end

		return unionTypes
	end

	local function buildType(astNode)
		local name = astNode.name.value

		local extensionASTNodes = v2[name] or {}
		local kind3 = astNode.kind

		if kind3 == kind.OBJECT_TYPE_DEFINITION then
			local joined = Array.concat(astNode, extensionASTNodes)

			local new = graphQLObjectType.new
			local description

			if astNode.description then
				description = astNode.description.value
			end

			return new({
				name = name,
				description = description,
				interfaces = function()
					return buildInterfaces(joined)
				end,
				fields = function()
					return buildFieldMap(joined)
				end,
				astNode = astNode,
				extensionASTNodes = extensionASTNodes
			})
		elseif kind3 == kind.INTERFACE_TYPE_DEFINITION then
			local joined = Array.concat(astNode, extensionASTNodes)

			local new = graphQLInterfaceType.new
			local description

			if astNode.description then
				description = astNode.description.value
			end

			return new({
				name = name,
				description = description,
				interfaces = function()
					return buildInterfaces(joined)
				end,
				fields = function()
					return buildFieldMap(joined)
				end,
				astNode = astNode,
				extensionASTNodes = extensionASTNodes
			})
		elseif kind3 == kind.ENUM_TYPE_DEFINITION then
			local joined = Array.concat(astNode, extensionASTNodes)

			local new = graphQLEnumType.new
			local description

			if astNode.description then
				description = astNode.description.value
			end

			return new({
				name = name,
				description = description,
				values = buildEnumValueMap(joined),
				astNode = astNode,
				extensionASTNodes = extensionASTNodes
			})
		elseif kind3 == kind.UNION_TYPE_DEFINITION then
			local joined = Array.concat(astNode, extensionASTNodes)

			local new = graphQLUnionType.new
			local description

			if astNode.description then
				description = astNode.description.value
			end

			return new({
				name = name,
				description = description,
				types = function()
					return buildUnionTypes(joined)
				end,
				astNode = astNode,
				extensionASTNodes = extensionASTNodes
			})
		elseif kind3 == kind.SCALAR_TYPE_DEFINITION then
			local new = graphQLScalarType.new
			local description

			if astNode.description then
				description = astNode.description.value
			end

			return new({
				name = name,
				description = description,
				specifiedByUrl = getSpecifiedByUrl(astNode),
				astNode = astNode,
				extensionASTNodes = extensionASTNodes
			})
		else
			if kind3 ~= kind.INPUT_OBJECT_TYPE_DEFINITION then
				assert(false, "Unexpected type definition node: " .. inspect2(astNode))
				return
			end

			local joined = Array.concat(astNode, extensionASTNodes)

			local new = graphQLInputObjectType.new
			local description

			if astNode.description then
				description = astNode.description.value
			end

			return new({
				name = name,
				description = description,
				fields = function()
					return buildInputFieldMap(joined)
				end,
				astNode = astNode,
				extensionASTNodes = extensionASTNodes
			})
		end
	end

	for _, kind3 in ipairs(data.types) do
		v4:set(kind3.name, extendNamedType(kind3))
	end

	for _, v5 in ipairs(definitions2) do
		local value = v5.name.value

		v4:set(value, v[value] or buildType(v5))
	end

	local v5 = Object.assign({}, {
		query = data.query and replaceNamedType(data.query),
		mutation = data.mutation and replaceNamedType(data.mutation),
		subscription = data.subscription and replaceNamedType(data.subscription)
	}, v3 and getOperationTypes({ v3 }) or {}, getOperationTypes(definitions))
	local description

	if not (v3 == nil or v3.description == nil) then
		description = v3.description.value
	end

	local assumeValid

	if p2 == nil or p2.assumeValid == nil then
		assumeValid = false
	else
		assumeValid = p2.assumeValid
	end

	local v6 = Object.assign({}, { description = description }, v5, {
		types = v4:values(),
		directives = Array.concat(Array.map(data.directives, replaceDirective), Array.map(definitions3, buildDirective)),
		astNode = v3 or data.astNode,
		extensionASTNodes = Array.concat(data.extensionASTNodes, definitions),
		assumeValid = assumeValid
	})

	v6.extensions = nil
	return v6
end

v = keyMap2(Array.concat(specifiedScalarTypes, introspectionTypes), function(p)
	return p.name
end)

getDeprecationReason = function(p)
	local directiveValues = getDirectiveValues(graphQLDeprecatedDirective, p)
	return directiveValues and directiveValues.reason
end

getSpecifiedByUrl = function(p)
	local directiveValues = getDirectiveValues(graphQLSpecifiedByDirective, p)
	return directiveValues and directiveValues.url
end

return {
	extendSchema = function(object, p, p2)
		assertSchema(object)

		devAssert2(p ~= nil and p.kind == kind.DOCUMENT, "Must provide valid Document AST.")

		if (p2 and p2.assumeValid) ~= true and (p2 and p2.assumeValidSDL) ~= true then
			assertValidSDLExtension(p, object)
		end

		local config = object:toConfig()
		local v2 = extendSchemaImpl(config, p, p2)

		if config == v2 then
			return object
		end

		return (graphQLSchema.new(v2))
	end,
	extendSchemaImpl = extendSchemaImpl
}
