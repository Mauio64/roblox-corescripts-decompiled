local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")

local fFlagVCWasDisabledFromMenuOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/SharedFlags").FFlagVCWasDisabledFromMenuOpen

local Input = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Input")
local Interface = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Interface")
local OnRenderStep = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/OnRenderStep")

local v5 = nil
local lastInputTypeChangedConnection = nil
local menuOpenedConnection = nil
local v6 = false
local v7 = false

local function enableVirtualCursor(mouseLocation)
	if not v5 then
		return
	end

	local v8 = mouseLocation or v5.CursorPosition

	v5.Enabled = true
	v5.CursorPosition = v8

	Interface:EnableUI(v8)
	GamepadService:SetGamepadCursorPosition(v8)
	Input:EnableInput()
	Input:DisablePreview()

	RunService:BindToRenderStep(
		"VirtualCursorStepped",
		Enum.RenderPriority.Input.Value + 1,
		v5.OnRenderStep
	)

	menuOpenedConnection = GuiService.MenuOpened:Connect(function()
		if fFlagVCWasDisabledFromMenuOpen then
			v7 = true
		end

		GamepadService.GamepadCursorEnabled = false
	end)
end

local function disableVirtualCursor()
	if not v5.Enabled then
		return
	end

	menuOpenedConnection:Disconnect()
	menuOpenedConnection = nil
	v5.PreviouslySelectedObject = nil

	Interface:DisableUI()
	Input:DisableInput()
	Input:EnablePreview()

	RunService:UnbindFromRenderStep("VirtualCursorStepped")

	if v5.SelectedObject then
		if fFlagVCWasDisabledFromMenuOpen and not v7 then
			GuiService.SelectedCoreObject = nil
		end

		GuiService.SelectedObject = nil

		if not fFlagVCWasDisabledFromMenuOpen then
			GuiService.SelectedCoreObject = nil
		end

		v5.SelectedObject = nil
	end

	if fFlagVCWasDisabledFromMenuOpen then
		v7 = false
	end

	v5.Enabled = false
end

local class = {}
class.__index = class

function class:GetEnabled()
	return self.Enabled
end

function class.new()
	local v8 = {
		Enabled = false,
		CursorPosition = Vector2.new(),
		SelectedObject = nil,
		PreviouslySelectedObject = nil
	}

	function v8.OnRenderStep(p2)
		OnRenderStep(v8, p2)
	end

	lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p2)
		if
			p2 == Enum.UserInputType.Gamepad1
			or p2 == Enum.UserInputType.Focus
			or not GamepadService.GamepadCursorEnabled
		then
			if p2 == Enum.UserInputType.Gamepad1 and v6 then
				GamepadService.GamepadCursorEnabled = true
				v6 = false
			end
		else
			GamepadService.GamepadCursorEnabled = false
			v6 = true
		end
	end)

	Input:EnablePreview()

	setmetatable(v8, class)

	v5 = v8

	return v8
end

GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function()
	local gamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if v5 then
		if gamepadCursorEnabled then
			enableVirtualCursor(UserInputService:GetMouseLocation())
		else
			disableVirtualCursor()
		end
	end
end)

return class.new()
