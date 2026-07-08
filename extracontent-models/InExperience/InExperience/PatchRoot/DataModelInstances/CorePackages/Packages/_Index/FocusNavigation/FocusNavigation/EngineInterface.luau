local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local mockableWarn = require(ParentParent.FocusNavigationUtils).mockableWarn

require(script.Parent.types)

local ok, result = pcall(function() -- line: 13
	-- upvalues: GuiService (copy)
	return GuiService:GetPropertyChangedSignal("SelectedCoreObject")
end)
local ok2, result2 = pcall(function() -- line: 17
	return game:GetService("CoreGui")
end)
local t1 = {
	Connect = function() -- line: 23
		error("Could not access SelectedCoreObject signal; you may not have the correct permissions")
	end
}
local t2 = {
	getSelection = function() -- line: 30
		-- upvalues: GuiService (copy)
		return GuiService.SelectedCoreObject
	end,
	setSelection = function(p1) -- line: 33
		-- upvalues: ok2 (copy), result2 (copy), mockableWarn (copy), GuiService (copy)
		if _G.__DEV__ and (ok2 and p1 ~= nil and not p1:IsDescendantOf(result2)) then
			mockableWarn(string.format("Attempting to focus non-CoreGui descendant '%s' from a CoreGui FocusNavigationService instance. Consider creating this FocusNavigationService with `FocusNavigation.EnginInterface.PlayerGui` instead", p1:GetFullName()))
		end

		if p1 and not p1.Selectable then
			GuiService:Select(p1)

			return
		end

		GuiService.SelectedCoreObject = p1
	end,
	SelectionChanged = if not ok then t1 else result,
	InputBegan = UserInputService.InputBegan,
	InputChanged = UserInputService.InputChanged,
	InputEnded = UserInputService.InputEnded,
	LastInputTypeChanged = UserInputService.LastInputTypeChanged
}
local t3 = {
	getSelection = function() -- line: 60
		-- upvalues: GuiService (copy)
		return GuiService.SelectedObject
	end,
	setSelection = function(p2) -- line: 63
		-- upvalues: ok2 (copy), result2 (copy), mockableWarn (copy), GuiService (copy)
		if _G.__DEV__ and (ok2 and p2 ~= nil and p2:IsDescendantOf(result2)) then
			mockableWarn(string.format("Attempting to focus CoreGui descendant '%s' from a non-CoreGui FocusNavigationService instance.Consider creating this FocusNavigationService with `FocusNavigation.EnginInterface.CoreGui` instead", p2:GetFullName()))
		end

		if p2 and not p2.Selectable then
			GuiService:Select(p2)

			return
		end

		GuiService.SelectedObject = p2
	end,
	SelectionChanged = GuiService:GetPropertyChangedSignal("SelectedObject"),
	InputBegan = UserInputService.InputBegan,
	InputChanged = UserInputService.InputChanged,
	InputEnded = UserInputService.InputEnded,
	LastInputTypeChanged = UserInputService.LastInputTypeChanged
}

return {
	CoreGui = t2,
	PlayerGui = t3
}
