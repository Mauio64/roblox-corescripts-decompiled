local ancestor = script:FindFirstAncestor("ultimate-list")
local React = require(ancestor.Parent.React)

local function joinAndMapBindings(p1: ((...any) -> ...any), p2, p3, p4) -- line: 6
	-- upvalues: React (copy)
	return React.joinBindings({
		p2,
		p3,
		p4
	}):map(function(p5) -- line: 12
		-- upvalues: p1 (copy)
		return p1(unpack(p5))
	end)
end

return joinAndMapBindings
