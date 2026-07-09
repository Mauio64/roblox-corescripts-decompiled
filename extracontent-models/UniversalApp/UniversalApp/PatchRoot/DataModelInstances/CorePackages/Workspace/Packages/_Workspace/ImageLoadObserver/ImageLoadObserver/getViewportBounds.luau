local Workspace = game:GetService("Workspace")

local function getViewportBounds(p1) -- line: 13
	-- upvalues: Workspace (copy)
	local LayerCollector = p1:FindFirstAncestorWhichIsA("LayerCollector")

	if LayerCollector then
		local AbsolutePosition = LayerCollector.AbsolutePosition

		return AbsolutePosition, AbsolutePosition + LayerCollector.AbsoluteSize
	end

	local CurrentCamera = Workspace.CurrentCamera

	if CurrentCamera then
		return Vector2.zero, CurrentCamera.ViewportSize
	end

	return Vector2.zero, Vector2.zero
end

return getViewportBounds
