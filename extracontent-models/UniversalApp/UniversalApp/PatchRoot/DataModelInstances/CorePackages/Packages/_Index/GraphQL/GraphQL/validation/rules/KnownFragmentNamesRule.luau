local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	KnownFragmentNamesRule = function(p1) -- line: 19
		-- upvalues: GraphQLError (copy)
		return {
			FragmentSpread = function(_, p3) -- line: 21
				-- upvalues: p1 (copy), GraphQLError (copy)
				local value = p3.name.value

				if not p1:getFragment(value) then
					p1:reportError(GraphQLError.new(("Unknown fragment \"%s\"."):format(value), p3.name))
				end
			end
		}
	end
}
