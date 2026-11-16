return function(callback)
	local v5 = nil

	local viewportSizeChangedConnection = nil

	local function fireCallback(p2)
		if p2 ~= v5 then
			v5 = p2
			callback(p2)
		end
	end

	local function onViewportSizeChanged()
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			local viewportSize = currentCamera.ViewportSize

			if viewportSize ~= v5 then
				v5 = viewportSize
				callback(viewportSize)
			end
		end
	end

	local function onCurrentCameraChanged()
		if viewportSizeChangedConnection then
			viewportSizeChangedConnection:Disconnect()
			viewportSizeChangedConnection = nil
		end

		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			viewportSizeChangedConnection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)
			local currentCamera2 = workspace.CurrentCamera

			if currentCamera2 then
				local viewportSize = currentCamera2.ViewportSize

				if viewportSize ~= v5 then
					v5 = viewportSize
					callback(viewportSize)
				end
			end
		end
	end

	local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

	if viewportSizeChangedConnection then
		viewportSizeChangedConnection:Disconnect()
		viewportSizeChangedConnection = nil
	end

	local currentCamera = workspace.CurrentCamera

	if currentCamera then
		viewportSizeChangedConnection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)
		local currentCamera2 = workspace.CurrentCamera

		if currentCamera2 then
			local viewportSize = currentCamera2.ViewportSize

			if viewportSize ~= v5 then
				v5 = viewportSize
				callback(viewportSize)
			end
		end
	end

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
