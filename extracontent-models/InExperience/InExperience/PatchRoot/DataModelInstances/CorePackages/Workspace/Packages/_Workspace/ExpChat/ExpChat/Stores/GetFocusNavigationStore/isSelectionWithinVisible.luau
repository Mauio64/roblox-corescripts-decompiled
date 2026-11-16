local function isSelectionWithinVisible(guiObject, ancestor): boolean
	if guiObject == nil or ancestor == nil or guiObject ~= ancestor and not guiObject:IsDescendantOf(ancestor) then
		return false
	end

	while guiObject ~= nil do
		if guiObject:IsA("GuiObject") and not guiObject.Visible then
			return false
		end

		if guiObject == ancestor then
			break
		end

		guiObject = guiObject.Parent
	end

	return true
end

return isSelectionWithinVisible
