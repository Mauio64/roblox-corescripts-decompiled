local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	UniqueTypeNamesRule = function(p1) -- line: 19
		-- upvalues: GraphQLError (copy)
		local t1 = {}
		local v5 = p1:getSchema()

		local function checkTypeName(_, p3) -- line: 25
			-- upvalues: v5 (copy), p1 (copy), GraphQLError (copy), t1 (copy)
			local value = p3.name.value

			if v5 and v5:getType(value) then
				p1:reportError(GraphQLError.new(("Type \"%s\" already exists in the schema. It cannot also be defined in this type definition."):format(value), p3.name))

				return
			end

			if t1[value] then
				p1:reportError(GraphQLError.new(("There can be only one type named \"%s\"."):format(value), {
					t1[value],
					p3.name
				}))
			else
				t1[value] = p3.name
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
