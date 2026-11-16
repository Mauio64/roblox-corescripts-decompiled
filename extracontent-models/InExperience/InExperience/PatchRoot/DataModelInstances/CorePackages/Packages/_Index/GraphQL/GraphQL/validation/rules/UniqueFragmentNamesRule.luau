local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	UniqueFragmentNamesRule = function(object)
		local names = {}

		return {
			OperationDefinition = function(): boolean
				return false
			end,
			FragmentDefinition = function(_, p): boolean
				local value = p.name.value

				if names[value] then
					object:reportError(graphQLError.new(
						("There can be only one fragment named \"%s\"."):format(value),
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
