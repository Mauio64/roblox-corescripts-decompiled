local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function usePrevious(p1) -- line: 10
	-- upvalues: React (copy)
	local v5 = React.useRef(nil)

	React.useEffect(function() -- line: 12
		-- upvalues: v5 (copy), p1 (copy)
		v5.current = p1
	end)

	return v5.current
end

return usePrevious
