local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	UniqueFragmentNamesRule = function(p1) -- line: 19
		-- upvalues: GraphQLError (copy)
		local t1 = {}

		return {
			OperationDefinition = function() -- line: 23
				return false
			end,
			FragmentDefinition = function(_, p3) -- line: 26
				-- upvalues: t1 (copy), p1 (copy), GraphQLError (copy)
				local value = p3.name.value

				if t1[value] then
					p1:reportError(GraphQLError.new(("There can be only one fragment named \"%s\"."):format(value), {
						t1[value],
						p3.name
					}))
				else
					t1[value] = p3.name
				end

				return false
			end
		}
	end
}
