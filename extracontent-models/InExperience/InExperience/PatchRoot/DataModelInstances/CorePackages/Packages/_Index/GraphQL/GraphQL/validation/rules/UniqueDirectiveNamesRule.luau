local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	UniqueDirectiveNamesRule = function(p1) -- line: 19
		-- upvalues: GraphQLError (copy)
		local t1 = {}
		local v5 = p1:getSchema()

		return {
			DirectiveDefinition = function(_, p3) -- line: 24
				-- upvalues: v5 (copy), p1 (copy), GraphQLError (copy), t1 (copy)
				local value = p3.name.value

				if v5 and v5:getDirective(value) then
					p1:reportError(GraphQLError.new(("Directive \"@%s\" already exists in the schema. It cannot be redefined."):format(value), p3.name))

					return
				end

				if t1[value] then
					p1:reportError(GraphQLError.new(("There can be only one directive named \"@%s\"."):format(value), {
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
