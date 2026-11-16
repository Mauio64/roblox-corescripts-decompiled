local parent = script:FindFirstAncestor("TiltLoadingScreen").Parent.Parent

local React = require(parent.React)

local function useViewportSettled(vector2: Vector2)
	local state, setState = React.useState(false)

	React.useEffect(function()
		setState(false)
		local thread = task.delay(0.1, function()
			setState(true)
		end)
		return function()
			pcall(task.cancel, thread)
		end
	end, { vector2.X, vector2.Y })

	return state
end

return useViewportSettled
