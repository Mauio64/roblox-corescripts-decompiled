local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local Interface = {}

require(script.Parent["merge-typedefs_types"])

local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind

local fields = require(script.Parent.fields)
local mergeFields = fields.mergeFields
local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives

local mergenamedtypearray = require(script.Parent["merge-named-type-array"])
local mergeNamedTypeArray = mergenamedtypearray.mergeNamedTypeArray

function Interface.mergeInterface(data, data2, p)
	if Boolean.toJSBoolean(data2) then
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

			v.kind = (Boolean.toJSBoolean(p and p.convertExtensions) or data.kind == "InterfaceTypeDefinition" or data2.kind == "InterfaceTypeDefinition")
				and "InterfaceTypeDefinition"
				or "InterfaceTypeExtension"

			v.loc = data.loc
			v.fields = mergeFields(data, data.fields, data2.fields, p)
			v.directives = mergeDirectives(data.directives, data2.directives, p)
			local interfaces

			if Boolean.toJSBoolean(data.interfaces) then
				interfaces = mergeNamedTypeArray(data.interfaces, data2.interfaces, p)
			end

			v.interfaces = interfaces
			return v
		end)

		if not success then
			error(Error.new(("Unable to merge GraphQL interface \"%s\": %s"):format(
				tostring(data.name.value),
				(tostring(result.message))
			)))
		end

		return result
	else
		local toJSBoolean = Boolean.toJSBoolean
		local v

		if typeof(p) == "table" then
			v = p.convertExtensions
		end

		if toJSBoolean(v) then
			return (Object.assign({}, data, { kind = Kind.INTERFACE_TYPE_DEFINITION }))
		end

		return data
	end
end
return Interface
