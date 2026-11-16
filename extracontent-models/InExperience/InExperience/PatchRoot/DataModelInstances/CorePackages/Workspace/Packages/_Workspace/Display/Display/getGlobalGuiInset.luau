local GuiService = game:GetService("GuiService")

local function getGlobalGuiInset()
	local guiInset, v = GuiService:GetGuiInset()
	return { top = guiInset.Y, left = guiInset.X, bottom = v.Y, right = v.X }
end

return getGlobalGuiInset
