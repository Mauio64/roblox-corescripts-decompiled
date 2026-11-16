local parent = script.Parent.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local definition = require(parent.type.definition)
local getNamedType = definition.getNamedType
local introspection = require(parent.type.introspection)
local isIntrospectionType = introspection.isIntrospectionType

return {
	NoSchemaIntrospectionCustomRule = function(object)
		return {
			Field = function(_, p)
				local namedType = getNamedType(object:getType())

				if namedType and isIntrospectionType(namedType) then
					object:reportError(graphQLError.new(
						("GraphQL introspection has been disabled, but the requested query contained the field \"%s\"."):format(p.name.value),
						p
					))
				end
			end
		}
	end
}
