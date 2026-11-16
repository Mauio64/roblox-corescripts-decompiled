local parent = script.Parent.Parent.Parent

local React = require(parent.React)

return function()
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(workspace.CurrentCamera)

	React.useEffect(function()
		local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			setState2(workspace.CurrentCamera)
		end)

		if state2 then
			setState(state2.ViewportSize)
		end

		return function()
			currentCameraChangedConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if not state2 then
			return
		end

		local viewportSizeChangedConnection = state2:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if state2 then
				setState(state2.ViewportSize)
			end
		end)

		return function()
			viewportSizeChangedConnection:Disconnect()
		end
	end, { state2 })

	return state
end
