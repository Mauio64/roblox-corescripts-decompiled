local module = require("@luauforge/bundled/fJc")

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local function useClearFocusOnUnmount()
	return module.useEffect(function()
		return function()
			local focusedTextBox = UserInputService:GetFocusedTextBox()

			if focusedTextBox then
				focusedTextBox:ReleaseFocus()
			end

			if GuiService.SelectedObject ~= nil then
				GuiService.SelectedObject = nil
			end
		end
	end, {})
end

return useClearFocusOnUnmount
