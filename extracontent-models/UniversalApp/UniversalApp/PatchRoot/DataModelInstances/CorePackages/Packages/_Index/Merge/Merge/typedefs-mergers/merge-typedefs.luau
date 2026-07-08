local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local t1 = {}

require(script.Parent["merge-typedefs_types"])

local mergeGraphQLTypes = nil
local GraphQL = require(ParentParent.GraphQL)
local parse = GraphQL.parse
local Kind = GraphQL.Kind
local isSchema = GraphQL.isSchema
local isDefinitionNode = GraphQL.isDefinitionNode
local utils = require(script.Parent.utils)
local defaultStringComparator = utils.defaultStringComparator
local isSourceTypes = utils.isSourceTypes
local isStringTypes = utils.isStringTypes
local lib = require(script.Parent["merge-nodes"])
local mergeGraphQLNodes = lib.mergeGraphQLNodes
local schemaDefSymbol = lib.schemaDefSymbol
local Utils = require(ParentParent.Utils)
local getDocumentNodeFromSchema = Utils.getDocumentNodeFromSchema
local isDocumentNode = Utils.isDocumentNode
local resetComments = Utils.resetComments
local printWithComments = Utils.printWithComments
local DEFAULT_OPERATION_TYPE_NAME_MAP = require(script.Parent["schema-def"]).DEFAULT_OPERATION_TYPE_NAME_MAP

function t1.mergeTypeDefs(p1, p2) -- line: 159
	-- upvalues: resetComments (copy), Kind (copy), mergeGraphQLTypes (ref), Object (copy), printWithComments (copy)
	resetComments()

	local t2 = {
		kind = Kind.DOCUMENT,
		definitions = mergeGraphQLTypes(p1, Object.assign({}, {
			useSchemaDefinition = true,
			forceSchemaDefinition = false,
			throwOnConflict = false,
			commentDescriptions = false
		}, p2))
	}
	local v32 = if not p2 or not p2.commentDescriptions then t2 else printWithComments(t2)

	resetComments()

	return v32
end

local function visitTypeSources(p3, p4, p5, p6) -- line: 188
	-- upvalues: Set (copy), Boolean (copy), visitTypeSources (copy), Array (copy), isSchema (copy), getDocumentNodeFromSchema (copy), isStringTypes (copy), isSourceTypes (copy), parse (copy), isDefinitionNode (copy), isDocumentNode (copy), Error (copy)
	local v37 = if p5 == nil then {} else p5
	local v38 = if p6 == nil then Set.new() else p6

	if Boolean.toJSBoolean(if not Boolean.toJSBoolean(p3) then p3 else not Boolean.toJSBoolean(v38:has(p3))) then
		v38:add(p3)

		if typeof(p3) == "function" then
			visitTypeSources(p3(), p4, v37, v38)

			return v37
		end

		if Boolean.toJSBoolean(Array.isArray(p3)) then
			for _, v40 in p3 do
				visitTypeSources(v40, p4, v37, v38)
			end

			return v37
		end

		if Boolean.toJSBoolean(isSchema(p3)) then
			local v41 = getDocumentNodeFromSchema(p3, p4)

			visitTypeSources(v41.definitions, p4, v37, v38)

			return v37
		end

		local toJSBoolean = Boolean.toJSBoolean
		local v43 = isStringTypes(p3)

		if toJSBoolean(Boolean.toJSBoolean(v43) and v43 or isSourceTypes(p3)) then
			local v44 = parse(p3, p4)

			visitTypeSources(v44.definitions, p4, v37, v38)

			return v37
		end

		if Boolean.toJSBoolean(typeof(p3) == "table" and isDefinitionNode(p3)) then
			table.insert(v37, p3)

			return v37
		end

		if isDocumentNode(p3) then
			visitTypeSources(p3.definitions, p4, v37, v38)

			return v37
		end

		error(Error.new(("typeDefs must contain only strings, documents, schemas, or functions, got %s"):format((tostring((typeof(p3)))))))
	end

	return v37
end

function mergeGraphQLTypes(p7, p8) -- line: 262
	-- upvalues: resetComments (copy), visitTypeSources (copy), mergeGraphQLNodes (copy), Boolean (copy), schemaDefSymbol (copy), Kind (copy), DEFAULT_OPERATION_TYPE_NAME_MAP (copy), Array (copy), defaultStringComparator (copy)
	resetComments()

	local v47 = visitTypeSources(p7, p8)
	local v48 = mergeGraphQLNodes(v47, p8)

	if p8 and Boolean.toJSBoolean(p8.useSchemaDefinition) then
		local v49 = Boolean.toJSBoolean(v48:get(schemaDefSymbol)) and v48:get(schemaDefSymbol) or {
			kind = Kind.SCHEMA_DEFINITION,
			operationTypes = {}
		}
		local operationTypes = v49.operationTypes

		for v51 in DEFAULT_OPERATION_TYPE_NAME_MAP do
			local v52 = Array.find(operationTypes, function(p9) -- line: 288
				-- upvalues: v51 (copy)
				return p9.operation == v51
			end)

			if not Boolean.toJSBoolean(v52) then
				local v53 = v48:get(DEFAULT_OPERATION_TYPE_NAME_MAP[tostring(v51)])

				if v53 ~= nil and v53.name ~= nil then
					table.insert(operationTypes, {
						kind = Kind.OPERATION_TYPE_DEFINITION,
						type = {
							kind = Kind.NAMED_TYPE,
							name = v53.name
						},
						operation = v51
					})
				end
			end
		end

		if typeof(v49) == "table" and typeof(v49.operationTypes) == "table" and #v49.operationTypes > 0 then
			v48:set(schemaDefSymbol, v49)
		end
	end

	if p8 and Boolean.toJSBoolean(p8.forceSchemaDefinition) and (typeof(v48:get(schemaDefSymbol)) ~= "table" or typeof(v48:get(schemaDefSymbol).operationTypes) ~= "table" or not (#v48:get(schemaDefSymbol).operationTypes > 0)) then
		v48:set(schemaDefSymbol, {
			kind = Kind.SCHEMA_DEFINITION,
			operationTypes = {{
				operation = "query",
				kind = Kind.OPERATION_TYPE_DEFINITION,
				type = {
					kind = Kind.NAMED_TYPE,
					name = {
						value = "Query",
						kind = Kind.NAME
					}
				}
			}}
		})
	end

	local v54 = v48:values()

	if p8 and Boolean.toJSBoolean(p8.sort) then
		local v55 = if typeof(p8.sort) ~= "function" then defaultStringComparator else p8.sort

		Array.sort(v54, function(p10, p11) -- line: 392
			-- upvalues: v55 (copy)
			return v55(if typeof(p10.name) ~= "table" then nil else p10.name.value, if typeof(p11.name) ~= "table" then nil else p11.name.value)
		end)
	end

	return v54
end

t1.mergeGraphQLTypes = mergeGraphQLTypes

return t1
