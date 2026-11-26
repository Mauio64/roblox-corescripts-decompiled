local GuiService = game:GetService("GuiService")

local function getGlobalGuiInset()
	local guiInset, v5 = GuiService:GetGuiInset()
	return { top = guiInset.Y, left = guiInset.X, bottom = v5.Y, right = v5.X }
end

return getGlobalGuiInset
