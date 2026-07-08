local ParentParent = script.Parent.Parent.Parent
local String = require(ParentParent.LuauPolyfill).String

require(script.Parent.source)

return {
	getLocation = function(p1, n1: number) -- line: 27
		-- upvalues: String (copy)
		local t1 = {
			"\r\n",
			"\r",
			"\n"
		}
		local n2 = 1
		local v7 = n1
		local v8 = String.findOr(p1.body, t1)

		while v8 ~= nil and n1 > v8.index do
			local v9 = v8.index + string.len(v8.match)

			n2 += 1
			v7 = n1 + 1 - v9
			v8 = String.findOr(p1.body, t1, v9)
		end

		return {
			line = n2,
			column = v7
		}
	end
}
