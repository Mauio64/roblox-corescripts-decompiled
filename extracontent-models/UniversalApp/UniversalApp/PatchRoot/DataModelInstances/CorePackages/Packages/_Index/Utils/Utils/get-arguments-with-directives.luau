local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}

require(script.Parent.types)

local GraphQL = require(ParentParent.GraphQL)
local Kind = GraphQL.Kind
local valueFromASTUntyped = GraphQL.valueFromASTUntyped

local function isTypeWithFields(p1) -- line: 31
	-- upvalues: Kind (copy)
	return p1.kind == Kind.OBJECT_TYPE_DEFINITION or p1.kind == Kind.OBJECT_TYPE_EXTENSION
end

function t1.getArgumentsWithDirectives(p2) -- line: 38
	-- upvalues: Array (copy), isTypeWithFields (copy), Boolean (copy), Object (copy), valueFromASTUntyped (copy)
	local t2 = {}

	for _, v15 in (Array.filter(p2.definitions, isTypeWithFields)) do
		if v15.fields ~= nil then
			for _, v17 in v15.fields do
				local v18 = if typeof(v17.arguments) ~= "table" then nil else v17.arguments
				local v19 = if v18 == nil then nil else Array.filter(v18, function(p3) -- line: 62
					-- upvalues: Boolean (copy)
					return Boolean.toJSBoolean(if typeof(p3.directives) ~= "table" then nil else #p3.directives)
				end)

				if Boolean.toJSBoolean(if typeof(v19) ~= "table" then nil else #v19) then
					t2[tostring(("%s.%s"):format(tostring(v15.name.value), (tostring(v17.name.value))))] = {}

					local v20 = t2[tostring(("%s.%s"):format(tostring(v15.name.value), (tostring(v17.name.value))))]

					for _, v22 in v19 do
						local v23 = Array.map(v22.directives, function(p4) -- line: 84
							-- upvalues: Array (copy), Boolean (copy), Object (copy), valueFromASTUntyped (copy)
							return {
								name = p4.name.value,
								args = Array.reduce(Boolean.toJSBoolean(p4.arguments) and p4.arguments or {}, function(p5, p6) -- line: 91
									-- upvalues: Object (copy), valueFromASTUntyped (copy)
									return Object.assign({}, p5, {
										[p6.name.value] = valueFromASTUntyped(p6.value, {})
									})
								end, {})
							}
						end)

						v20[tostring(v22.name.value)] = v23
					end
				end
			end
		end
	end

	return t2
end

return t1
