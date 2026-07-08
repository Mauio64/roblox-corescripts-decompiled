local function isSinkingGuiObject(p1) -- line: 3
	return p1.Visible and (p1.Active and p1.Interactable)
end

return isSinkingGuiObject
