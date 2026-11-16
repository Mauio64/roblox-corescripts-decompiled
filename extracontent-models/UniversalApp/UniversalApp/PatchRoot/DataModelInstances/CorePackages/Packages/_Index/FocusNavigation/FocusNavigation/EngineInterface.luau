local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local mockableWarn = FocusNavigationUtils.mockableWarn

require(script.Parent.types)

local success, result = pcall(function()
	return GuiService:GetPropertyChangedSignal("SelectedCoreObject")
end)

local success2, result2 = pcall(function()
	return game:GetService("CoreGui")
end)

return {
	CoreGui = {
		getSelection = function()
			return GuiService.SelectedCoreObject
		end,
		setSelection = function(selectedCoreObject)
			if
				_G.__DEV__
				and success2
				and selectedCoreObject ~= nil
				and not selectedCoreObject:IsDescendantOf(result2)
			then
				mockableWarn(string.format(
					"Attempting to focus non-CoreGui descendant '%s' from a CoreGui FocusNavigationService instance. Consider creating this FocusNavigationService with `FocusNavigation.EnginInterface.PlayerGui` instead",
					selectedCoreObject:GetFullName()
				))
			end

			if selectedCoreObject and not selectedCoreObject.Selectable then
				GuiService:Select(selectedCoreObject)
			else
				GuiService.SelectedCoreObject = selectedCoreObject
			end
		end,
		SelectionChanged = not success and {
			Connect = function()
				error("Could not access SelectedCoreObject signal; you may not have the correct permissions")
			end
		} or result,
		InputBegan = UserInputService.InputBegan,
		InputChanged = UserInputService.InputChanged,
		InputEnded = UserInputService.InputEnded,
		LastInputTypeChanged = UserInputService.LastInputTypeChanged
	},
	PlayerGui = {
		getSelection = function()
			return GuiService.SelectedObject
		end,
		setSelection = function(selectedObject)
			if _G.__DEV__ and success2 and selectedObject ~= nil and selectedObject:IsDescendantOf(result2) then
				mockableWarn(string.format(
					"Attempting to focus CoreGui descendant '%s' from a non-CoreGui FocusNavigationService instance.Consider creating this FocusNavigationService with `FocusNavigation.EnginInterface.CoreGui` instead",
					selectedObject:GetFullName()
				))
			end

			if selectedObject and not selectedObject.Selectable then
				GuiService:Select(selectedObject)
			else
				GuiService.SelectedObject = selectedObject
			end
		end,
		SelectionChanged = GuiService:GetPropertyChangedSignal("SelectedObject"),
		InputBegan = UserInputService.InputBegan,
		InputChanged = UserInputService.InputChanged,
		InputEnded = UserInputService.InputEnded,
		LastInputTypeChanged = UserInputService.LastInputTypeChanged
	}
}
