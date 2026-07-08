local ParentParent = script.Parent.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array

return {
	filterInPlace = function(p1, p2: ((...any) -> ...any), p3) -- line: 23
		-- upvalues: Array (copy)
		local n1 = 1

		Array.forEach(p1, function(p4, p5) -- line: 25
			-- upvalues: p2 (copy), p1 (copy), n1 (ref)
			if p2(p4, p5, p1) then
				p1[n1] = p4
				n1 += 1
			end
		end, p3)
		p1[n1] = nil

		return p1
	end
}
