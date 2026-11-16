local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Map = LuauPolyfill.Map

local isNillish = require(parent.luaUtils.isNillish)
local isNotNillish = isNillish.isNotNillish

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local definition = require(parent.type.definition)
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isInputObjectType = definition.isInputObjectType

local hasField
local UniqueFieldDefinitionNamesRule = {
	UniqueFieldDefinitionNamesRule = function(object)
		local schema = object:getSchema()

		local v = schema and schema:getTypeMap() or Map.new()
		local v2 = {}

		local function checkFieldUniqueness(_, p): boolean
			local value = p.name.value

			if not v2[value] then
				v2[value] = {}
			end

			local fields = p.fields or {}
			local names = v2[value]

			for _, field in ipairs(fields) do
				local value2 = field.name.value

				if hasField(v:get(value), value2) then
					object:reportError(graphQLError.new(
						("Field \"%s.%s\" already exists in the schema. It cannot also be defined in this type extension."):format(
							value,
							value2
						),
						field.name
					))
				elseif names[value2] then
					object:reportError(graphQLError.new(
						("Field \"%s.%s\" can only be defined once."):format(value, value2),
						{ names[value2], field.name }
					))
				else
					names[value2] = field.name
				end
			end

			return false
		end

		return {
			InputObjectTypeDefinition = checkFieldUniqueness,
			InputObjectTypeExtension = checkFieldUniqueness,
			InterfaceTypeDefinition = checkFieldUniqueness,
			InterfaceTypeExtension = checkFieldUniqueness,
			ObjectTypeDefinition = checkFieldUniqueness,
			ObjectTypeExtension = checkFieldUniqueness
		}
	end
}

hasField = function(object, value: string)
	if isObjectType(object) or isInterfaceType(object) or isInputObjectType(object) then
		return isNotNillish(object:getFields():get(value))
	end

	return false
end

return UniqueFieldDefinitionNamesRule
