local ParentParent = script.Parent.Parent.Parent
local Map = require(ParentParent.LuauPolyfill).Map

return {
	mapValueOrdered = function(p1, p2: ((...any) -> ...any)) -- line: 17
		-- upvalues: Map (copy)
		local v5 = Map.new()

		for _, v7 in p1 do
			local v8 = v7[1]

			v5:set(v8, p2(v7[2], v8))
		end

		return v5
	end
}
