local GuiService = game:GetService("GuiService")
local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local guiPositionToScreenPosition = require(AdGuiInteractivity.guiPositionToScreenPosition)
local v4 = game:DefineFastFlag("RemoveAdIntegrationsInputPositionOffset", false)

local function inputPositionToGuiPosition(vector2: Vector2, p1, p2) -- line: 11
	-- upvalues: GuiService (copy)
	if vector2 == Vector2.zero then
		return p2.AbsolutePosition + p2.AbsoluteSize / 2
	end

	if p1:IsA("BillboardGui") or p1:IsA("SurfaceGui") then
		return vector2 - GuiService:GetInsetArea(Enum.ScreenInsets.None).Min
	end

	return vector2
end

return function(p3, p4) -- line: 31
	-- upvalues: v4 (copy), guiPositionToScreenPosition (copy), inputPositionToGuiPosition (copy)
	local CurrentCamera = game.Workspace.CurrentCamera

	if not CurrentCamera then
		return Vector2.zero
	end

	local LayerCollector = p3:FindFirstAncestorWhichIsA("LayerCollector")

	if v4 then
		local v13 = CurrentCamera.ViewportSize / 2

		if not LayerCollector then
			return v13
		end

		local vector2 = Vector2.new(p4.Position.X, p4.Position.Y)

		if vector2 == Vector2.zero then
			vector2 = p3.AbsolutePosition + p3.AbsoluteSize / 2
		end

		return guiPositionToScreenPosition(LayerCollector, vector2, CurrentCamera) or v13
	end

	if LayerCollector then
		local v15 = inputPositionToGuiPosition(Vector2.new(p4.Position.X, p4.Position.Y), LayerCollector, p3)
		local v16 = guiPositionToScreenPosition(LayerCollector, v15, CurrentCamera)

		if v16 then
			return v16
		end
	end

	return CurrentCamera.ViewportSize / 2
end
