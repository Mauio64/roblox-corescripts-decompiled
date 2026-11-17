local parent = script.Parent.Parent
local jsutils = parent.jsutils
local err = parent.error
local language = parent.language
local kind = parent.type
local utilities = parent.utilities
local luaUtils = parent.luaUtils
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local instanceof = LuauPolyfill.instanceof

require(jsutils.ObjMap)

require(jsutils.PromiseOrValue)

local Promise = require(parent.Parent.Promise)

local null = require(luaUtils.null)
local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish

local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local memoize3 = require(jsutils.memoize3)
local memoize3_2 = memoize3.memoize3
local invariant = require(jsutils.invariant)
local invariant2 = invariant.invariant
local devAssert = require(jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local isPromise = require(jsutils.isPromise)
local isPromise2 = isPromise.isPromise
local isObjectLike = require(jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike
local promiseReduce = require(jsutils.promiseReduce)
local promiseReduce2 = promiseReduce.promiseReduce
local promiseForObject = require(jsutils.promiseForObject)
local promiseForObject2 = promiseForObject.promiseForObject
local Path = require(jsutils.Path)

local addPath = Path.addPath
local pathToArray = Path.pathToArray
local isIteratableObject = require(jsutils.isIteratableObject)
local isIteratableObject2 = isIteratableObject.isIteratableObject

require(err.formatError)

local GraphQLError = require(err.GraphQLError)

local graphQLError = GraphQLError.GraphQLError
local locatedError = require(err.locatedError)
local locatedError2 = locatedError.locatedError

require(language.ast)

local kinds = require(parent.language.kinds)
local kind2 = kinds.Kind

require(kind.schema)

local definition = require(kind.definition)

local validate = require(kind.validate)
local assertValidSchema = validate.assertValidSchema
local introspection = require(kind.introspection)
local schemaMetaFieldDef = introspection.SchemaMetaFieldDef
local typeMetaFieldDef = introspection.TypeMetaFieldDef
local typeNameMetaFieldDef = introspection.TypeNameMetaFieldDef
local directives = require(kind.directives)
local graphQLIncludeDirective = directives.GraphQLIncludeDirective
local graphQLSkipDirective = directives.GraphQLSkipDirective
local isObjectType = definition.isObjectType
local isAbstractType = definition.isAbstractType
local isLeafType = definition.isLeafType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType

local typeFromAST = require(utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST
local getOperationRootType = require(utilities.getOperationRootType)
local getOperationRootType2 = getOperationRootType.getOperationRootType

local values = require(script.Parent.values)
local getVariableValues = values.getVariableValues
local getArgumentValues = values.getArgumentValues
local getDirectiveValues = values.getDirectiveValues

local assertValidExecutionArguments
local buildExecutionContext
local collectFields
local buildResolveInfo
local fn
local fn2
local getFieldDef

local buildResponse
local executeOperation
local executeFieldsSerially
local executeFields
local shouldIncludeNode
local doesFragmentConditionMatch

local getFieldEntryKey
local resolveField
local handleFieldError
local completeValue
local completeListValue
local completeLeafValue
local completeAbstractValue
local ensureValidRuntimeType
local completeObjectValue
local invalidReturnTypeError
local collectAndExecuteSubfields

local v = nil

local function execute(data)
	local schema = data.schema
	local document = data.document
	local rootValue = data.rootValue
	local contextValue = data.contextValue
	local variableValues = data.variableValues
	local operationName = data.operationName
	local fieldResolver = data.fieldResolver
	local typeResolver = data.typeResolver

	assertValidExecutionArguments(schema, document, variableValues)

	local errors = buildExecutionContext(
		schema,
		document,
		rootValue,
		contextValue,
		variableValues,
		operationName,
		fieldResolver,
		typeResolver
	)

	if Array.isArray(errors) or not errors.schema then
		return { errors = errors }
	end

	local v2 = executeOperation(errors, errors.operation, rootValue)

	return buildResponse(errors, v2)
end

local function executeSync(p)
	local v2 = execute(p)

	if isPromise2(v2) then
		error(Error.new("GraphQL execution failed to complete synchronously."))
	end

	return v2
end

buildResponse = function(p, object)
	if isPromise2(object) then
		return object:andThen(function(p2)
			return buildResponse(p, p2)
		end)
	end

	if #p.errors == 0 then
		return { data = object }
	end

	return { errors = p.errors, data = object }
end

assertValidExecutionArguments = function(schema, document, variableValues)
	devAssert2(document, "Must provide document.")

	assertValidSchema(schema)

	devAssert2(
		variableValues == nil or isObjectLike2(variableValues),
		"Variables must be provided as an Object where each property is a variable value. Perhaps look to see if an unparsed JSON string was provided."
	)
end

buildExecutionContext = function(schema, document, rootValue, contextValue, variableValues, operationName: string?, fieldResolver, typeResolver)
	local operation = nil
	local definitions = {}

	for _, definition2 in ipairs(document.definitions) do
		if definition2.kind == kind2.OPERATION_DEFINITION then
			if operationName == nil then
				if operation ~= nil then
					return { graphQLError.new("Must provide operation name if query contains multiple operations.") }
				end

				operation = definition2
			elseif (definition2.name and definition2.name.value) == operationName then
				operation = definition2
			end
		elseif definition2.kind == kind2.FRAGMENT_DEFINITION then
			definitions[definition2.name.value] = definition2
		end
	end

	if operation then
		local variableDefinitions = operation.variableDefinitions or {}

		local variableValues2 = getVariableValues(schema, variableDefinitions, variableValues or {}, {
			maxErrors = 50
		})

		if variableValues2.errors then
			return variableValues2.errors
		end

		return {
			schema = schema,
			fragments = definitions,
			rootValue = rootValue,
			contextValue = contextValue,
			operation = operation,
			variableValues = variableValues2.coerced,
			fieldResolver = fieldResolver or fn2,
			typeResolver = typeResolver or fn,
			errors = {}
		}
	elseif operationName == nil then
		return { graphQLError.new("Must provide an operation.") }
	else
		return { graphQLError.new(("Unknown operation named \"%s\"."):format(operationName)) }
	end
end

executeOperation = function(p, operation, rootValue)
	local operationRootType = getOperationRootType2(p.schema, operation)
	local v2 = collectFields(p, operationRootType, operation.selectionSet, Map.new(), {})
	local success, result

	if operation.operation == "mutation" then
		success, result = pcall(executeFieldsSerially, p, operationRootType, rootValue, nil, v2)
	else
		success, result = pcall(executeFields, p, operationRootType, rootValue, nil, v2)
	end

	if isPromise2(result) then
		return result:andThen(nil, function(p2)
			table.insert(p.errors, p2)
			return Promise.resolve(null)
		end)
	end

	if success then
		return result
	end

	table.insert(p.errors, result)
	return null
end

executeFieldsSerially = function(p, p2, p3, p4, object)
	return promiseReduce2(object:keys(), function(p5, p6: string)
		local v2 = object[p6]
		local v3 = addPath(p4, p6, p2.name)
		local v4 = resolveField(p, p2, p3, v2, v3)

		if v4 == nil then
			return p5
		end

		if isPromise2(v4) then
			return v4:andThen(function(p7)
				p5[p6] = p7

				return p5
			end)
		end

		p5[p6] = v4

		return p5
	end, {})
end

executeFields = function(p, p2, p3, p4, object)
	local result = {}
	local flag = false

	for _, v2 in ipairs(object:keys()) do
		local v3 = object[v2]
		local v4 = addPath(p4, v2, p2.name)
		local v5 = resolveField(p, p2, p3, v3, v4)

		if v5 == nil then
			continue
		end

		result[v2] = v5

		if isPromise2(v5) then
			flag = true
		end
	end

	if flag then
		return promiseForObject2(result)
	end

	return result
end

collectFields = function(p, p2, selectionSet, p3, p4)
	for _, selection in ipairs(selectionSet.selections) do
		if selection.kind == kind2.FIELD then
			if shouldIncludeNode(p, selection) then
				local v2 = getFieldEntryKey(selection)

				if not p3[v2] then
					p3[v2] = {}
				end

				table.insert(p3[v2], selection)
			end
		elseif selection.kind == kind2.INLINE_FRAGMENT then
			if shouldIncludeNode(p, selection) and doesFragmentConditionMatch(p, selection, p2) then
				collectFields(p, p2, selection.selectionSet, p3, p4)
			end
		elseif selection.kind == kind2.FRAGMENT_SPREAD then
			local value = selection.name.value

			if not p4[value] and shouldIncludeNode(p, selection) then
				p4[value] = true
				local fragment = p.fragments[value]

				if fragment and doesFragmentConditionMatch(p, fragment, p2) then
					collectFields(p, p2, fragment.selectionSet, p3, p4)
				end
			end
		end
	end

	return p3
end

shouldIncludeNode = function(p, selection): boolean
	local directiveValues = getDirectiveValues(graphQLSkipDirective, selection, p.variableValues)

	if (directiveValues and directiveValues["if"]) == true then
		return false
	end

	local directiveValues2 = getDirectiveValues(graphQLIncludeDirective, selection, p.variableValues)

	return (directiveValues2 and directiveValues2["if"]) ~= false
end

doesFragmentConditionMatch = function(p, p2, p3)
	local typeCondition = p2.typeCondition

	if not typeCondition then
		return true
	end

	local v2 = typeFromAST2(p.schema, typeCondition)

	if v2 == p3 then
		return true
	end

	if isAbstractType(v2) then
		return p.schema:isSubType(v2, p3)
	end

	return false
end

getFieldEntryKey = function(selection)
	if selection.alias then
		return selection.alias.value
	end

	return selection.name.value
end

resolveField = function(data, p, p2, list, p3)
	local value = list[1].name.value

	local v2 = getFieldDef(data.schema, p, value)

	if not v2 then
		return
	end

	local kind3 = v2.type
	local v3

	if v2.resolve then
		v3 = v2.resolve
	else
		v3 = data.fieldResolver
	end

	local v4 = buildResolveInfo(data, v2, list, p, p3)

	local success, result = pcall(function()
		local v5 = v3(p2, getArgumentValues(v2, list[1], data.variableValues), data.contextValue, v4)
		local selected

		if isPromise2(v5) then
			selected = v5:andThen(function(p4)
				return completeValue(data, kind3, list, v4, p3, p4)
			end)
		else
			selected = completeValue(data, kind3, list, v4, p3, v5)
		end

		if isPromise2(selected) then
			return selected:andThen(nil, function(p4)
				local v6 = locatedError2(p4, list, pathToArray(p3))
				return handleFieldError(v6, kind3, data)
			end)
		end

		return selected
	end)

	if success then
		return result
	end

	local v5 = locatedError2(result, list, pathToArray(p3))
	return handleFieldError(v5, kind3, data)
end

buildResolveInfo = function(data, p, fieldNodes, parentType, path)
	return {
		fieldName = p.name,
		fieldNodes = fieldNodes,
		returnType = p.type,
		parentType = parentType,
		path = path,
		schema = data.schema,
		fragments = data.fragments,
		rootValue = data.rootValue,
		operation = data.operation,
		variableValues = data.variableValues
	}
end

handleFieldError = function(message, p, p2)
	if isNonNullType(p) then
		error(message)
	end

	table.insert(p2.errors, message)
	return null
end

completeValue = function(p, p2, p3, p4, p5, message)
	if instanceof(message, Error) then
		error(message)
	end

	if isNonNullType(p2) then
		local v2 = completeValue(p, p2.ofType, p3, p4, p5, message)

		if isNillish2(v2) then
			error(Error.new(("Cannot return null for non-nullable field %s.%s."):format(
				p4.parentType.name,
				p4.fieldName
			)))
		end

		return v2
	end

	if isNillish2(message) then
		return null
	end

	if isListType(p2) then
		return completeListValue(p, p2, p3, p4, p5, message)
	end

	if isLeafType(p2) then
		return completeLeafValue(p2, message)
	end

	if isAbstractType(p2) then
		return completeAbstractValue(p, p2, p3, p4, p5, message)
	end

	if isObjectType(p2) then
		return completeObjectValue(p, p2, p3, p4, p5, message)
	end

	invariant2(false, "Cannot complete value of unexpected output type: " .. inspect2(p2))

	assert(false, "Cannot complete value of unexpected output type: " .. inspect2(p2))
end

completeListValue = function(p, p2, p3, p4, p5, message)
	if instanceof(message, Set) then
		local v2 = {}

		for _, item in message do
			table.insert(v2, item)
		end

		message = v2
	end

	if not isIteratableObject2(message) then
		error(graphQLError.new(("Expected Iterable, but did not find one for field \"%s.%s\"."):format(
			p4.parentType.name,
			p4.fieldName
		)))
	end

	local ofType = p2.ofType
	local flag = false

	local v2 = false

	local mapped = Array.from(message, function(object, p6)
		local v3 = addPath(p5, p6, nil)

		local success, result = pcall(function()
			local selected

			if isPromise2(object) then
				selected = object:andThen(function(p7)
					return completeValue(p, ofType, p3, p4, v3, p7)
				end)
			else
				selected = completeValue(p, ofType, p3, p4, v3, object)
			end

			if isPromise2(selected) then
				flag = true

				return selected:andThen(nil, function(p7)
					local v4 = locatedError2(p7, p3, pathToArray(v3))
					return handleFieldError(v4, ofType, p)
				end)
			end

			v2 = true

			return selected
		end)

		if success then
			return result
		end

		local v4 = locatedError2(result, p3, pathToArray(v3))
		return handleFieldError(v4, ofType, p)
	end)

	if v2 and flag then
		mapped = Array.map(mapped, function(p6)
			if isPromise2(p6) then
				return p6
			end

			return (Promise.resolve(p6))
		end)
	end

	if flag then
		mapped = Promise.all(mapped)
	end

	return mapped
end

completeLeafValue = function(object, message)
	local serialized = object:serialize(message)

	if serialized == nil then
		error(Error.new(("Expected a value of type \"%s\" but "):format(inspect2(object)) .. ("received: %s"):format(inspect2(message))))
	end

	return serialized
end

completeAbstractValue = function(p, p2, p3, p4, p5, message)
	local v2 = if p2.resolveType then p2.resolveType else p.typeResolver

	local v3 = v2(message, p.contextValue, p4, p2)

	if isPromise2(v3) then
		return v3:andThen(function(p6)
			return completeObjectValue(p, ensureValidRuntimeType(p6, p, p2, p3, p4, message), p3, p4, p5, message)
		end)
	end

	return completeObjectValue(p, ensureValidRuntimeType(v3, p, p2, p3, p4, message), p3, p4, p5, message)
end

ensureValidRuntimeType = function(value, p, p2, p3, p4, p5)
	if value == nil then
		error(graphQLError.new(
			("Abstract type \"%s\" must resolve to an Object type at runtime for field \"%s.%s\". Either the \"%s\" type should provide a \"resolveType\" function or each possible type should provide an \"isTypeOf\" function."):format(
				p2.name,
				p4.parentType.name,
				p4.fieldName,
				p2.name
			),
			p3
		))
	end

	if isObjectType(value) then
		error(graphQLError.new("Support for returning GraphQLObjectType from resolveType was removed in graphql-js@16.0.0 please return type name instead."))
	end

	if typeof(value) ~= "string" then
		error(graphQLError.new(("Abstract type \"%s\" must resolve to an Object type at runtime for field \"%s.%s\" with "):format(
			p2.name,
			p4.parentType.name,
			p4.fieldName
		) .. ("value %s, received \"%s\"."):format(inspect2(p5), inspect2(value))))
	end

	local kind3 = p.schema:getType(value)

	if kind3 == nil then
		error(graphQLError.new(
			("Abstract type \"%s\" was resolve to a type \"%s\" that does not exist inside schema."):format(
				p2.name,
				value
			),
			p3
		))
	end

	if not isObjectType(kind3) then
		error(graphQLError.new(
			("Abstract type \"%s\" was resolve to a non-object type \"%s\"."):format(p2.name, value),
			p3
		))
	end

	if not p.schema:isSubType(p2, kind3) then
		error(graphQLError.new(
			("Runtime Object type \"%s\" is not a possible type for \"%s\"."):format(kind3.name, p2.name),
			p3
		))
	end

	return kind3
end

completeObjectValue = function(p, p2, p3, p4, p5, p6)
	if p2.isTypeOf ~= nil then
		local typeOf = p2.isTypeOf(p2, p6, p.contextValue, p4)

		if isPromise2(typeOf) then
			return typeOf:andThen(function(p7)
				if not p7 then
					error(invalidReturnTypeError(p2, p6, p3))
				end

				return collectAndExecuteSubfields(p, p2, p3, p5, p6)
			end)
		end

		if not typeOf then
			error(invalidReturnTypeError(p2, p6, p3))
		end
	end

	return collectAndExecuteSubfields(p, p2, p3, p5, p6)
end

invalidReturnTypeError = function(p, p2, p3)
	return graphQLError.new(("Expected value of type \"%s\" but got: %s."):format(p.name, inspect2(p2)), p3)
end

collectAndExecuteSubfields = function(p, p2, p3, p4, p5)
	local v2 = v(p, p2, p3)
	return executeFields(p, p2, p5, p4, v2)
end

local function _collectSubfields(p, p2, list)
	local subfields = Map.new()
	local v2 = {}

	for _, item in ipairs(list) do
		if item.selectionSet then
			subfields = collectFields(p, p2, item.selectionSet, subfields, v2)
		end
	end

	return subfields
end

v = memoize3_2(_collectSubfields)

fn = function(p, p2, p3, p4)
	if isObjectLike2(p) and typeof(p.__typename) == "string" then
		return p.__typename
	end

	local possibleTypes = p3.schema:getPossibleTypes(p4)
	local typeOfs = {}

	for i = 1, #possibleTypes do
		local possibleType = possibleTypes[i]

		if not possibleType.isTypeOf then
			continue
		end

		local typeOf = possibleType:isTypeOf(p, p2, p3)

		if isPromise2(typeOf) then
			typeOfs[i] = typeOf
		elseif typeOf then
			return possibleType.name
		end
	end

	if #typeOfs > 0 then
		return Promise.all(typeOfs):andThen(function(list)
			for i = 1, #list do
				if list[i] then
					return possibleTypes[i].name
				end
			end

			return nil
		end)
	end

	return nil
end

fn2 = function(callback, p, p2, p3)
	if not isObjectLike2(callback) and typeof(callback) ~= "function" then
		return nil
	end

	local v2 = callback[p3.fieldName]

	if typeof(v2) == "function" then
		return callback[p3.fieldName](callback, p, p2, p3)
	end

	return v2
end

getFieldDef = function(schema, object, value: string)
	if value == schemaMetaFieldDef.name and schema:getQueryType() == object then
		return schemaMetaFieldDef
	end

	if value == typeMetaFieldDef.name and schema:getQueryType() == object then
		return typeMetaFieldDef
	end

	if value == typeNameMetaFieldDef.name then
		return typeNameMetaFieldDef
	end

	return object:getFields():get(value)
end

return {
	execute = execute,
	executeSync = executeSync,
	assertValidExecutionArguments = assertValidExecutionArguments,
	buildExecutionContext = buildExecutionContext,
	collectFields = collectFields,
	buildResolveInfo = buildResolveInfo,
	getFieldDef = getFieldDef,
	defaultFieldResolver = fn2,
	defaultTypeResolver = fn
}
