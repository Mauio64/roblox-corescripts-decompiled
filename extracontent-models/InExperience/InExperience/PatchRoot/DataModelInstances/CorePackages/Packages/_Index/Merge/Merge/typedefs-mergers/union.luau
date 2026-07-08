local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local Kind = require(ParentParent.GraphQL).Kind
local mergeDirectives = require(script.Parent.directives).mergeDirectives
local mergeNamedTypeArray = require(script.Parent["merge-named-type-array"]).mergeNamedTypeArray

require(script.Parent["merge-typedefs_types"])

function t1.mergeUnion(p1, p2, p3) -- line: 26
	-- upvalues: Boolean (copy), mergeDirectives (copy), Kind (copy), mergeNamedTypeArray (copy), Object (copy)
	if p2 then
		return {
			name = p1.name,
			description = if not Boolean.toJSBoolean(p1.description) then p2.description else p1.description,
			directives = mergeDirectives(p1.directives, p2.directives, p3),
			kind = if not (not not p3 and Boolean.toJSBoolean(p3.convertExtensions)) and (p1.kind ~= "UnionTypeDefinition" and p2.kind ~= "UnionTypeDefinition") then Kind.UNION_TYPE_EXTENSION else Kind.UNION_TYPE_DEFINITION,
			loc = p1.loc,
			types = mergeNamedTypeArray(p1.types, p2.types, p3)
		}
	end

	if p3 and Boolean.toJSBoolean(p3.convertExtensions) then
		return (Object.assign({}, p1, {
			kind = Kind.UNION_TYPE_DEFINITION
		}))
	end

	return p1
end

return t1
