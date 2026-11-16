local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	KnownFragmentNamesRule = function(object)
		return {
			FragmentSpread = function(_, p)
				local value = p.name.value

				if not object:getFragment(value) then
					object:reportError(graphQLError.new(("Unknown fragment \"%s\"."):format(value), p.name))
				end
			end
		}
	end
}
