local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Scalar = {}
local GraphQL = require(parent.GraphQL)
local Kind = GraphQL.Kind

local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives

require(script.Parent["merge-typedefs_types"])

function Scalar.mergeScalar(data, data2, p)
	if data2 then
		local v = {
			name = data.name,
			description = 0,
			kind = 0,
			loc = 0,
			directives = 0
		}
		local description

		if Boolean.toJSBoolean(data.description) then
			description = data.description
		else
			description = data2.description
		end

		v.description = description

		v.kind = (p and Boolean.toJSBoolean(p.convertExtensions) or data.kind == "ScalarTypeDefinition" or data2.kind == "ScalarTypeDefinition")
			and "ScalarTypeDefinition"
			or "ScalarTypeExtension"

		v.loc = data.loc
		v.directives = mergeDirectives(data.directives, data2.directives, p)
		return v
	elseif p and Boolean.toJSBoolean(p.convertExtensions) then
		return (Object.assign({}, data, { kind = Kind.SCALAR_TYPE_DEFINITION }))
	else
		return data
	end
end
return Scalar
