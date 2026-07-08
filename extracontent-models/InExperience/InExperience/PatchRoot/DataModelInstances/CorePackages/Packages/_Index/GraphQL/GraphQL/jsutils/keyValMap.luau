local ParentParent = script.Parent.Parent.Parent
local Map = require(ParentParent.LuauPolyfill).Map

return {
	keyValMap = function(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 32
		-- upvalues: Map (copy)
		local v6 = Map.new()

		for _, v in ipairs(p1) do
			v6:set(p2(v), p3(v))
		end

		return v6
	end
}
