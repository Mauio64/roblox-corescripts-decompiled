local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local Kind = require(ParentParent.GraphQL).Kind
local mergeDirectives = require(script.Parent.directives).mergeDirectives
local mergeEnumValues = require(script.Parent["enum-values"]).mergeEnumValues

require(script.Parent["merge-typedefs_types"])

function t1.mergeEnum(p1, p2, p3) -- line: 26
	-- upvalues: Boolean (copy), mergeDirectives (copy), mergeEnumValues (copy), Object (copy), Kind (copy)
	if Boolean.toJSBoolean(p2) then
		return {
			name = p1.name,
			description = if not Boolean.toJSBoolean(p1.description) then p2.description else p1.description,
			kind = not (not not p3 and Boolean.toJSBoolean(p3.convertExtensions)) and (p1.kind ~= "EnumTypeDefinition" and p2.kind ~= "EnumTypeDefinition") and "EnumTypeExtension" or "EnumTypeDefinition",
			loc = p1.loc,
			directives = mergeDirectives(p1.directives, p2.directives, p3),
			values = mergeEnumValues(p1.values, p2.values, p3)
		}
	end

	if p3 and Boolean.toJSBoolean(p3.convertExtensions) then
		return (Object.assign({}, p1, {
			kind = Kind.ENUM_TYPE_DEFINITION
		}))
	end

	return p1
end

return t1
