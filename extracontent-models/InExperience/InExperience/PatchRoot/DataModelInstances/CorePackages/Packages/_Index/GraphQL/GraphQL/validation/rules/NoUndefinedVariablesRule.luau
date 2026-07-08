local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	NoUndefinedVariablesRule = function(p1) -- line: 20
		-- upvalues: GraphQLError (copy)
		local t1 = {}

		return {
			OperationDefinition = {
				enter = function() -- line: 25
					-- upvalues: t1 (ref)
					t1 = {}
				end,
				leave = function(_, p3) -- line: 28
					-- upvalues: p1 (copy), t1 (ref), GraphQLError (copy)
					local v7 = p1:getRecursiveVariableUsages(p3)

					for _, v in ipairs(v7) do
						local node = v.node
						local value = node.name.value

						if t1[value] ~= true then
							p1:reportError(GraphQLError.new(p3.name and ("Variable \"$%s\" is not defined by operation \"%s\"."):format(value, p3.name.value) or ("Variable \"$%s\" is not defined."):format(value), {
								node,
								p3
							}))
						end
					end
				end
			},
			VariableDefinition = function(_, p5) -- line: 50
				-- upvalues: t1 (ref)
				t1[p5.variable.name.value] = true
			end
		}
	end
}
