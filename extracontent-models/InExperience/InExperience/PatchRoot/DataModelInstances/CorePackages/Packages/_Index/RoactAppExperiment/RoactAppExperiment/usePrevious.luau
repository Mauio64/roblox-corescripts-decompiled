local RoactAppExperiment = script:FindFirstAncestor("RoactAppExperiment")

local React = require(RoactAppExperiment.Parent.React)

local function usePrevious(current)
	local ref = React.useRef(nil)
	React.useEffect(function()
		ref.current = current
	end)
	return ref.current
end

return usePrevious
