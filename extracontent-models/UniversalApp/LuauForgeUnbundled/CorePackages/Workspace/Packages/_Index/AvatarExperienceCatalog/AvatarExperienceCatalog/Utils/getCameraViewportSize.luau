local function getCameraViewportSize()
	local currentCamera = workspace.CurrentCamera

	if currentCamera then
		return currentCamera.ViewportSize
	end

	return nil
end

return getCameraViewportSize
