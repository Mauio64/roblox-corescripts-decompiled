local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	NoFragmentCyclesRule = function(object)
		local set = {}

		local fragmentSpreads = {}

		local v = {}
		local function detectCycleRecursive(p)
			if set[p.name.value] then
				return
			end

			local value = p.name.value
			set[value] = true

			local fragmentSpreads2 = object:getFragmentSpreads(p.selectionSet)

			if #fragmentSpreads2 == 0 then
				return
			end

			v[value] = #fragmentSpreads

			for _, fragmentSpread in ipairs(fragmentSpreads2) do
				local value2 = fragmentSpread.name.value
				local v2 = v[value2]

				table.insert(fragmentSpreads, fragmentSpread)

				if v2 == nil then
					local fragment = object:getFragment(value2)

					if fragment then
						detectCycleRecursive(fragment)
					end
				else
					local slice = Array.slice(fragmentSpreads, v2 + 1)
					local joined = table.concat(Array.map(Array.slice(slice, 1, #slice), function(p2)
						return "\"" .. p2.name.value .. "\""
					end), ", ")

					object:reportError(graphQLError.new(
						("Cannot spread fragment \"%s\" within itself"):format(value2) .. (joined == "" and "." or (" via %s."):format(joined) or "."),
						slice
					))
				end

				table.remove(fragmentSpreads)
			end

			v[value] = nil
		end

		return {
			OperationDefinition = function(): boolean
				return false
			end,
			FragmentDefinition = function(_, p): boolean
				detectCycleRecursive(p)
				return false
			end
		}
	end
}
