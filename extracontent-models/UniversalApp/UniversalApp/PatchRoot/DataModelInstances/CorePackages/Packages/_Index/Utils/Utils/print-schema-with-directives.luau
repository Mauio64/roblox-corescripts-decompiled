local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)

local Print = GraphQL.print

local Kind = GraphQL.Kind
local isSpecifiedScalarType = GraphQL.isSpecifiedScalarType
local isIntrospectionType = GraphQL.isIntrospectionType

local isSpecifiedDirective = GraphQL.isSpecifiedDirective

local astFromValue = GraphQL.astFromValue

local GraphQLDeprecatedDirective = GraphQL.GraphQLDeprecatedDirective
local isObjectType = GraphQL.isObjectType

local isInterfaceType = GraphQL.isInterfaceType
local isUnionType = GraphQL.isUnionType

local isInputObjectType = GraphQL.isInputObjectType

local isEnumType = GraphQL.isEnumType
local isScalarType = GraphQL.isScalarType

require(script.Parent.types)

local astFromType = require(script.Parent.astFromType)
local astFromType2 = astFromType.astFromType
local getdirectives = require(script.Parent["get-directives"])
local getDirectivesInExtensions = getdirectives.getDirectivesInExtensions
local astFromValueUntyped = require(script.Parent.astFromValueUntyped)
local astFromValueUntyped2 = astFromValueUntyped.astFromValueUntyped
local helpers = require(script.Parent.helpers)
local isSome = helpers.isSome
local rootTypes = require(script.Parent.rootTypes)
local getRootTypeMap = rootTypes.getRootTypeMap

local astFromSchema
local astFromDirective
local makeDirectiveNode
local getDirectiveNodes
local astFromObjectType
local makeDirectiveNodes
local astFromEnumValue
local makeDeprecatedDirective
local astFromInterfaceType
local astFromUnionType
local astFromInputObjectType
local astFromEnumType
local astFromScalarType
local astFromArg
local astFromField
local astFromInputField

local null = GraphQL.NULL

local function getDocumentNodeFromSchema(object, p)
	local pathToDirectivesInExtensions = (p == nil and {} or p).pathToDirectivesInExtensions
	local typeMap = object:getTypeMap()
	local v = astFromSchema(object, pathToDirectivesInExtensions)
	local definitions = v == nil and {} or { v }
	local directives = object:getDirectives()

	for _, directive in directives do
		if not Boolean.toJSBoolean(isSpecifiedDirective(directive)) then
			table.insert(definitions, astFromDirective(directive, object, pathToDirectivesInExtensions))
		end
	end

	for _, kind in typeMap do
		local v2 = typeMap:get(kind[1])

		local specifiedScalarType = isSpecifiedScalarType(v2)
		local introspectionType = isIntrospectionType(v2)

		if specifiedScalarType or introspectionType then
			continue
		end

		if Boolean.toJSBoolean(isObjectType(v2)) then
			table.insert(definitions, astFromObjectType(v2, object, pathToDirectivesInExtensions))
		elseif Boolean.toJSBoolean(isInterfaceType(v2)) then
			table.insert(definitions, astFromInterfaceType(v2, object, pathToDirectivesInExtensions))
		elseif Boolean.toJSBoolean(isUnionType(v2)) then
			table.insert(definitions, astFromUnionType(v2, object, pathToDirectivesInExtensions))
		elseif Boolean.toJSBoolean(isInputObjectType(v2)) then
			table.insert(definitions, astFromInputObjectType(v2, object, pathToDirectivesInExtensions))
		elseif Boolean.toJSBoolean(isEnumType(v2)) then
			table.insert(definitions, astFromEnumType(v2, object, pathToDirectivesInExtensions))
		elseif Boolean.toJSBoolean(isScalarType(v2)) then
			table.insert(definitions, astFromScalarType(v2, object, pathToDirectivesInExtensions))
		else
			error(Error.new(("Unknown type %s."):format((tostring(v2)))))
		end
	end

	return { kind = Kind.DOCUMENT, definitions = definitions }
end

local PrintSchemaWithDirectives = {}
PrintSchemaWithDirectives.getDocumentNodeFromSchema = getDocumentNodeFromSchema

function PrintSchemaWithDirectives.printSchemaWithDirectives(p, p2)
	return Print(getDocumentNodeFromSchema(p, p2 == nil and {} or p2))
end

astFromSchema = function(object, pathToDirectivesInExtensions)
	local v = Map.new({
		{ "query", Object.None },
		{ "mutation", Object.None },
		{ "subscription", Object.None }
	})

	local v2 = {}

	if object.astNode ~= nil then
		table.insert(v2, object.astNode)
	end

	if object.extensionASTNodes ~= nil then
		for _, extensionASTNode in object.extensionASTNodes do
			table.insert(v2, extensionASTNode)
		end
	end

	for _, v3 in v2 do
		if not Boolean.toJSBoolean(v3.operationTypes) then
			continue
		end

		for _, operationType in v3.operationTypes do
			v:set(operationType.operation, operationType)
		end
	end

	local rootTypeMap = getRootTypeMap(object)

	for _, list in v do
		local operation, v3 = table.unpack(list, 1, 2)
		local v4 = rootTypeMap:get(operation)

		if v4 == nil then
			continue
		end

		local v5 = astFromType2(v4)

		if v3 == nil or v3 == Object.None then
			v:set(operation, {
				kind = Kind.OPERATION_TYPE_DEFINITION,
				operation = operation,
				type = v5
			})
		else
			v3.type = v5
		end
	end

	local filtered = Array.filter(Array.concat({}, v:values()), isSome)

	local directives = getDirectiveNodes(object, object, pathToDirectivesInExtensions)

	if not (Boolean.toJSBoolean(#filtered) or Boolean.toJSBoolean(#directives)) then
		return nil
	end

	local kind

	if filtered == nil then
		kind = Kind.SCHEMA_EXTENSION
	else
		kind = Kind.SCHEMA_DEFINITION
	end

	local v3 = { kind = kind, operationTypes = filtered, directives = directives }

	local toJSBoolean = Boolean.toJSBoolean
	local v4

	if typeof(object.astNode) == "table" then
		v4 = object.astNode.description
	end

	if v4 == nil then
		v4 = object.description ~= nil
	end

	v3.description = toJSBoolean(v4) and {
		kind = Kind.STRING,
		value = object.description,
		block = true
	} or nil

	return v3
end

PrintSchemaWithDirectives.astFromSchema = astFromSchema

astFromDirective = function(directive, object, pathToDirectivesInExtensions)
	local DIRECTIVE_DEFINITION = Kind.DIRECTIVE_DEFINITION
	local description

	if typeof(directive.astNode) == "table" then
		description = directive.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(directive.description)
			and { kind = Kind.STRING, value = directive.description }
			or nil
	end

	local name = { kind = Kind.NAME, value = directive.name }
	local mapped

	if typeof(directive.args) == "table" then
		mapped = Array.map(directive.args, function(p)
			return astFromArg(p, object, pathToDirectivesInExtensions)
		end)
	end

	local isRepeatable = directive.isRepeatable
	local mapped2

	if typeof(directive.locations) == "table" then
		mapped2 = Array.map(directive.locations, function(p)
			return { kind = Kind.NAME, value = p }
		end)
	end

	return {
		kind = DIRECTIVE_DEFINITION,
		description = description,
		name = name,
		arguments = mapped,
		repeatable = isRepeatable,
		locations = Boolean.toJSBoolean(mapped2) and mapped2 or {}
	}
end

PrintSchemaWithDirectives.astFromDirective = astFromDirective

getDirectiveNodes = function(p, p2, p3)
	local directivesInExtensions = getDirectivesInExtensions(p, p3)

	local joined = {}

	if p.astNode ~= nil then
		table.insert(joined, p.astNode)
	end

	if Array.indexOf(Object.keys(p), "extensionASTNodes") ~= -1 and p.extensionASTNodes ~= nil then
		joined = Array.concat(joined, p.extensionASTNodes)
	end

	if directivesInExtensions ~= nil then
		return (makeDirectiveNodes(p2, directivesInExtensions))
	end

	local joined2 = {}

	for _, v in joined do
		if Boolean.toJSBoolean(v.directives) then
			joined2 = Array.concat(joined2, v.directives)
		end
	end

	return joined2
end

PrintSchemaWithDirectives.getDirectiveNodes = getDirectiveNodes
local function getDeprecatableDirectiveNodes(data, p, p2)
	local v = {}
	local v2 = nil
	local directivesInExtensions = getDirectivesInExtensions(data, p2)
	local v3

	if directivesInExtensions == nil then
		if typeof(data.astNode) == "table" then
			v3 = data.astNode.directives
		end
	else
		v3 = makeDirectiveNodes(p, directivesInExtensions)
	end

	if v3 ~= nil then
		v = Array.filter(v3, function(p3): boolean
			return p3.name.value ~= "deprecated"
		end)

		if data.deprecationReason ~= nil and typeof(Array.filter(v3, function(p3): boolean
			return p3.name.value == "deprecated"
		end)) == "table" then
			v2 = Array.filter(v3, function(p3): boolean
				return p3.name.value == "deprecated"
			end)[1]
		end
	end

	if data.deprecationReason ~= nil and v2 == nil then
		v2 = makeDeprecatedDirective(data.deprecationReason)
	end

	if v2 == nil then
		return v
	end

	return (Array.concat({ v2 }, v))
end

PrintSchemaWithDirectives.getDeprecatableDirectiveNodes = getDeprecatableDirectiveNodes

astFromArg = function(data, p, p2)
	local INPUT_VALUE_DEFINITION = Kind.INPUT_VALUE_DEFINITION
	local description

	if typeof(data.astNode) == "table" then
		description = data.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(data.description)
			and { kind = Kind.STRING, value = data.description, block = true }
			or nil
	end

	local v = {
		kind = INPUT_VALUE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = data.name },
		type = astFromType2(data.type),
		defaultValue = 0,
		directives = 0
	}
	local defaultValue

	if data.defaultValue ~= nil then
		defaultValue = astFromValue(data.defaultValue, data.type)
	end

	v.defaultValue = defaultValue

	v.directives = getDeprecatableDirectiveNodes(data, p, p2)
	return v
end

PrintSchemaWithDirectives.astFromArg = astFromArg

astFromObjectType = function(object, object2, pathToDirectivesInExtensions)
	local OBJECT_TYPE_DEFINITION = Kind.OBJECT_TYPE_DEFINITION
	local description

	if typeof(object.astNode) == "table" then
		description = object.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(object.description)
			and { kind = Kind.STRING, value = object.description, block = true }
			or nil
	end

	return {
		kind = OBJECT_TYPE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = object.name },
		fields = Array.map(object:getFields():values(), function(p)
			return astFromField(p, object2, pathToDirectivesInExtensions)
		end),
		interfaces = Array.map(Object.values(object:getInterfaces()), function(p)
			return (astFromType2(p))
		end),
		directives = getDirectiveNodes(object, object2, pathToDirectivesInExtensions)
	}
end

PrintSchemaWithDirectives.astFromObjectType = astFromObjectType

astFromInterfaceType = function(object, object2, pathToDirectivesInExtensions)
	local INTERFACE_TYPE_DEFINITION = Kind.INTERFACE_TYPE_DEFINITION
	local description

	if typeof(object.astNode) == "table" then
		description = object.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(object.description)
			and { kind = Kind.STRING, value = object.description, block = true }
			or nil
	end

	local v = {
		kind = INTERFACE_TYPE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = object.name },
		fields = Array.map(object:getFields():values(), function(p)
			return astFromField(p, object2, pathToDirectivesInExtensions)
		end),
		directives = getDirectiveNodes(object, object2, pathToDirectivesInExtensions)
	}

	if object.getInterfaces ~= nil then
		v.interfaces = Array.map(Object.values(object:getInterfaces()), function(p)
			return (astFromType2(p))
		end)
	end

	return v
end

PrintSchemaWithDirectives.astFromInterfaceType = astFromInterfaceType

astFromUnionType = function(object, object2, pathToDirectivesInExtensions)
	local UNION_TYPE_DEFINITION = Kind.UNION_TYPE_DEFINITION
	local description

	if typeof(object.astNode) == "table" then
		description = object.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(object.description)
			and { kind = Kind.STRING, value = object.description, block = true }
			or nil
	end

	return {
		kind = UNION_TYPE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = object.name },
		directives = getDirectiveNodes(object, object2, pathToDirectivesInExtensions),
		types = Array.map(object:getTypes(), function(p)
			return (astFromType2(p))
		end)
	}
end

PrintSchemaWithDirectives.astFromUnionType = astFromUnionType

astFromInputObjectType = function(object, object2, pathToDirectivesInExtensions)
	local INPUT_OBJECT_TYPE_DEFINITION = Kind.INPUT_OBJECT_TYPE_DEFINITION
	local description

	if typeof(object.astNode) == "table" then
		description = object.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(object.description)
			and { kind = Kind.STRING, value = object.description, block = true }
			or nil
	end

	return {
		kind = INPUT_OBJECT_TYPE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = object.name },
		fields = Array.map(object:getFields():values(), function(p)
			return astFromInputField(p, object2, pathToDirectivesInExtensions)
		end),
		directives = getDirectiveNodes(object, object2, pathToDirectivesInExtensions)
	}
end

PrintSchemaWithDirectives.astFromInputObjectType = astFromInputObjectType

astFromEnumType = function(object, object2, pathToDirectivesInExtensions)
	local ENUM_TYPE_DEFINITION = Kind.ENUM_TYPE_DEFINITION
	local description

	if typeof(object.astNode) == "table" then
		description = object.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(object.description)
			and { kind = Kind.STRING, value = object.description, block = true }
			or nil
	end

	return {
		kind = ENUM_TYPE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = object.name },
		values = Array.map(Object.values(object:getValues()), function(p)
			return astFromEnumValue(p, object2, pathToDirectivesInExtensions)
		end),
		directives = getDirectiveNodes(object, object2, pathToDirectivesInExtensions)
	}
end

PrintSchemaWithDirectives.astFromEnumType = astFromEnumType

astFromScalarType = function(data, object, pathToDirectivesInExtensions)
	local directivesInExtensions = getDirectivesInExtensions(data, pathToDirectivesInExtensions)
	local directives

	if Boolean.toJSBoolean(directivesInExtensions) then
		directives = makeDirectiveNodes(object, directivesInExtensions)
	else
		local v

		if typeof(data.astNode) == "table" then
			v = data.astNode.directives
		end

		directives = v or {}
	end

	local specifiedByUrl = Boolean.toJSBoolean(data.specifiedByUrl) and data.specifiedByUrl or data.specifiedByURL

	local toJSBoolean = Boolean.toJSBoolean
	local v

	if Boolean.toJSBoolean(specifiedByUrl) then
		v = not Boolean.toJSBoolean(Array.some(directives, function(p): boolean
			return p.name.value == "specifiedBy"
		end))
	else
		v = specifiedByUrl
	end

	if toJSBoolean(v) then
		table.insert(directives, makeDirectiveNode("specifiedBy", { url = specifiedByUrl }))
	end

	local SCALAR_TYPE_DEFINITION = Kind.SCALAR_TYPE_DEFINITION
	local description

	if typeof(data.astNode) == "table" then
		description = data.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(data.description)
			and { kind = Kind.STRING, value = data.description, block = true }
			or nil
	end

	return {
		kind = SCALAR_TYPE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = data.name },
		directives = directives
	}
end

PrintSchemaWithDirectives.astFromScalarType = astFromScalarType

astFromField = function(data, p, p2)
	local FIELD_DEFINITION = Kind.FIELD_DEFINITION
	local description

	if typeof(data.astNode) == "table" then
		description = data.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(data.description)
			and { kind = Kind.STRING, value = data.description, block = true }
			or nil
	end

	return {
		kind = FIELD_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = data.name },
		arguments = Array.map(data.args, function(p3)
			return astFromArg(p3, p, p2)
		end),
		type = astFromType2(data.type),
		directives = getDeprecatableDirectiveNodes(data, p, p2)
	}
end

PrintSchemaWithDirectives.astFromField = astFromField

astFromInputField = function(data, p, p2)
	local INPUT_VALUE_DEFINITION = Kind.INPUT_VALUE_DEFINITION
	local description

	if typeof(data.astNode) == "table" then
		description = data.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(data.description)
			and { kind = Kind.STRING, value = data.description, block = true }
			or nil
	end

	local name = { kind = Kind.NAME, value = data.name }
	local v = astFromType2(data.type)
	local deprecatableDirectiveNodes = getDeprecatableDirectiveNodes(data, p, p2)

	local defaultValue = astFromValue(data.defaultValue, data.type)

	if defaultValue == nil or defaultValue == null then
		defaultValue = nil
	end

	return {
		kind = INPUT_VALUE_DEFINITION,
		description = description,
		name = name,
		type = v,
		directives = deprecatableDirectiveNodes,
		defaultValue = defaultValue
	}
end

PrintSchemaWithDirectives.astFromInputField = astFromInputField

astFromEnumValue = function(data, p, p2)
	local ENUM_VALUE_DEFINITION = Kind.ENUM_VALUE_DEFINITION
	local description

	if typeof(data.astNode) == "table" then
		description = data.astNode.description
	end

	if description == nil then
		description = Boolean.toJSBoolean(data.description)
			and { kind = Kind.STRING, value = data.description, block = true }
			or nil
	end

	return {
		kind = ENUM_VALUE_DEFINITION,
		description = description,
		name = { kind = Kind.NAME, value = data.name },
		directives = getDeprecatableDirectiveNodes(data, p, p2)
	}
end

PrintSchemaWithDirectives.astFromEnumValue = astFromEnumValue

makeDeprecatedDirective = function(deprecationReason: string)
	return makeDirectiveNode("deprecated", { reason = deprecationReason }, GraphQLDeprecatedDirective)
end

PrintSchemaWithDirectives.makeDeprecatedDirective = makeDeprecatedDirective

makeDirectiveNode = function(p: string, items, p2)
	local arguments = {}

	if p2 == nil then
		for k in items do
			local v = astFromValueUntyped2(items[tostring(k)])

			if Boolean.toJSBoolean(v) then
				table.insert(arguments, {
					kind = Kind.ARGUMENT,
					name = { kind = Kind.NAME, value = k },
					value = v
				})
			end
		end
	else
		for _, arg in p2.args do
			local name = arg.name
			local item = items[tostring(name)]

			if item == nil then
				continue
			end

			local v = astFromValue(item, arg.type)

			if Boolean.toJSBoolean(v) then
				table.insert(arguments, {
					kind = Kind.ARGUMENT,
					name = { kind = Kind.NAME, value = name },
					value = v
				})
			end
		end
	end

	return {
		kind = Kind.DIRECTIVE,
		name = { kind = Kind.NAME, value = p },
		arguments = arguments
	}
end

PrintSchemaWithDirectives.makeDirectiveNode = makeDirectiveNode

makeDirectiveNodes = function(object, directivesInExtensions)
	local directiveNodes = {}

	for k in directivesInExtensions do
		local item = directivesInExtensions[tostring(k)]
		local v

		if typeof(object) == "table" then
			v = object:getDirective(k)
		end

		if Array.isArray(item) and #item ~= 0 then
			for _, v2 in item do
				table.insert(directiveNodes, makeDirectiveNode(k, v2, v))
			end
		else
			table.insert(directiveNodes, makeDirectiveNode(k, item, v))
		end
	end

	return directiveNodes
end

PrintSchemaWithDirectives.makeDirectiveNodes = makeDirectiveNodes
return PrintSchemaWithDirectives
