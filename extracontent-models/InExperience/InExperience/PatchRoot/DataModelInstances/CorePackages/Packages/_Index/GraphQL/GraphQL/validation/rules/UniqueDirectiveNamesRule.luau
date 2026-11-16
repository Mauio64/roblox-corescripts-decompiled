local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	UniqueDirectiveNamesRule = function(object)
		local names = {}
		local schema = object:getSchema()

		return {
			DirectiveDefinition = function(_, p)
				local value = p.name.value

				if schema and schema:getDirective(value) then
					object:reportError(graphQLError.new(
						("Directive \"@%s\" already exists in the schema. It cannot be redefined."):format(value),
						p.name
					))

					return
				end

				if names[value] then
					object:reportError(graphQLError.new(
						("There can be only one directive named \"@%s\"."):format(value),
						{ names[value], p.name }
					))
				else
					names[value] = p.name
				end

				return false
			end
		}
	end
}
