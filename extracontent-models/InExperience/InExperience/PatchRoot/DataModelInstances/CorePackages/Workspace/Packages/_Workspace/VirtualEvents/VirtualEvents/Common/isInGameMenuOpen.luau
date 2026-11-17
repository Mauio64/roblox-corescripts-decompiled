local GuiService = game:GetService("GuiService")

local function isInGameMenuOpen()
	return GuiService.MenuIsOpen
end

return isInGameMenuOpen
