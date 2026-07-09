local VirtualInputManager = game:GetService("VirtualInputManager")

local function isAncestorInteractable(p1) -- line: 24
	local p1Parent = p1.Parent

	while p1Parent do
		if p1Parent:IsA("GuiObject") and p1Parent.Interactable == false then
			return false
		end

		p1Parent = p1Parent.Parent
	end

	return true
end

return function(p2, p3) -- line: 35
	-- upvalues: isAncestorInteractable (copy), VirtualInputManager (copy)
	local v7 = p2:getRbxInstance()

	if not v7 or not v7:IsA("TextBox") then
		return
	end

	if not v7:IsFocused() then
		if not isAncestorInteractable(v7) then
			return
		end

		v7:CaptureFocus()
		task.wait()
	end

	for i = 1, #p3 do
		VirtualInputManager:SendTextInputCharacterEvent(p3:sub(i, i), nil)
		task.wait()
	end
end
