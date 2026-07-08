local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent
local React = require(Parent.React)

return function(p1: ((...any) -> ...any), p2) -- line: 6
	-- upvalues: React (copy)
	local v5 = React.useRef(false)

	React.useEffect(function() -- line: 9
		-- upvalues: p2 (copy), v5 (copy), p1 (copy)
		if p2 and not v5.current then
			p1()
			v5.current = true
		end
	end, { p2 })
end
