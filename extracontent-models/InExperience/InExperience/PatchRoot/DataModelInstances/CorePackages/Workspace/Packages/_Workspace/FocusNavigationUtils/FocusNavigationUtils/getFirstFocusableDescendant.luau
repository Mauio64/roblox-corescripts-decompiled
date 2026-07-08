local function getFirstFocusableDescendant(p1) -- line: 1
	for _, descendant in p1:GetDescendants() do
		if descendant:IsA("GuiObject") and descendant.Selectable and descendant.Visible then
			return descendant
		end
	end

	return nil
end

return getFirstFocusableDescendant
