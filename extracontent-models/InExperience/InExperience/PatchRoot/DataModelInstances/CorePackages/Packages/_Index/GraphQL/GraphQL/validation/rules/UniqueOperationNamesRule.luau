local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	UniqueOperationNamesRule = function(p1) -- line: 19
		-- upvalues: GraphQLError (copy)
		local t1 = {}

		return {
			OperationDefinition = function(_, p3) -- line: 22
				-- upvalues: t1 (copy), p1 (copy), GraphQLError (copy)
				local name = p3.name

				if name then
					if t1[name.value] then
						p1:reportError(GraphQLError.new(("There can be only one operation named \"%s\"."):format(name.value), {
							t1[name.value],
							name
						}))
					else
						t1[name.value] = name
					end
				end

				return false
			end,
			FragmentDefinition = function() -- line: 40
				return false
			end
		}
	end
}
