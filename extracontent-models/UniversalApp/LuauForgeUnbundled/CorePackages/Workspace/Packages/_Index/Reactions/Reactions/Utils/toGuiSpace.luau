local GuiService = game:GetService("GuiService")

local function toGuiSpace(p2, instance)
	local screenGui = instance:FindFirstAncestorWhichIsA("ScreenGui")

	if screenGui == nil or not screenGui.IgnoreGuiInset then
		return p2
	end

	return p2 + GuiService:GetGuiInset()
end

return toGuiSpace
