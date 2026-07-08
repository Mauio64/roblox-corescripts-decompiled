local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	UniqueVariableNamesRule = function(p1) -- line: 19
		-- upvalues: GraphQLError (copy)
		local t1 = {}

		return {
			OperationDefinition = function() -- line: 22
				-- upvalues: t1 (ref)
				t1 = {}
			end,
			VariableDefinition = function(_, p3) -- line: 25
				-- upvalues: t1 (ref), p1 (copy), GraphQLError (copy)
				local value = p3.variable.name.value

				if t1[value] then
					p1:reportError(GraphQLError.new(("There can be only one variable named \"$%s\"."):format(value), {
						t1[value],
						p3.variable.name
					}))

					return
				end

				t1[value] = p3.variable.name
			end
		}
	end
}
