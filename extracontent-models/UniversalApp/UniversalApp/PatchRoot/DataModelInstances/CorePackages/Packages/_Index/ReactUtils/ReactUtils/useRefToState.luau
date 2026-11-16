local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useRefToState(current)
	local ref = React.useRef(current)
	ref.current = current
	return ref
end

return useRefToState
