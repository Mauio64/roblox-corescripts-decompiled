local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Enum2 = {}
local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind

local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives
local enumvalues = require(script.Parent["enum-values"])
local mergeEnumValues = enumvalues.mergeEnumValues

require(script.Parent["merge-typedefs_types"])

function Enum2.mergeEnum(data, data2, p)
	if Boolean.toJSBoolean(data2) then
		local v = {
			name = data.name,
			description = 0,
			kind = 0,
			loc = 0,
			directives = 0,
			values = 0
		}
		local description

		if Boolean.toJSBoolean(data.description) then
			description = data.description
		else
			description = data2.description
		end

		v.description = description

		v.kind = (p and Boolean.toJSBoolean(p.convertExtensions) or data.kind == "EnumTypeDefinition" or data2.kind == "EnumTypeDefinition")
			and "EnumTypeDefinition"
			or "EnumTypeExtension"

		v.loc = data.loc
		v.directives = mergeDirectives(data.directives, data2.directives, p)
		v.values = mergeEnumValues(data.values, data2.values, p)
		return v
	elseif p and Boolean.toJSBoolean(p.convertExtensions) then
		return (Object.assign({}, data, { kind = Kind.ENUM_TYPE_DEFINITION }))
	else
		return data
	end
end
return Enum2
