local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")

local guiPositionToScreenPosition = require(AdGuiInteractivity.guiPositionToScreenPosition)

return function(instance, p)
	local currentCamera = game.Workspace.CurrentCamera

	if not currentCamera then
		return Vector2.zero
	end

	local layerCollector = instance:FindFirstAncestorWhichIsA("LayerCollector")
	local halfViewportSize = currentCamera.ViewportSize / 2

	if not layerCollector then
		return halfViewportSize
	end

	local v = Vector2.new(p.Position.X, p.Position.Y)

	if v == Vector2.zero then
		v = instance.AbsolutePosition + instance.AbsoluteSize / 2
	end

	return guiPositionToScreenPosition(layerCollector, v, currentCamera) or halfViewportSize
end
