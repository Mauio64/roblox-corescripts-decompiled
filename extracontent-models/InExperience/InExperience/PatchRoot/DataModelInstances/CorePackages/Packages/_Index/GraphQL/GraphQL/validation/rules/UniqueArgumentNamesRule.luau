local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	UniqueArgumentNamesRule = function(p1) -- line: 20
		-- upvalues: GraphQLError (copy)
		local t1 = {}

		return {
			Field = function() -- line: 24
				-- upvalues: t1 (ref)
				t1 = {}
			end,
			Directive = function() -- line: 27
				-- upvalues: t1 (ref)
				t1 = {}
			end,
			Argument = function(_, p3) -- line: 30
				-- upvalues: t1 (ref), p1 (copy), GraphQLError (copy)
				local value = p3.name.value

				if t1[value] then
					p1:reportError(GraphQLError.new(("There can be only one argument named \"%s\"."):format(value), {
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
