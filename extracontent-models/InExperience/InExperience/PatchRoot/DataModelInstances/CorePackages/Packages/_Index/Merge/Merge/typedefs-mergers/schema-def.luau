local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local Kind = require(ParentParent.GraphQL).Kind
local mergeDirectives = require(script.Parent.directives).mergeDirectives

require(script.Parent["merge-typedefs_types"])

local t2 = {
	query = "Query",
	mutation = "Mutation",
	subscription = "Subscription"
}

t1.DEFAULT_OPERATION_TYPE_NAME_MAP = t2

local function mergeOperationTypes(p1, p2) -- line: 37
	-- upvalues: t2 (copy), Array (copy), Boolean (copy)
	local v13 = if p1 == nil then {} else p1
	local v14 = if p2 == nil then {} else p2
	local t3 = {}

	for _, v17 in t2 do
		local v18 = Array.find(v13, function(p3) -- line: 50
			-- upvalues: v17 (copy)
			return p3.operation == v17
		end)
		local v19 = Boolean.toJSBoolean(v18) and v18 or Array.find(v14, function(p4) -- line: 54
			-- upvalues: v17 (copy)
			return p4.operation == v17
		end)

		if v19 then
			table.insert(t3, v19)
		end
	end

	return t3
end

function t1.mergeSchemaDefs(p5, p6, p7) -- line: 66
	-- upvalues: Boolean (copy), Kind (copy), mergeDirectives (copy), mergeOperationTypes (copy), Object (copy)
	if Boolean.toJSBoolean(p6) then
		return {
			kind = if p5.kind ~= Kind.SCHEMA_DEFINITION and p6.kind ~= Kind.SCHEMA_DEFINITION then Kind.SCHEMA_EXTENSION else Kind.SCHEMA_DEFINITION,
			description = Boolean.toJSBoolean(p5.description) and p5.description or p6.description,
			directives = mergeDirectives(p5.directives, p6.directives, p7),
			operationTypes = mergeOperationTypes(p5.operationTypes, p6.operationTypes)
		}
	end

	if p7 and Boolean.toJSBoolean(p7.convertExtensions) then
		return (Object.assign({}, p5, {
			kind = Kind.SCHEMA_DEFINITION
		}))
	end

	return p5
end

return t1
