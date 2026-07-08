local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local FFlagVCWasDisabledFromMenuOpen = require(scriptParentParent.SharedFlags).FFlagVCWasDisabledFromMenuOpen
local Input = require(scriptParent:WaitForChild("Input"))
local Interface = require(scriptParent:WaitForChild("Interface"))
local OnRenderStep = require(scriptParent:WaitForChild("OnRenderStep"))
local u11 = nil
local connection = nil
local connection2 = nil
local u14 = false
local u15 = false

local function enableVirtualCursor(p1) -- line: 39
	-- upvalues: u11 (ref), Interface (copy), GamepadService (copy), Input (copy), RunService (copy), connection2 (ref), GuiService (copy), FFlagVCWasDisabledFromMenuOpen (copy), u15 (ref)
	if not u11 then
		return
	end

	local v20 = p1 or u11.CursorPosition

	u11.Enabled = true
	u11.CursorPosition = v20
	Interface:EnableUI(v20)
	GamepadService:SetGamepadCursorPosition(v20)
	Input:EnableInput()
	Input:DisablePreview()
	RunService:BindToRenderStep("VirtualCursorStepped", Enum.RenderPriority.Input.Value + 1, u11.OnRenderStep)
	connection2 = GuiService.MenuOpened:Connect(function() -- line: 59
		-- upvalues: FFlagVCWasDisabledFromMenuOpen (copy), u15 (ref), GamepadService (copy)
		if FFlagVCWasDisabledFromMenuOpen then
			u15 = true
		end

		GamepadService.GamepadCursorEnabled = false
	end)
end
local function disableVirtualCursor() -- line: 67
	-- upvalues: u11 (ref), connection2 (ref), Interface (copy), Input (copy), RunService (copy), FFlagVCWasDisabledFromMenuOpen (copy), u15 (ref), GuiService (copy)
	if not u11.Enabled then
		return
	end

	connection2:Disconnect()
	connection2 = nil
	u11.PreviouslySelectedObject = nil
	Interface:DisableUI()
	Input:DisableInput()
	Input:EnablePreview()
	RunService:UnbindFromRenderStep("VirtualCursorStepped")

	if u11.SelectedObject then
		if FFlagVCWasDisabledFromMenuOpen and not u15 then
			GuiService.SelectedCoreObject = nil
		end

		GuiService.SelectedObject = nil

		if not FFlagVCWasDisabledFromMenuOpen then
			GuiService.SelectedCoreObject = nil
		end

		u11.SelectedObject = nil
	end

	if FFlagVCWasDisabledFromMenuOpen then
		u15 = false
	end

	u11.Enabled = false
end

local t1 = {}

t1.__index = t1

function t1.GetEnabled(p2) -- line: 104
	return p2.Enabled
end
function t1.new() -- line: 108
	-- upvalues: OnRenderStep (copy), connection (ref), UserInputService (copy), GamepadService (copy), u14 (ref), Input (copy), t1 (copy), u11 (ref)
	local t2 = {
		Enabled = false,
		SelectedObject = nil,
		PreviouslySelectedObject = nil,
		CursorPosition = Vector2.new()
	}

	function t2.OnRenderStep(p3) -- line: 116
		-- upvalues: OnRenderStep (copy), t2 (copy)
		OnRenderStep(t2, p3)
	end

	connection = UserInputService.LastInputTypeChanged:Connect(function(p4) -- line: 120
		-- upvalues: GamepadService (copy), u14 (ref)
		if p4 ~= Enum.UserInputType.Gamepad1 and (p4 ~= Enum.UserInputType.Focus and GamepadService.GamepadCursorEnabled) then
			GamepadService.GamepadCursorEnabled = false
			u14 = true

			return
		end

		if p4 == Enum.UserInputType.Gamepad1 and u14 then
			GamepadService.GamepadCursorEnabled = true
			u14 = false
		end
	end)
	Input:EnablePreview()
	setmetatable(t2, t1)
	u11 = t2

	return t2
end

GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function() -- line: 143
	-- upvalues: GamepadService (copy), u11 (ref), UserInputService (copy), enableVirtualCursor (copy), disableVirtualCursor (copy)
	local GamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if u11 then
		if GamepadCursorEnabled then
			local MouseLocation = UserInputService:GetMouseLocation()

			enableVirtualCursor(MouseLocation)

			return
		end

		disableVirtualCursor()
	end
end)

return t1.new()
