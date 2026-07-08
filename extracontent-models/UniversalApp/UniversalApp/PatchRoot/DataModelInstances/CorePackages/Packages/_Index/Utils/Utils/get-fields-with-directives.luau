local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local valueFromASTUntyped = require(ParentParent.GraphQL).valueFromASTUntyped

require(script.Parent.types)

function t1.getFieldsWithDirectives(p1, t2: {[any]: any}?) -- line: 35
	-- upvalues: Boolean (copy), Array (copy), Object (copy), valueFromASTUntyped (copy)
	local v10 = if t2 == nil then {} else t2
	local t3 = {}
	local t4 = {
		"ObjectTypeDefinition",
		"ObjectTypeExtension"
	}

	if Boolean.toJSBoolean(v10.includeInputTypes) then
		t4 = Array.concat({}, t4, {
			"InputObjectTypeDefinition",
			"InputObjectTypeExtension"
		})
	end

	for _, v14 in (Array.filter(p1.definitions, function(p2) -- line: 45
		-- upvalues: Array (copy), t4 (ref)
		return Array.includes(t4, p2.kind)
	end)) do
		local value = v14.name.value

		if v14.fields ~= nil then
			for _, v17 in v14.fields do
				if Boolean.toJSBoolean(v17.directives) and #v17.directives > 0 then
					local value2 = v17.name.value
					local v19 = ("%s.%s"):format(tostring(value), (tostring(value2)))
					local v20 = Array.map(v17.directives, function(p3) -- line: 70
						-- upvalues: Array (copy), Boolean (copy), Object (copy), valueFromASTUntyped (copy)
						return {
							name = p3.name.value,
							args = Array.reduce(Boolean.toJSBoolean(p3.arguments) and p3.arguments or {}, function(t5: {[any]: any}, p4) -- line: 77
								-- upvalues: Object (copy), valueFromASTUntyped (copy)
								return Object.assign({}, t5, {
									[p4.name.value] = valueFromASTUntyped(p4.value, nil)
								})
							end, {})
						}
					end)

					t3[tostring(v19)] = v20
				end
			end
		end
	end

	return t3
end

return t1
