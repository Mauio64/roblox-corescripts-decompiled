local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)

return function(p1: ((...any) -> ...any)) -- line: 10
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 11
		-- upvalues: p1 (copy)
		p1()
	end, {})
end
