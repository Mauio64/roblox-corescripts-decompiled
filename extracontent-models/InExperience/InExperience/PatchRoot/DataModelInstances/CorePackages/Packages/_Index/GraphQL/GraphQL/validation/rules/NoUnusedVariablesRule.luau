local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	NoUnusedVariablesRule = function(object)
		local v = {}

		return {
			OperationDefinition = {
				enter = function()
					v = {}
				end,
				leave = function(_, p)
					local recursiveVariableUsages = object:getRecursiveVariableUsages(p)
					local set = {}

					for _, recursiveVariableUsage in ipairs(recursiveVariableUsages) do
						set[recursiveVariableUsage.node.name.value] = true
					end

					for _, v2 in ipairs(v) do
						local value = v2.variable.name.value

						if set[value] ~= true then
							object:reportError(graphQLError.new(
								p.name and ("Variable \"$%s\" is never used in operation \"%s\"."):format(
									value,
									p.name.value
								) or ("Variable \"$%s\" is never used."):format(value),
								v2
							))
						end
					end
				end
			},
			VariableDefinition = function(_, p)
				table.insert(v, p)
			end
		}
	end
}
