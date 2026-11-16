local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local String = LuauPolyfill.String

require(script.Parent.source)

return {
	getLocation = function(p, p2: number)
		local v = { "\r\n", "\r", "\n" }

		local v2 = String.findOr(p.body, v)
		local column = p2
		local line = 1

		while v2 ~= nil and v2.index < p2 do
			local v3 = v2.index + string.len(v2.match)
			line += 1
			column = p2 + 1 - v3
			v2 = String.findOr(p.body, v, v3)
		end

		return { line = line, column = column }
	end
}
