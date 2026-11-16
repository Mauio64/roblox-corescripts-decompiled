local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local Map = LuauPolyfill.Map

require(script.Parent["merge-typedefs_types"])

local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind

local kind = require(script.Parent.type)
local mergeType = kind.mergeType
local enum = require(script.Parent.enum)
local mergeEnum = enum.mergeEnum
local scalar = require(script.Parent.scalar)
local mergeScalar = scalar.mergeScalar
local union = require(script.Parent.union)
local mergeUnion = union.mergeUnion
local inputtype = require(script.Parent["input-type"])
local mergeInputType = inputtype.mergeInputType
local interface = require(script.Parent.interface)
local mergeInterface = interface.mergeInterface
local directives = require(script.Parent.directives)
local mergeDirective = directives.mergeDirective
local schemadef = require(script.Parent["schema-def"])
local mergeSchemaDefs = schemadef.mergeSchemaDefs
local Utils = require(parent.Utils)

local collectComment = Utils.collectComment

local function isNamedDefinitionNode(item): boolean -- 1 equivalent call inferred from this helper
	return Array.indexOf(Object.keys(item), "name") ~= -1
end

return {
	schemaDefSymbol = "SCHEMA_DEF_SYMBOL",
	["isNamedDefinitionNode"] = isNamedDefinitionNode,
	mergeGraphQLNodes = function(items, p)
		local v = Map.new()

		for _, item in items do
			if Boolean.toJSBoolean(isNamedDefinitionNode(item)) then -- inferred equivalent call
				local value

				if typeof(item.name) == "table" then
					value = item.name.value
				end

				if p and Boolean.toJSBoolean(p.commentDescriptions) then
					collectComment(item)
				end

				if value ~= nil then
					if
						p and typeof(p.exclusions) == "table" and Array.includes(p.exclusions, value .. ".*")
						or p and typeof(p.exclusions) == "table" and Array.includes(p.exclusions, value)
					then
						v:delete(value)
					else
						local kind2 = item.kind

						if kind2 == Kind.OBJECT_TYPE_DEFINITION or kind2 == Kind.OBJECT_TYPE_EXTENSION then
							v:set(value, mergeType(item, v:get(value), p))
						elseif kind2 == Kind.ENUM_TYPE_DEFINITION or kind2 == Kind.ENUM_TYPE_EXTENSION then
							v:set(value, mergeEnum(item, v:get(value), p))
						elseif kind2 == Kind.UNION_TYPE_DEFINITION or kind2 == Kind.UNION_TYPE_EXTENSION then
							v:set(value, mergeUnion(item, v:get(value), p))
						elseif kind2 == Kind.SCALAR_TYPE_DEFINITION or kind2 == Kind.SCALAR_TYPE_EXTENSION then
							v:set(value, mergeScalar(item, v:get(value), p))
						elseif
							kind2 == Kind.INPUT_OBJECT_TYPE_DEFINITION
							or kind2 == Kind.INPUT_OBJECT_TYPE_EXTENSION
						then
							v:set(value, mergeInputType(item, v:get(value), p))
						elseif kind2 == Kind.INTERFACE_TYPE_DEFINITION or kind2 == Kind.INTERFACE_TYPE_EXTENSION then
							v:set(value, mergeInterface(item, v:get(value), p))
						elseif kind2 == Kind.DIRECTIVE_DEFINITION then
							v:set(value, mergeDirective(item, (v:get(value))))
						end
					end
				end
			elseif item.kind == Kind.SCHEMA_DEFINITION or item.kind == Kind.SCHEMA_EXTENSION then
				v:set("SCHEMA_DEF_SYMBOL", mergeSchemaDefs(item, v:get("SCHEMA_DEF_SYMBOL"), p))
			end
		end

		return v
	end
}
