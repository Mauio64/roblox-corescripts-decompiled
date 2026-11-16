local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	NoUndefinedVariablesRule = function(object)
		local set = {}

		return {
			OperationDefinition = {
				enter = function()
					set = {}
				end,
				leave = function(_, p)
					local recursiveVariableUsages = object:getRecursiveVariableUsages(p)

					for _, recursiveVariableUsage in ipairs(recursiveVariableUsages) do
						local node = recursiveVariableUsage.node
						local value = node.name.value

						if set[value] ~= true then
							object:reportError(graphQLError.new(
								p.name and ("Variable \"$%s\" is not defined by operation \"%s\"."):format(
									value,
									p.name.value
								) or ("Variable \"$%s\" is not defined."):format(value),
								{ node, p }
							))
						end
					end
				end
			},
			VariableDefinition = function(_, p)
				set[p.variable.name.value] = true
			end
		}
	end
}
