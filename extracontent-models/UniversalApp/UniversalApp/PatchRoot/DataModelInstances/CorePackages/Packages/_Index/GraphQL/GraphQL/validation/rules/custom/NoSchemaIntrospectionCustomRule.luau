local ParentParent = script.Parent.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local getNamedType = require(ParentParent.type.definition).getNamedType
local isIntrospectionType = require(ParentParent.type.introspection).isIntrospectionType

return {
	NoSchemaIntrospectionCustomRule = function(p1) -- line: 27
		-- upvalues: getNamedType (copy), isIntrospectionType (copy), GraphQLError (copy)
		return {
			Field = function(_, p3) -- line: 29
				-- upvalues: getNamedType (copy), p1 (copy), isIntrospectionType (copy), GraphQLError (copy)
				local v8 = getNamedType(p1:getType())

				if v8 and isIntrospectionType(v8) then
					p1:reportError(GraphQLError.new(("GraphQL introspection has been disabled, but the requested query contained the field \"%s\"."):format(p3.name.value), p3))
				end
			end
		}
	end
}
