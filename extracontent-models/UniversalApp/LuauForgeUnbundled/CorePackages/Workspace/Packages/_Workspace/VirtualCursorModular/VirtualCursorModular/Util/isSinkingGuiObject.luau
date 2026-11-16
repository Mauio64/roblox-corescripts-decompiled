local function isSinkingGuiObject(data)
	return data.Visible and data.Active and data.Interactable
end

return isSinkingGuiObject
