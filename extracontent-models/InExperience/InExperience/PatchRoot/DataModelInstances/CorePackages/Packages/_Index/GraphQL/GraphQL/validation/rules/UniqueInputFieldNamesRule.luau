local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

require(ParentParent.language.visitor)
require(script.Parent.Parent.ValidationContext)

local language = ParentParent.language

require(language.ast)

return {
	UniqueInputFieldNamesRule = function(p1) -- line: 30
		-- upvalues: GraphQLError (copy)
		local t1 = {}
		local t2 = {}

		return {
			ObjectValue = {
				enter = function() -- line: 36
					-- upvalues: t1 (copy), t2 (ref)
					table.insert(t1, t2)
					t2 = {}
				end,
				leave = function() -- line: 40
					-- upvalues: t2 (ref), t1 (copy)
					t2 = table.remove(t1)
				end
			},
			ObjectField = function(_, p3) -- line: 45
				-- upvalues: t2 (ref), p1 (copy), GraphQLError (copy)
				local value = p3.name.value

				if t2[value] then
					p1:reportError(GraphQLError.new(("There can be only one input field named \"%s\"."):format(value), {
						t2[value],
						p3.name
					}))

					return
				end

				t2[value] = p3.name
			end
		}
	end
}
