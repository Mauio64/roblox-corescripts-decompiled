local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Map = LuauPolyfill.Map

return {
	keyMapOrdered = function(list, callback)
		local v = Map.new()

		for i = 1, #list do
			local item = list[i]
			v:set(callback(item), item)
		end

		return v
	end
}
