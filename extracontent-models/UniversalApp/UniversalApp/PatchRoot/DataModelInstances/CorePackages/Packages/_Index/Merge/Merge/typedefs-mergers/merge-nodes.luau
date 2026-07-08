local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Map = LuauPolyfill.Map
local t1 = {}

require(script.Parent["merge-typedefs_types"])

local Kind = require(ParentParent.GraphQL).Kind
local mergeType = require(script.Parent.type).mergeType
local mergeEnum = require(script.Parent.enum).mergeEnum
local mergeScalar = require(script.Parent.scalar).mergeScalar
local mergeUnion = require(script.Parent.union).mergeUnion
local mergeInputType = require(script.Parent["input-type"]).mergeInputType
local mergeInterface = require(script.Parent.interface).mergeInterface
local mergeDirective = require(script.Parent.directives).mergeDirective
local mergeSchemaDefs = require(script.Parent["schema-def"]).mergeSchemaDefs
local collectComment = require(ParentParent.Utils).collectComment

t1.schemaDefSymbol = "SCHEMA_DEF_SYMBOL"

function t1.isNamedDefinitionNode(p1) -- line: 71
	-- upvalues: Array (copy), Object (copy)
	return Array.indexOf(Object.keys(p1), "name") ~= -1
end
function t1.mergeGraphQLNodes(p2, p3) -- line: 77
	-- upvalues: Map (copy), Boolean (copy), Array (copy), Object (copy), collectComment (copy), Kind (copy), mergeType (copy), mergeEnum (copy), mergeUnion (copy), mergeScalar (copy), mergeInputType (copy), mergeInterface (copy), mergeDirective (copy), mergeSchemaDefs (copy)
	local v21 = Map.new()

	for _, v23 in p2 do
		if Boolean.toJSBoolean(Array.indexOf(Object.keys(v23), "name") ~= -1) then
			local v24 = if typeof(v23.name) ~= "table" then nil else v23.name.value

			if p3 and Boolean.toJSBoolean(p3.commentDescriptions) then
				collectComment(v23)
			end

			if v24 ~= nil then
				if p3 and typeof(p3.exclusions) == "table" and Array.includes(p3.exclusions, v24 .. ".*") or p3 and typeof(p3.exclusions) == "table" and Array.includes(p3.exclusions, v24) then
					v21:delete(v24)
				else
					local kind = v23.kind

					if kind == Kind.OBJECT_TYPE_DEFINITION or kind == Kind.OBJECT_TYPE_EXTENSION then
						v21:set(v24, mergeType(v23, v21:get(v24), p3))
					elseif kind == Kind.ENUM_TYPE_DEFINITION or kind == Kind.ENUM_TYPE_EXTENSION then
						v21:set(v24, mergeEnum(v23, v21:get(v24), p3))
					elseif kind == Kind.UNION_TYPE_DEFINITION or kind == Kind.UNION_TYPE_EXTENSION then
						v21:set(v24, mergeUnion(v23, v21:get(v24), p3))
					elseif kind == Kind.SCALAR_TYPE_DEFINITION or kind == Kind.SCALAR_TYPE_EXTENSION then
						v21:set(v24, mergeScalar(v23, v21:get(v24), p3))
					elseif kind == Kind.INPUT_OBJECT_TYPE_DEFINITION or kind == Kind.INPUT_OBJECT_TYPE_EXTENSION then
						v21:set(v24, mergeInputType(v23, v21:get(v24), p3))
					elseif kind == Kind.INTERFACE_TYPE_DEFINITION or kind == Kind.INTERFACE_TYPE_EXTENSION then
						v21:set(v24, mergeInterface(v23, v21:get(v24), p3))
					elseif kind == Kind.DIRECTIVE_DEFINITION then
						v21:set(v24, mergeDirective(v23, (v21:get(v24))))
					end
				end
			end
		elseif v23.kind == Kind.SCHEMA_DEFINITION or v23.kind == Kind.SCHEMA_EXTENSION then
			v21:set("SCHEMA_DEF_SYMBOL", mergeSchemaDefs(v23, v21:get("SCHEMA_DEF_SYMBOL"), p3))
		end
	end

	return v21
end

return t1
