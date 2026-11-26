local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")

local function useColdStartLayoutReady(p2, p3, p4, p5)
	local ref = React.useRef(not p2)
	local state, setState = React.useState(not ref.current)

	React.useEffect(function()
		if state or not ref.current then
			return
		end

		if not p2 or p3.X <= 1 or p3.Y <= 1 or p4 <= 1 or p4 > p3.X then
			return
		end

		local thread = task.delay(0.5, function()
			setState(true)
		end)
		return function()
			pcall(task.cancel, thread)
		end
	end, { state, p2, p3.X, p3.Y, p4, p5 })

	return state
end

return useColdStartLayoutReady
