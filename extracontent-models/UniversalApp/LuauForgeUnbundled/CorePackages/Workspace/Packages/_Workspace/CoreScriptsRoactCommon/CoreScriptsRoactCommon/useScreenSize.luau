local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")

return function()
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(workspace.CurrentCamera)

	React.useEffect(function()
		local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			setState2(workspace.CurrentCamera)
		end)

		setState2(workspace.CurrentCamera)

		return function()
			currentCameraChangedConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if not state2 then
			return
		end

		setState(state2.ViewportSize)
		local viewportSizeChangedConnection = state2:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			setState(state2.ViewportSize)
		end)

		return function()
			viewportSizeChangedConnection:Disconnect()
		end
	end, { state2 })

	return state
end
