local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")

local function useViewportSettled(p2)
	local state, setState = React.useState(false)

	React.useEffect(function()
		setState(false)
		local thread = task.delay(0.1, function()
			setState(true)
		end)
		return function()
			pcall(task.cancel, thread)
		end
	end, { p2.X, p2.Y })

	return state
end

return useViewportSettled
