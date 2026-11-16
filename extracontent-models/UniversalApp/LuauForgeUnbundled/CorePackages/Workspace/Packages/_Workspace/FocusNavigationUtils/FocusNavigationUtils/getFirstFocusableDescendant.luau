local function getFirstFocusableDescendant(folder)
	for i, guiObject in folder:GetDescendants() do
		if guiObject:IsA("GuiObject") and guiObject.Selectable and guiObject.Visible then
			return guiObject
		end
	end

	return nil
end

return getFirstFocusableDescendant
