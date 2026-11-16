local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

return function()
	local currentCameraChangedConnection = nil
	local viewportSizeChangedConnection = nil
	local state, setState = React.useState(Vector2.new(0, 0))

	local function fn() -- 1 equivalent call inferred from this helper
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			setState(Vector2.new(currentCamera.ViewportSize.X, currentCamera.ViewportSize.Y))
		end
	end

	local function fn2()
		local currentCamera = workspace.CurrentCamera

		if viewportSizeChangedConnection then
			pcall(function()
				viewportSizeChangedConnection:Disconnect()
			end)
			viewportSizeChangedConnection = nil
		end

		if currentCamera then
			viewportSizeChangedConnection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn)
		end
	end

	React.useEffect(function()
		currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(fn2)
		fn2()
		fn() -- inferred equivalent call
		return function()
			if currentCameraChangedConnection then
				currentCameraChangedConnection:Disconnect()
			end

			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
			end
		end
	end, {})

	return state
end
