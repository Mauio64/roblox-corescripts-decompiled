local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	UniqueArgumentNamesRule = function(object)
		local names = {}

		return {
			Field = function()
				names = {}
			end,
			Directive = function()
				names = {}
			end,
			Argument = function(_, p): boolean
				local value = p.name.value

				if names[value] then
					object:reportError(graphQLError.new(
						("There can be only one argument named \"%s\"."):format(value),
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
