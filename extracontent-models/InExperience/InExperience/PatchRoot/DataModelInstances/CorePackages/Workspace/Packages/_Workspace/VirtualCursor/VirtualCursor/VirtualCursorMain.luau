local parent = script.Parent
local parent2 = parent.Parent

local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(parent2.SharedFlags)

local FFlagVCWasDisabledFromMenuOpen = SharedFlags.FFlagVCWasDisabledFromMenuOpen

local Input = require(parent:WaitForChild("Input"))
local Interface = require(parent:WaitForChild("Interface"))
local OnRenderStep = require(parent:WaitForChild("OnRenderStep"))

local v = nil
local lastInputTypeChangedConnection = nil
local menuOpenedConnection = nil
local v2 = false
local v3 = false

local function enableVirtualCursor(mouseLocation)
	if not v then
		return
	end

	local cursorPosition = mouseLocation or v.CursorPosition

	v.Enabled = true
	v.CursorPosition = cursorPosition

	Interface:EnableUI(cursorPosition)
	GamepadService:SetGamepadCursorPosition(cursorPosition)
	Input:EnableInput()
	Input:DisablePreview()

	RunService:BindToRenderStep("VirtualCursorStepped", Enum.RenderPriority.Input.Value + 1, v.OnRenderStep)

	menuOpenedConnection = GuiService.MenuOpened:Connect(function()
		if FFlagVCWasDisabledFromMenuOpen then
			v3 = true
		end

		GamepadService.GamepadCursorEnabled = false
	end)
end

local function disableVirtualCursor()
	if not v.Enabled then
		return
	end

	menuOpenedConnection:Disconnect()
	menuOpenedConnection = nil
	v.PreviouslySelectedObject = nil

	Interface:DisableUI()
	Input:DisableInput()
	Input:EnablePreview()

	RunService:UnbindFromRenderStep("VirtualCursorStepped")

	if v.SelectedObject then
		if FFlagVCWasDisabledFromMenuOpen and not v3 then
			GuiService.SelectedCoreObject = nil
		end

		GuiService.SelectedObject = nil

		if not FFlagVCWasDisabledFromMenuOpen then
			GuiService.SelectedCoreObject = nil
		end

		v.SelectedObject = nil
	end

	if FFlagVCWasDisabledFromMenuOpen then
		v3 = false
	end

	v.Enabled = false
end

local class = {}
class.__index = class

function class.GetEnabled(p)
	return p.Enabled
end

function class.new()
	local v4 = {
		Enabled = false,
		CursorPosition = Vector2.new(),
		SelectedObject = nil,
		PreviouslySelectedObject = nil
	}

	function v4.OnRenderStep(p)
		OnRenderStep(v4, p)
	end

	lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
		if
			p == Enum.UserInputType.Gamepad1
			or p == Enum.UserInputType.Focus
			or not GamepadService.GamepadCursorEnabled
		then
			if p == Enum.UserInputType.Gamepad1 and v2 then
				GamepadService.GamepadCursorEnabled = true
				v2 = false
			end
		else
			GamepadService.GamepadCursorEnabled = false
			v2 = true
		end
	end)

	Input:EnablePreview()

	setmetatable(v4, class)

	v = v4

	return v4
end

GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function()
	local gamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if v then
		if gamepadCursorEnabled then
			enableVirtualCursor(UserInputService:GetMouseLocation())
		else
			disableVirtualCursor()
		end
	end
end)

return class.new()
