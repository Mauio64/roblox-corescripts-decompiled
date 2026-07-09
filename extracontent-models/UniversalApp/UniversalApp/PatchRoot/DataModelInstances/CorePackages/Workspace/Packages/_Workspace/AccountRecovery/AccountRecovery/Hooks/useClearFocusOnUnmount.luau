local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local React = require(Parent.React)
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local function useClearFocusOnUnmount() -- line: 9
	-- upvalues: React (copy), UserInputService (copy), GuiService (copy)
	return React.useEffect(function() -- line: 10
		-- upvalues: UserInputService (copy), GuiService (copy)
		return function() -- line: 11
			-- upvalues: UserInputService (copy), GuiService (copy)
			local FocusedTextBox = UserInputService:GetFocusedTextBox()

			if FocusedTextBox then
				FocusedTextBox:ReleaseFocus()
			end

			if GuiService.SelectedObject ~= nil then
				GuiService.SelectedObject = nil
			end
		end
	end, {})
end

return useClearFocusOnUnmount
