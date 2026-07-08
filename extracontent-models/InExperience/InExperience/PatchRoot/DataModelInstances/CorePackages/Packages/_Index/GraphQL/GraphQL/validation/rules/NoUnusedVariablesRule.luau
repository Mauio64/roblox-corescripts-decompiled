local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	NoUnusedVariablesRule = function(p1) -- line: 20
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
					local t2 = {}
					local v8 = p1:getRecursiveVariableUsages(p3)

					for _, v in ipairs(v8) do
						t2[v.node.name.value] = true
					end

					for _, v in ipairs(t1) do
						local value = v.variable.name.value

						if t2[value] ~= true then
							p1:reportError(GraphQLError.new(p3.name and ("Variable \"$%s\" is never used in operation \"%s\"."):format(value, p3.name.value) or ("Variable \"$%s\" is never used."):format(value), v))
						end
					end
				end
			},
			VariableDefinition = function(_, p5) -- line: 55
				-- upvalues: t1 (ref)
				table.insert(t1, p5)
			end
		}
	end
}
