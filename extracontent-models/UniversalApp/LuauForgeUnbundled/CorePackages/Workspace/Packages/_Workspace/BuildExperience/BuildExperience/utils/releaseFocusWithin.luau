local UserInputService = game:GetService("UserInputService")

local function releaseFocusWithin(ancestor, p2): boolean
	local focusedTextBox = (p2 or UserInputService):GetFocusedTextBox()

	if ancestor == nil or focusedTextBox == nil or not focusedTextBox:IsDescendantOf(ancestor) then
		return false
	end

	focusedTextBox:ReleaseFocus()
	return true
end

return releaseFocusWithin
