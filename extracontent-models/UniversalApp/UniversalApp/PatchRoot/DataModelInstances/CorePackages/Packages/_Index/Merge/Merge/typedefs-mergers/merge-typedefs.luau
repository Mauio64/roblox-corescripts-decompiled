local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set

local MergeTypedefs = {}

require(script.Parent["merge-typedefs_types"])

local mergeGraphQLTypes

local GraphQL = require(parent.GraphQL)

local parse = GraphQL.parse
local Kind = GraphQL.Kind
local isSchema = GraphQL.isSchema

local isDefinitionNode = GraphQL.isDefinitionNode

local utils = require(script.Parent.utils)

local defaultStringComparator = utils.defaultStringComparator
local isSourceTypes = utils.isSourceTypes
local isStringTypes = utils.isStringTypes
local mergenodes = require(script.Parent["merge-nodes"])

local mergeGraphQLNodes = mergenodes.mergeGraphQLNodes
local schemaDefSymbol = mergenodes.schemaDefSymbol

local Utils = require(parent.Utils)

local getDocumentNodeFromSchema = Utils.getDocumentNodeFromSchema

local isDocumentNode = Utils.isDocumentNode

local resetComments = Utils.resetComments
local printWithComments = Utils.printWithComments

local schemadef = require(script.Parent["schema-def"])
local DEFAULT_OPERATION_TYPE_NAME_MAP = schemadef.DEFAULT_OPERATION_TYPE_NAME_MAP

function MergeTypedefs.mergeTypeDefs(p, p2)
	resetComments()
	local v = {
		kind = Kind.DOCUMENT,
		definitions = mergeGraphQLTypes(
			p,
			Object.assign(
				{},
				{
					useSchemaDefinition = true,
					forceSchemaDefinition = false,
					throwOnConflict = false,
					commentDescriptions = false
				},
				p2
			)
		)
	}

	if p2 and p2.commentDescriptions then
		v = printWithComments(v)
	end

	resetComments()
	return v
end

local function visitTypeSources(callback, data, p, object)
	local callbacks = p == nil and {} or p

	if object == nil then
		object = Set.new()
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v

	if Boolean.toJSBoolean(callback) then
		v = not Boolean.toJSBoolean(object:has(callback))
	else
		v = callback
	end

	if not toJSBoolean(v) then
		return callbacks
	end

	object:add(callback)

	if typeof(callback) == "function" then
		visitTypeSources(callback(), data, callbacks, object)
		return callbacks
	end

	if Boolean.toJSBoolean(Array.isArray(callback)) then
		for _, item in callback do
			visitTypeSources(item, data, callbacks, object)
		end

		return callbacks
	else
		if Boolean.toJSBoolean(isSchema(callback)) then
			visitTypeSources(getDocumentNodeFromSchema(callback, data).definitions, data, callbacks, object)
			return callbacks
		end

		local toJSBoolean2 = Boolean.toJSBoolean
		local stringTypes = isStringTypes(callback)

		if toJSBoolean2(Boolean.toJSBoolean(stringTypes) and stringTypes or isSourceTypes(callback)) then
			visitTypeSources(parse(callback, data).definitions, data, callbacks, object)
			return callbacks
		end

		local toJSBoolean3 = Boolean.toJSBoolean
		local v2

		if typeof(callback) == "table" then
			v2 = isDefinitionNode(callback)
		else
			v2 = false
		end

		if toJSBoolean3(v2) then
			table.insert(callbacks, callback)
			return callbacks
		end

		if isDocumentNode(callback) then
			visitTypeSources(callback.definitions, data, callbacks, object)
			return callbacks
		end

		error(Error.new(("typeDefs must contain only strings, documents, schemas, or functions, got %s"):format((tostring((typeof(callback)))))))
	end

	return callbacks
end

mergeGraphQLTypes = function(p, data)
	resetComments()
	local v = mergeGraphQLNodes(visitTypeSources(p, data), data)

	if data and Boolean.toJSBoolean(data.useSchemaDefinition) then
		local v2 = Boolean.toJSBoolean(v:get(schemaDefSymbol)) and v:get(schemaDefSymbol)
			or { kind = Kind.SCHEMA_DEFINITION, operationTypes = {} }

		local operationTypes = v2.operationTypes

		for k in DEFAULT_OPERATION_TYPE_NAME_MAP do
			local v3 = Array.find(operationTypes, function(p2): boolean
				return p2.operation == k
			end)

			if Boolean.toJSBoolean(v3) then
				continue
			end

			local v4 = v:get(DEFAULT_OPERATION_TYPE_NAME_MAP[tostring(k)])

			if v4 ~= nil and v4.name ~= nil then
				table.insert(operationTypes, {
					kind = Kind.OPERATION_TYPE_DEFINITION,
					type = { kind = Kind.NAMED_TYPE, name = v4.name },
					operation = k
				})
			end
		end

		if typeof(v2) == "table" and typeof(v2.operationTypes) == "table" and #v2.operationTypes > 0 then
			v:set(schemaDefSymbol, v2)
		end
	end

	if
		data
		and Boolean.toJSBoolean(data.forceSchemaDefinition)
		and (typeof(v:get(schemaDefSymbol)) ~= "table" or typeof(v:get(schemaDefSymbol).operationTypes) ~= "table" or not (#v:get(schemaDefSymbol).operationTypes > 0))
	then
		v:set(schemaDefSymbol, {
			kind = Kind.SCHEMA_DEFINITION,
			operationTypes = {
				{
					kind = Kind.OPERATION_TYPE_DEFINITION,
					operation = "query",
					type = {
						kind = Kind.NAMED_TYPE,
						name = { kind = Kind.NAME, value = "Query" }
					}
				}
			}
		})
	end

	local values = v:values()

	if data and Boolean.toJSBoolean(data.sort) then
		local v2

		if typeof(data.sort) == "function" then
			v2 = data.sort
		else
			v2 = defaultStringComparator
		end

		Array.sort(values, function(p2, p3)
			local value

			if typeof(p2.name) == "table" then
				value = p2.name.value
			end

			local v3

			if typeof(p3.name) == "table" then
				v3 = p3.name.value
			end

			return v2(value, v3)
		end)
	end

	return values
end

MergeTypedefs.mergeGraphQLTypes = mergeGraphQLTypes
return MergeTypedefs
