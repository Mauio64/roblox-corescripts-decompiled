local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

return {
	filterInPlace = function(p, callback, p2)
		local v = 1
		Array.forEach(p, function(p3, p4)
			if callback(p3, p4, p) then
				p[v] = p3
				v += 1
			end
		end, p2)

		p[v] = nil
		return p
	end
}
