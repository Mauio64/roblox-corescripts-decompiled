local ParentParent = script.Parent.Parent.Parent
local Map = require(ParentParent.LuauPolyfill).Map

return {
	keyMapOrdered = function(p1, p2: ((...any) -> ...any)) -- line: 37
		-- upvalues: Map (copy)
		local v5 = Map.new()

		for i = 1, #p1 do
			local v7 = p1[i]

			v5:set(p2(v7), v7)
		end

		return v5
	end
}
