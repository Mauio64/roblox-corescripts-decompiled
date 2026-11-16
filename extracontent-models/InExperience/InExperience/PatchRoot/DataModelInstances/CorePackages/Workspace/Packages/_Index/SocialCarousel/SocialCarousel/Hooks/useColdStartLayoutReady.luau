local parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(parent.React)

local function useColdStartLayoutReady(flag: boolean, vector2: Vector2, p: number, p2: number)
	local ref = React.useRef(not flag)
	local state, setState = React.useState(not ref.current)

	React.useEffect(function()
		if state or not ref.current then
			return
		end

		if not flag or vector2.X <= 1 or vector2.Y <= 1 or p <= 1 or p > vector2.X then
			return
		end

		local thread = task.delay(0.5, function()
			setState(true)
		end)
		return function()
			pcall(task.cancel, thread)
		end
	end, { state, flag, vector2.X, vector2.Y, p, p2 })

	return state
end

return useColdStartLayoutReady
