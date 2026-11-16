local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local GetArgumentsWithDirectives = {}

require(script.Parent.types)

local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind

local valueFromASTUntyped = GraphQL.valueFromASTUntyped

local function isTypeWithFields(p): boolean
	return p.kind == Kind.OBJECT_TYPE_DEFINITION or p.kind == Kind.OBJECT_TYPE_EXTENSION
end

function GetArgumentsWithDirectives.getArgumentsWithDirectives(p)
	local filtered = Array.filter(p.definitions, isTypeWithFields)
	local arguments = {}

	for _, v in filtered do
		if v.fields == nil then
			continue
		end

		for _, field in v.fields do
			local arguments2

			if typeof(field.arguments) == "table" then
				arguments2 = field.arguments
			end

			local filtered2

			if arguments2 ~= nil then
				filtered2 = Array.filter(arguments2, function(p2)
					return Boolean.toJSBoolean(typeof(p2.directives) == "table" and #p2.directives or nil)
				end)
			end

			if not Boolean.toJSBoolean(typeof(filtered2) == "table" and #filtered2 or nil) then
				continue
			end

			arguments[tostring(("%s.%s"):format(tostring(v.name.value), (tostring(field.name.value))))] = {}

			local argument = arguments[tostring(("%s.%s"):format(tostring(v.name.value), (tostring(field.name.value))))]

			for _, v2 in filtered2 do
				local mapped = Array.map(v2.directives, function(p2)
					return {
						name = p2.name.value,
						args = Array.reduce(Boolean.toJSBoolean(p2.arguments) and p2.arguments or {}, function(p3, p4)
							return Object.assign({}, p3, {
								[p4.name.value] = valueFromASTUntyped(p4.value, {})
							})
						end, {})
					}
				end)

				argument[tostring(v2.name.value)] = mapped
			end
		end
	end

	return arguments
end
return GetArgumentsWithDirectives
