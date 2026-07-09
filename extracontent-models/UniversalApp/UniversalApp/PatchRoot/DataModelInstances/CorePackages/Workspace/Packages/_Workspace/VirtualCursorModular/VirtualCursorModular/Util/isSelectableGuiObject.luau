local function isSelectableGuiObject(p1) -- line: 3
	if not p1:IsA("GuiButton") and not p1:IsA("TextBox") then
		return false
	end

	if not p1.Active or not p1.Selectable then
		return false
	end

	if p1.AbsoluteSize.X == 0 or p1.AbsoluteSize.Y == 0 then
		return false
	end

	return true
end

return isSelectableGuiObject
