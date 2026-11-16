local Workspace = game:GetService("Workspace")

local function getViewportBounds(instance)
	local layerCollector = instance:FindFirstAncestorWhichIsA("LayerCollector")

	if layerCollector then
		local absolutePosition = layerCollector.AbsolutePosition
		return absolutePosition, absolutePosition + layerCollector.AbsoluteSize
	end

	local currentCamera = Workspace.CurrentCamera

	if currentCamera then
		return Vector2.zero, currentCamera.ViewportSize
	end

	return Vector2.zero, Vector2.zero
end

return getViewportBounds
