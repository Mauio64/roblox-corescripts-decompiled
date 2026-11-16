local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local v = {
	getGamepadConnected = function(p)
		return UserInputService:GetGamepadConnected(p)
	end,
	getGamepadState = function(p)
		return UserInputService:GetGamepadState(p)
	end,
	getNavigationGamepads = function()
		return UserInputService:GetNavigationGamepads()
	end,
	getSelection = function()
		return GuiService.SelectedCoreObject
	end,
	setSelection = function(selectedCoreObject)
		GuiService.SelectedCoreObject = selectedCoreObject
	end,
	subscribeToSelectionChanged = function(p)
		return GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(p)
	end,
	subscribeToRenderStepped = function(onRenderStepped)
		return RunService.RenderStepped:Connect(onRenderStepped)
	end,
	subscribeToGamepadConnected = function(onGamepadConnected)
		return UserInputService.GamepadConnected:Connect(onGamepadConnected)
	end,
	subscribeToGamepadDisconnected = function(onGamepadDisconnected)
		return UserInputService.GamepadDisconnected:Connect(onGamepadDisconnected)
	end,
	subscribeToInputBegan = function(onInputBegan)
		return UserInputService.InputBegan:Connect(onInputBegan)
	end,
	subscribeToInputEnded = function(onInputEnded)
		return UserInputService.InputEnded:Connect(onInputEnded)
	end
}

local v2 = {
	getSelection = function()
		return GuiService.SelectedObject
	end,
	setSelection = function(selectedObject)
		GuiService.SelectedObject = selectedObject
	end,
	subscribeToSelectionChanged = function(p)
		return GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(p)
	end,
	["getGamepadConnected"] = v.getGamepadConnected,
	getGamepadState = v.getGamepadState,
	getNavigationGamepads = v.getNavigationGamepads,
	subscribeToRenderStepped = v.subscribeToRenderStepped,
	subscribeToGamepadConnected = v.subscribeToGamepadConnected,
	subscribeToGamepadDisconnected = v.subscribeToGamepadDisconnected,
	subscribeToInputBegan = v.subscribeToInputBegan,
	subscribeToInputEnded = v.subscribeToInputEnded
}

return function(instance)
	if instance:IsDescendantOf(CoreGui) then
		return v
	end

	if instance:FindFirstAncestorWhichIsA("PlayerGui") == nil then
		error("Gamepad navigation not supported. Must be a child of CoreGui or a PlayerGui")
	end

	return v2
end
