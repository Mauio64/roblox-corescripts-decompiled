local function getCameraViewportSize()
	local currentCamera = workspace.CurrentCamera
	return if currentCamera then currentCamera.ViewportSize else nil
end

return getCameraViewportSize
