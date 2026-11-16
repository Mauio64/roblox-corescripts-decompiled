local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local ForEachDefaultValue = {}
local GraphQL = require(parent.GraphQL)
local getNamedType = GraphQL.getNamedType

local isObjectType = GraphQL.isObjectType
local isInputObjectType = GraphQL.isInputObjectType

require(script.Parent.Interfaces)

local String = LuauPolyfill.String

function ForEachDefaultValue.forEachDefaultValue(object, callback)
	local typeMap = object:getTypeMap()

	for _, kind in typeMap do
		local v = typeMap:get(kind[1])

		if String.startsWith(getNamedType(v).name, "__") then
			continue
		end

		if Boolean.toJSBoolean(isObjectType(v)) then
			local fields = v:getFields()

			for _, field in fields do
				for _, arg in fields:get(field[1]).args do
					arg.defaultValue = callback(arg.type, arg.defaultValue)
				end
			end
		elseif Boolean.toJSBoolean(isInputObjectType(v)) then
			local fields = v:getFields()

			for _, field in fields do
				local v2 = fields:get(field[1])

				v2.defaultValue = callback(v2.type, v2.defaultValue)
			end
		end
	end
end
return ForEachDefaultValue
