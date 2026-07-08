local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local function releaseAnyFocus() -- line: 4
	-- upvalues: UserInputService (copy), GuiService (copy)
	local FocusedTextBox = UserInputService:GetFocusedTextBox()

	if FocusedTextBox then
		FocusedTextBox:ReleaseFocus()
	end

	if GuiService.SelectedObject ~= nil then
		GuiService.SelectedObject = nil
	end
end

return releaseAnyFocus
