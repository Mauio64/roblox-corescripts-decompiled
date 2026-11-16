local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	UniqueOperationNamesRule = function(object)
		local names = {}
		return {
			OperationDefinition = function(_, p): boolean
				local name = p.name

				if name then
					if names[name.value] then
						object:reportError(graphQLError.new(
							("There can be only one operation named \"%s\"."):format(name.value),
							{ names[name.value], name }
						))
					else
						names[name.value] = name
					end
				end

				return false
			end,
			FragmentDefinition = function(): boolean
				return false
			end
		}
	end
}
