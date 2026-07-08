local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	NoUnusedFragmentsRule = function(p1) -- line: 20
		-- upvalues: GraphQLError (copy)
		local t1 = {}
		local t2 = {}

		return {
			OperationDefinition = function(_, p3) -- line: 25
				-- upvalues: t1 (copy)
				table.insert(t1, p3)

				return false
			end,
			FragmentDefinition = function(_, p5) -- line: 29
				-- upvalues: t2 (copy)
				table.insert(t2, p5)

				return false
			end,
			Document = {
				leave = function() -- line: 34
					-- upvalues: t1 (copy), p1 (copy), t2 (copy), GraphQLError (copy)
					local t3 = {}

					for _, v in ipairs(t1) do
						for _, v2 in ipairs(p1:getRecursivelyReferencedFragments(v)) do
							t3[v2.name.value] = true
						end
					end

					for _, v in ipairs(t2) do
						local value = v.name.value

						if t3[value] ~= true then
							p1:reportError(GraphQLError.new(("Fragment \"%s\" is never used."):format(value), v))
						end
					end
				end
			}
		}
	end
}
