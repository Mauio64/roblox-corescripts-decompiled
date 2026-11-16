local function getTopmostFocusableDescendant(folder)
	local topmostFocusableDescendant = nil

	for i, guiObject in folder:GetDescendants() do
		if not (guiObject:IsA("GuiObject") and guiObject.Selectable and guiObject.Visible) then
			continue
		end

		local v5

		if
			topmostFocusableDescendant == nil
			or guiObject.AbsolutePosition.Y < topmostFocusableDescendant.AbsolutePosition.Y
		then
			v5 = true
		elseif guiObject.AbsolutePosition.Y == topmostFocusableDescendant.AbsolutePosition.Y then
			v5 = guiObject.AbsolutePosition.X < topmostFocusableDescendant.AbsolutePosition.X
		else
			v5 = false
		end

		if v5 then
			topmostFocusableDescendant = guiObject
		end
	end

	return topmostFocusableDescendant
end

return getTopmostFocusableDescendant
