local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local function releaseAnyFocus()
	local focusedTextBox = UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end

	if GuiService.SelectedObject ~= nil then
		GuiService.SelectedObject = nil
	end
end

return releaseAnyFocus
