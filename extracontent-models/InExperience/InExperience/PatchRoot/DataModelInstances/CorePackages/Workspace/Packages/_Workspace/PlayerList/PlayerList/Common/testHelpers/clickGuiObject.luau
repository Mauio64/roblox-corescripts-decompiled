local VirtualInputManager = game:GetService("VirtualInputManager")

local function clickGuiObject(instance)
	local screenGui = instance:FindFirstAncestorOfClass("ScreenGui")
	local parent = screenGui or Instance.new("ScreenGui")
	local v = screenGui == nil
	local v2

	if v then
		parent.Parent = game:GetService("CoreGui")
		v2 = instance

		while v2.Parent ~= nil and v2.Parent.Parent ~= game do
			v2 = v2.Parent
		end

		v2.Parent = parent
	end

	VirtualInputManager:WaitForInputEventsProcessed()
	local absolutePosition = instance.AbsolutePosition
	local absoluteSize = instance.AbsoluteSize
	local v3 = absolutePosition.X + absoluteSize.X / 2
	local v4 = absolutePosition.Y + absoluteSize.Y / 2

	local v5 = false
	local activatedConnection = instance.Activated:Connect(function()
		v5 = true
	end)

	VirtualInputManager:SendMouseButtonEvent(v3, v4, 0, true, nil, 1)
	VirtualInputManager:SendMouseButtonEvent(v3, v4, 0, false, nil, 1)
	VirtualInputManager:WaitForInputEventsProcessed()

	if not v5 then
		VirtualInputManager:SendTouchEvent(1, 0, v3, v4)
		VirtualInputManager:SendTouchEvent(1, 2, v3, v4)
		VirtualInputManager:WaitForInputEventsProcessed()
	end

	activatedConnection:Disconnect()

	if v then
		if v2 then
			v2.Parent = nil
		end

		parent:Destroy()
	end
end

return clickGuiObject
