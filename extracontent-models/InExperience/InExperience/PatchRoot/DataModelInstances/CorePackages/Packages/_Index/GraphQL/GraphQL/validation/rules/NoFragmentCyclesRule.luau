local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	NoFragmentCyclesRule = function(p1) -- line: 18
		-- upvalues: Array (copy), GraphQLError (copy)
		local t1 = {}
		local t2 = {}
		local t3 = {}

		local function detectCycleRecursive(p2) -- line: 31
			-- upvalues: t1 (copy), p1 (copy), t3 (copy), t2 (copy), detectCycleRecursive (copy), Array (copy), GraphQLError (copy)
			if t1[p2.name.value] then
				return
			end

			local value = p2.name.value

			t1[value] = true

			local v12 = p1:getFragmentSpreads(p2.selectionSet)

			if #v12 == 0 then
				return
			end

			t3[value] = #t2

			for _, v in ipairs(v12) do
				local value2 = v.name.value
				local v16 = t3[value2]

				table.insert(t2, v)

				if v16 == nil then
					local v17 = p1:getFragment(value2)

					if v17 then
						detectCycleRecursive(v17)
					end
				else
					local v18 = Array.slice(t2, v16 + 1)
					local v19 = table.concat(Array.map(Array.slice(v18, 1, #v18), function(p3) -- line: 61
						return "\"" .. p3.name.value .. "\""
					end), ", ")

					p1:reportError(GraphQLError.new(("Cannot spread fragment \"%s\" within itself"):format(value2) .. (v19 ~= "" and (" via %s."):format(v19) or "."), v18))
				end

				table.remove(t2)
			end

			t3[value] = nil
		end

		return {
			OperationDefinition = function() -- line: 82
				return false
			end,
			FragmentDefinition = function(_, p5) -- line: 85
				-- upvalues: detectCycleRecursive (copy)
				detectCycleRecursive(p5)

				return false
			end
		}
	end
}
