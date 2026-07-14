local VirtualInputManager = game:GetService("VirtualInputManager")

local function clickGuiObject(p1) -- line: 7
	-- upvalues: VirtualInputManager (copy)
	local ScreenGui = p1:FindFirstAncestorOfClass("ScreenGui")
	local v5 = ScreenGui or Instance.new("ScreenGui")
	local v6 = ScreenGui == nil
	local v7 = nil

	if v6 then
		v5.Parent = game:GetService("CoreGui")
		v7 = p1

		while v7.Parent ~= nil and v7.Parent.Parent ~= game do
			v7 = v7.Parent
		end

		v7.Parent = v5
	end

	VirtualInputManager:WaitForInputEventsProcessed()

	local AbsolutePosition = p1.AbsolutePosition
	local AbsoluteSize = p1.AbsoluteSize
	local v10 = AbsolutePosition.X + AbsoluteSize.X / 2
	local v11 = AbsolutePosition.Y + AbsoluteSize.Y / 2
	local u12 = false
	local connection = p1.Activated:Connect(function() -- line: 30
		-- upvalues: u12 (ref)
		u12 = true
	end)

	VirtualInputManager:SendMouseButtonEvent(v10, v11, 0, true, nil, 1)
	VirtualInputManager:SendMouseButtonEvent(v10, v11, 0, false, nil, 1)
	VirtualInputManager:WaitForInputEventsProcessed()

	if not u12 then
		VirtualInputManager:SendTouchEvent(1, 0, v10, v11)
		VirtualInputManager:SendTouchEvent(1, 2, v10, v11)
		VirtualInputManager:WaitForInputEventsProcessed()
	end

	connection:Disconnect()

	if v6 then
		if v7 then
			v7.Parent = nil
		end

		v5:Destroy()
	end
end

return clickGuiObject
