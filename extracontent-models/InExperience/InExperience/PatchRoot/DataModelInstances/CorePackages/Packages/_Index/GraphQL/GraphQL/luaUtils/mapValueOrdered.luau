local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Map = LuauPolyfill.Map

return {
	mapValueOrdered = function(items, callback)
		local v = Map.new()

		for _, item in items do
			local v2 = item[1]
			v:set(v2, callback(item[2], v2))
		end

		return v
	end
}
