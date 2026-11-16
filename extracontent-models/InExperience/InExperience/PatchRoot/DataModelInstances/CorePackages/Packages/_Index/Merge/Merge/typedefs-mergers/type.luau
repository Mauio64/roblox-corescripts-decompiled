local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local Type = {}

require(script.Parent["merge-typedefs_types"])

local GraphQL = require(parent.GraphQL)
local Kind = GraphQL.Kind

local fields = require(script.Parent.fields)
local mergeFields = fields.mergeFields
local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives
local mergenamedtypearray = require(script.Parent["merge-named-type-array"])
local mergeNamedTypeArray = mergenamedtypearray.mergeNamedTypeArray

function Type.mergeType(data, data2, p)
	if data2 then
		local success, result = pcall(function()
			local v = {
				name = data.name,
				description = 0,
				kind = 0,
				loc = 0,
				fields = 0,
				directives = 0,
				interfaces = 0
			}
			local description

			if Boolean.toJSBoolean(data.description) then
				description = data.description
			else
				description = data2.description
			end

			v.description = description

			v.kind = p and Boolean.toJSBoolean(p.convertExtensions) and "ObjectTypeDefinition"
				or (data.kind == "ObjectTypeDefinition" or data2.kind == "ObjectTypeDefinition")
				and "ObjectTypeDefinition"
				or "ObjectTypeExtension"

			v.loc = data.loc
			v.fields = mergeFields(data, data.fields, data2.fields, p)
			v.directives = mergeDirectives(data.directives, data2.directives, p)
			v.interfaces = mergeNamedTypeArray(data.interfaces, data2.interfaces, p)
			return v
		end)

		if not success then
			error(Error.new(("Unable to merge GraphQL type \"%s\": %s"):format(
				tostring(data.name.value),
				(tostring(result.message))
			)))
		end

		return result
	elseif p and Boolean.toJSBoolean(p.convertExtensions) then
		return (Object.assign({}, data, { kind = Kind.OBJECT_TYPE_DEFINITION }))
	else
		return data
	end
end
return Type
