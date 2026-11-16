local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function usePrevious(current)
	local ref = React.useRef(nil)
	React.useEffect(function()
		ref.current = current
	end)
	return ref.current
end

return usePrevious
