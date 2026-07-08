local RoactAppExperiment = script:FindFirstAncestor("RoactAppExperiment")
local React = require(RoactAppExperiment.Parent.React)

local function usePrevious(p1) -- line: 9
	-- upvalues: React (copy)
	local v5 = React.useRef(nil)

	React.useEffect(function() -- line: 11
		-- upvalues: v5 (copy), p1 (copy)
		v5.current = p1
	end)

	return v5.current
end

return usePrevious
