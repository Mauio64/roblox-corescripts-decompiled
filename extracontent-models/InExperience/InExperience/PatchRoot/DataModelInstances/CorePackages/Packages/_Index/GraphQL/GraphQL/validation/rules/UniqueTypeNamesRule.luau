local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	UniqueTypeNamesRule = function(object)
		local names = {}
		local schema = object:getSchema()

		local function checkTypeName(_, p)
			local value = p.name.value

			if schema and schema:getType(value) then
				object:reportError(graphQLError.new(
					("Type \"%s\" already exists in the schema. It cannot also be defined in this type definition."):format(value),
					p.name
				))

				return
			end

			if names[value] then
				object:reportError(graphQLError.new(("There can be only one type named \"%s\"."):format(value), {
					names[value],
					p.name
				}))
			else
				names[value] = p.name
			end

			return false
		end

		return {
			ScalarTypeDefinition = checkTypeName,
			ObjectTypeDefinition = checkTypeName,
			InterfaceTypeDefinition = checkTypeName,
			UnionTypeDefinition = checkTypeName,
			EnumTypeDefinition = checkTypeName,
			InputObjectTypeDefinition = checkTypeName
		}
	end
}
