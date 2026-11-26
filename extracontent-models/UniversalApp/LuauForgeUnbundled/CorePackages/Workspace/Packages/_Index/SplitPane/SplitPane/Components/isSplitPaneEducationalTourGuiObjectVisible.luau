return function(guiObject): boolean
	if guiObject.Parent == nil then
		return false
	end

	while guiObject ~= nil do
		if guiObject:IsA("GuiObject") and not guiObject.Visible then
			return false
		end

		guiObject = guiObject.Parent
	end

	return true
end
