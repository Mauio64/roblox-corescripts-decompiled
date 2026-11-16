local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)
local Kind = GraphQL.Kind

local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives

require(script.Parent["merge-typedefs_types"])

local v = { query = "Query", mutation = "Mutation", subscription = "Subscription" }
local SchemaDef = {}
SchemaDef.DEFAULT_OPERATION_TYPE_NAME_MAP = v

local function mergeOperationTypes(operationTypes, operationTypes2)
	local v2 = operationTypes == nil and {} or operationTypes
	local v3 = operationTypes2 == nil and {} or operationTypes2
	local result = {}

	for _, v4 in v do
		local v5 = Array.find(v2, function(p): boolean
			return p.operation == v4
		end)

		local v6 = Boolean.toJSBoolean(v5) and v5 or Array.find(v3, function(p): boolean
			return p.operation == v4
		end)

		if v6 then
			table.insert(result, v6)
		end
	end

	return result
end

function SchemaDef.mergeSchemaDefs(data, data2, p)
	if Boolean.toJSBoolean(data2) then
		local kind

		if data.kind == Kind.SCHEMA_DEFINITION or data2.kind == Kind.SCHEMA_DEFINITION then
			kind = Kind.SCHEMA_DEFINITION
		else
			kind = Kind.SCHEMA_EXTENSION
		end

		return {
			kind = kind,
			description = Boolean.toJSBoolean(data.description) and data.description or data2.description,
			directives = mergeDirectives(data.directives, data2.directives, p),
			operationTypes = mergeOperationTypes(data.operationTypes, data2.operationTypes)
		}
	elseif p and Boolean.toJSBoolean(p.convertExtensions) then
		return (Object.assign({}, data, { kind = Kind.SCHEMA_DEFINITION }))
	else
		return data
	end
end
return SchemaDef
