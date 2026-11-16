local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	NoUnusedFragmentsRule = function(object)
		local v = {}
		local v2 = {}

		return {
			OperationDefinition = function(_, p): boolean
				table.insert(v, p)
				return false
			end,
			FragmentDefinition = function(_, p): boolean
				table.insert(v2, p)
				return false
			end,
			Document = {
				leave = function()
					local set = {}

					for _, v3 in ipairs(v) do
						for _, v4 in ipairs(object:getRecursivelyReferencedFragments(v3)) do
							set[v4.name.value] = true
						end
					end

					for _, v3 in ipairs(v2) do
						local value = v3.name.value

						if set[value] ~= true then
							object:reportError(graphQLError.new(("Fragment \"%s\" is never used."):format(value), v3))
						end
					end
				end
			}
		}
	end
}
