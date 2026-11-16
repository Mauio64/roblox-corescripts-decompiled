local GuiService = game:GetService("GuiService")

local function toGuiSpace(vector2: Vector2, instance)
	local screenGui = instance:FindFirstAncestorWhichIsA("ScreenGui")

	if screenGui == nil or not screenGui.IgnoreGuiInset then
		return vector2
	end

	return vector2 + GuiService:GetGuiInset()
end

return toGuiSpace
