return function(callback)
	local v = nil

	local viewportSizeChangedConnection = nil

	local function fireCallback(viewportSize: Vector2) -- 1 equivalent call inferred from this helper
		if viewportSize ~= v then
			v = viewportSize
			callback(viewportSize)
		end
	end

	local function onViewportSizeChanged() -- 1 equivalent call inferred from this helper
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			fireCallback(currentCamera.ViewportSize) -- inferred equivalent call
		end
	end

	local function onCurrentCameraChanged() -- 1 equivalent call inferred from this helper
		if viewportSizeChangedConnection then
			viewportSizeChangedConnection:Disconnect()
			viewportSizeChangedConnection = nil
		end

		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			viewportSizeChangedConnection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)
			onViewportSizeChanged() -- inferred equivalent call
		end
	end

	local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)
	onCurrentCameraChanged() -- inferred equivalent call
	return function()
		if currentCameraChangedConnection then
			currentCameraChangedConnection:Disconnect()
			currentCameraChangedConnection = nil
		end

		if viewportSizeChangedConnection then
			viewportSizeChangedConnection:Disconnect()
			viewportSizeChangedConnection = nil
		end
	end
end
