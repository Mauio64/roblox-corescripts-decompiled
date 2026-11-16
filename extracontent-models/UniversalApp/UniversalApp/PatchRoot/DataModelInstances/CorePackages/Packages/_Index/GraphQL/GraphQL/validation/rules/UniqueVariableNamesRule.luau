local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	UniqueVariableNamesRule = function(object)
		local names = {}
		return {
			OperationDefinition = function()
				names = {}
			end,
			VariableDefinition = function(_, p)
				local value = p.variable.name.value

				if names[value] then
					object:reportError(graphQLError.new(
						("There can be only one variable named \"$%s\"."):format(value),
						{ names[value], p.variable.name }
					))
				else
					names[value] = p.variable.name
				end
			end
		}
	end
}
