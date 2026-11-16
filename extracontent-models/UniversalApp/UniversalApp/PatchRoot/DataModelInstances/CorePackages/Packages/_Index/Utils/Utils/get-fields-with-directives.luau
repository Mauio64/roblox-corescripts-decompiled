local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local GetFieldsWithDirectives = {}
local GraphQL = require(parent.GraphQL)

local valueFromASTUntyped = GraphQL.valueFromASTUntyped

require(script.Parent.types)

function GetFieldsWithDirectives.getFieldsWithDirectives(p, p2)
	local v = p2 == nil and {} or p2
	local fields = {}
	local joined = { "ObjectTypeDefinition", "ObjectTypeExtension" }

	if Boolean.toJSBoolean(v.includeInputTypes) then
		joined = Array.concat({}, joined, { "InputObjectTypeDefinition", "InputObjectTypeExtension" })
	end

	local filtered = Array.filter(p.definitions, function(p3)
		return Array.includes(joined, p3.kind)
	end)

	for _, v2 in filtered do
		local value = v2.name.value

		if v2.fields == nil then
			continue
		end

		for _, field in v2.fields do
			if not (Boolean.toJSBoolean(field.directives) and #field.directives > 0) then
				continue
			end

			local value2 = field.name.value
			local formatted = ("%s.%s"):format(tostring(value), (tostring(value2)))
			local mapped = Array.map(field.directives, function(p3)
				return {
					name = p3.name.value,
					args = Array.reduce(Boolean.toJSBoolean(p3.arguments) and p3.arguments or {}, function(p4, p5)
						return Object.assign({}, p4, {
							[p5.name.value] = valueFromASTUntyped(p5.value, nil)
						})
					end, {})
				}
			end)

			fields[tostring(formatted)] = mapped
		end
	end

	return fields
end
return GetFieldsWithDirectives
