local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useRefToState(p1) -- line: 31
	-- upvalues: React (copy)
	local v5 = React.useRef(p1)

	v5.current = p1

	return v5
end

return useRefToState
