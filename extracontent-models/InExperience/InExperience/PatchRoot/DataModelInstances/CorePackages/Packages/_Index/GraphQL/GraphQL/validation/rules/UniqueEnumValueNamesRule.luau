local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Map = LuauPolyfill.Map

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local definition = require(parent.type.definition)
local isEnumType = definition.isEnumType

return {
	UniqueEnumValueNamesRule = function(object)
		local schema = object:getSchema()

		local v = schema and schema:getTypeMap() or Map.new()
		local v2 = {}

		local function checkValueUniqueness(_, p): boolean
			local value = p.name.value

			if not v2[value] then
				v2[value] = {}
			end

			local values = p.values or {}
			local names = v2[value]

			for _, value2 in ipairs(values) do
				local value3 = value2.name.value

				local v3 = v:get(value)

				if isEnumType(v3) and v3:getValue(value3) then
					object:reportError(graphQLError.new(
						("Enum value \"%s.%s\" already exists in the schema. It cannot also be defined in this type extension."):format(
							value,
							value3
						),
						value2.name
					))
				elseif names[value3] then
					object:reportError(graphQLError.new(
						("Enum value \"%s.%s\" can only be defined once."):format(value, value3),
						{ names[value3], value2.name }
					))
				else
					names[value3] = value2.name
				end
			end

			return false
		end

		return {
			EnumTypeDefinition = checkValueUniqueness,
			EnumTypeExtension = checkValueUniqueness
		}
	end
}
