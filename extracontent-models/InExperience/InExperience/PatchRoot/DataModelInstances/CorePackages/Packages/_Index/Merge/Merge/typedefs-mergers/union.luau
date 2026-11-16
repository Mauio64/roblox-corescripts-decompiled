local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Union = {}
local GraphQL = require(parent.GraphQL)
local Kind = GraphQL.Kind

local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives
local mergenamedtypearray = require(script.Parent["merge-named-type-array"])
local mergeNamedTypeArray = mergenamedtypearray.mergeNamedTypeArray

require(script.Parent["merge-typedefs_types"])

function Union.mergeUnion(data, data2, p)
	if data2 then
		local v = {
			name = data.name,
			description = 0,
			directives = 0,
			kind = 0,
			loc = 0,
			types = 0
		}
		local description

		if Boolean.toJSBoolean(data.description) then
			description = data.description
		else
			description = data2.description
		end

		v.description = description

		v.directives = mergeDirectives(data.directives, data2.directives, p)
		local kind

		if
			p and Boolean.toJSBoolean(p.convertExtensions)
			or data.kind == "UnionTypeDefinition"
			or data2.kind == "UnionTypeDefinition"
		then
			kind = Kind.UNION_TYPE_DEFINITION
		else
			kind = Kind.UNION_TYPE_EXTENSION
		end

		v.kind = kind

		v.loc = data.loc
		v.types = mergeNamedTypeArray(data.types, data2.types, p)
		return v
	elseif p and Boolean.toJSBoolean(p.convertExtensions) then
		return (Object.assign({}, data, { kind = Kind.UNION_TYPE_DEFINITION }))
	else
		return data
	end
end
return Union
