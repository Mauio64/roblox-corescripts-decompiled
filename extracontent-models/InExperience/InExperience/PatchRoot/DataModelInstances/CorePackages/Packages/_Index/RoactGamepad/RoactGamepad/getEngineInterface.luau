local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local t1 = {
	getGamepadConnected = function(p1) -- line: 13
		-- upvalues: UserInputService (copy)
		return UserInputService:GetGamepadConnected(p1)
	end,
	getGamepadState = function(p2) -- line: 17
		-- upvalues: UserInputService (copy)
		return UserInputService:GetGamepadState(p2)
	end,
	getNavigationGamepads = function() -- line: 21
		-- upvalues: UserInputService (copy)
		return UserInputService:GetNavigationGamepads()
	end,
	getSelection = function() -- line: 25
		-- upvalues: GuiService (copy)
		return GuiService.SelectedCoreObject
	end,
	setSelection = function(p3) -- line: 29
		-- upvalues: GuiService (copy)
		GuiService.SelectedCoreObject = p3
	end,
	subscribeToSelectionChanged = function(p4) -- line: 33
		-- upvalues: GuiService (copy)
		return GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(p4)
	end,
	subscribeToRenderStepped = function(p5) -- line: 37
		-- upvalues: RunService (copy)
		return RunService.RenderStepped:Connect(p5)
	end,
	subscribeToGamepadConnected = function(p6) -- line: 41
		-- upvalues: UserInputService (copy)
		return UserInputService.GamepadConnected:Connect(p6)
	end,
	subscribeToGamepadDisconnected = function(p7) -- line: 45
		-- upvalues: UserInputService (copy)
		return UserInputService.GamepadDisconnected:Connect(p7)
	end,
	subscribeToInputBegan = function(p8) -- line: 49
		-- upvalues: UserInputService (copy)
		return UserInputService.InputBegan:Connect(p8)
	end,
	subscribeToInputEnded = function(p9) -- line: 53
		-- upvalues: UserInputService (copy)
		return UserInputService.InputEnded:Connect(p9)
	end
}
local t2 = {
	getSelection = function() -- line: 63
		-- upvalues: GuiService (copy)
		return GuiService.SelectedObject
	end,
	setSelection = function(p10) -- line: 67
		-- upvalues: GuiService (copy)
		GuiService.SelectedObject = p10
	end,
	subscribeToSelectionChanged = function(p11) -- line: 71
		-- upvalues: GuiService (copy)
		return GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(p11)
	end,
	getGamepadConnected = t1.getGamepadConnected,
	getGamepadState = t1.getGamepadState,
	getNavigationGamepads = t1.getNavigationGamepads,
	subscribeToRenderStepped = t1.subscribeToRenderStepped,
	subscribeToGamepadConnected = t1.subscribeToGamepadConnected,
	subscribeToGamepadDisconnected = t1.subscribeToGamepadDisconnected,
	subscribeToInputBegan = t1.subscribeToInputBegan,
	subscribeToInputEnded = t1.subscribeToInputEnded
}

return function(p12) -- line: 87
	-- upvalues: CoreGui (copy), t1 (copy), t2 (copy)
	if p12:IsDescendantOf(CoreGui) then
		return t1
	end

	if p12:FindFirstAncestorWhichIsA("PlayerGui") == nil then
		error("Gamepad navigation not supported. Must be a child of CoreGui or a PlayerGui")
	end

	return t2
end
