local parent = script.Parent.Parent.Parent

local React = require(parent.React)

local function useViewportSize()
	local currentCamera = workspace.CurrentCamera
	local v

	if currentCamera then
		v = currentCamera.ViewportSize
	else
		v = Vector2.new(1280, 720)
	end

	local state, setState = React.useState(v)

	React.useEffect(function()
		local currentCamera2 = workspace.CurrentCamera

		if not currentCamera2 then
			return function() end
		end

		setState(currentCamera2.ViewportSize)
		local viewportSizeChangedConnection = currentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			setState(currentCamera2.ViewportSize)
		end)
		return function()
			viewportSizeChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useViewportSize
