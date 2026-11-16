local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local ForEachField = {}
local GraphQL = require(parent.GraphQL)
local getNamedType = GraphQL.getNamedType

local isObjectType = GraphQL.isObjectType

require(script.Parent.Interfaces)

local String = LuauPolyfill.String

function ForEachField.forEachField(object, callback)
	local typeMap = object:getTypeMap()

	for _, kind in typeMap do
		local v = kind[1]

		local v2 = typeMap:get(v)

		if String.startsWith(getNamedType(v2).name, "__") or not isObjectType(v2) then
			continue
		end

		local fields = v2:getFields()

		for _, field in fields do
			local v3 = field[1]

			callback(fields:get(v3), v, v3)
		end
	end
end
return ForEachField
