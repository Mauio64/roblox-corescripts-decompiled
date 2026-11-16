local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Map = LuauPolyfill.Map

return {
	keyValMap = function(list, callback, callback2)
		local v = Map.new()

		for _, item in ipairs(list) do
			v:set(callback(item), callback2(item))
		end

		return v
	end
}
