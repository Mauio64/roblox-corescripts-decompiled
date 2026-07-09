local VirtualCursorModular = script:FindFirstAncestor("VirtualCursorModular")
local VirtualCursorModularParent = VirtualCursorModular.Parent

game:GetService("CoreGui")

local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local SharedFlags = require(VirtualCursorModularParent.SharedFlags)
local FFlagEnableSnapInVirtualCursor = SharedFlags.FFlagEnableSnapInVirtualCursor
local FFlagVCWasDisabledFromMenuOpen = SharedFlags.FFlagVCWasDisabledFromMenuOpen
local FFlagEnableVirtualCursorDebugging = SharedFlags.FFlagEnableVirtualCursorDebugging
local InputController = require(VirtualCursorModular.Controllers.InputController)
local CursorController = require(VirtualCursorModular.Controllers.CursorController)
local SelectionController = require(VirtualCursorModular.Controllers.SelectionController)
local SnapController = require(VirtualCursorModular.Controllers.SnapController)
local Enums = require(VirtualCursorModular.Enums)
local Properties = require(VirtualCursorModular.Properties)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 59
	-- upvalues: CursorController (copy), InputController (copy), FFlagEnableSnapInVirtualCursor (copy), SnapController (copy), SelectionController (copy), Enums (copy), Properties (copy), t1 (copy)
	local v18 = CursorController.new()
	local v19 = InputController.new(v18)
	local v20 = if not FFlagEnableSnapInVirtualCursor then nil else SnapController.new()
	local v21 = SelectionController.new(v19, v18, v20)

	if FFlagEnableSnapInVirtualCursor and v20 then
		v20:setMethodStrength(Enums.SnapAssistMethod.Friction, Properties.SnapFrictionStrength)
		v20:setMethodStrength(Enums.SnapAssistMethod.Tracking, Properties.SnapTrackingStrength)
		v20:setMethodStrength(Enums.SnapAssistMethod.Centering, Properties.SnapCenteringStrength)
	end

	local v22 = setmetatable({
		_selectedObject = nil,
		_previouslySelectedObject = nil,
		_wasDisabledFromOtherInput = false,
		_lastInputTypeChangedEventConnection = nil,
		_gamepadCursorEnabledConnection = nil,
		_menuOpenedEventConnection = nil,
		_boundToRenderStep = false,
		_wasDisabledFromMenuOpen = false,
		_cursorPosition = Vector2.new(),
		_cursorController = v18,
		_inputController = v19,
		_selectionController = v21,
		_snapController = v20
	}, t1)

	v22:initialize()

	return v22
end
function t1.Destroy(p1) -- line: 92
	-- upvalues: RunService (copy)
	local _lastInputTypeChangedEventConnection = p1._lastInputTypeChangedEventConnection

	if _lastInputTypeChangedEventConnection then
		_lastInputTypeChangedEventConnection:Disconnect()
		p1._lastInputTypeChangedEventConnection = nil
	end

	local _gamepadCursorEnabledConnection = p1._gamepadCursorEnabledConnection

	if _gamepadCursorEnabledConnection then
		_gamepadCursorEnabledConnection:Disconnect()
		p1._gamepadCursorEnabledConnection = nil
	end

	local _menuOpenedEventConnection = p1._menuOpenedEventConnection

	if _menuOpenedEventConnection then
		_menuOpenedEventConnection:Disconnect()
		p1._menuOpenedEventConnection = nil
	end

	if p1._boundToRenderStep then
		RunService:UnbindFromRenderStep("VirtualCursorStepped")
		p1._boundToRenderStep = false
	end

	if p1._inputController then
		p1._inputController:Destroy()
	end

	if p1._cursorController then
		p1._cursorController:Destroy()
	end
end
function t1.UpdateGamepadCursor(p2) -- line: 125
	-- upvalues: GamepadService (copy), UserInputService (copy)
	if GamepadService.GamepadCursorEnabled then
		p2:EnableVirtualCursor((UserInputService:GetMouseLocation()))

		return
	end

	p2:EnableSelectionPreview()
end
function t1.initialize(p3) -- line: 135
	-- upvalues: UserInputService (copy), GamepadService (copy), FFlagEnableVirtualCursorDebugging (copy)
	p3._lastInputTypeChangedEventConnection = UserInputService.LastInputTypeChanged:Connect(function(p4) -- line: 137
		-- upvalues: GamepadService (copy), p3 (copy), FFlagEnableVirtualCursorDebugging (copy)
		if p4 ~= Enum.UserInputType.Gamepad1 and (p4 ~= Enum.UserInputType.Focus and GamepadService.GamepadCursorEnabled) then
			GamepadService.GamepadCursorEnabled = false
			p3._wasDisabledFromOtherInput = true
		elseif p4 == Enum.UserInputType.Gamepad1 and p3._wasDisabledFromOtherInput then
			GamepadService.GamepadCursorEnabled = true
			p3._wasDisabledFromOtherInput = false
		end

		if FFlagEnableVirtualCursorDebugging then
			print("LastInputTypeChanged", p4, GamepadService.GamepadCursorEnabled, p3._wasDisabledFromOtherInput)
		end
	end)
	p3._gamepadCursorEnabledConnection = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function() -- line: 161
		-- upvalues: p3 (copy)
		p3:UpdateGamepadCursor()
	end)
	p3:UpdateGamepadCursor()
end
function t1.onRenderStep(t2: {[any]: any}, n1: number) -- line: 168
	t2._selectionController:onRenderStep(n1)
end
function t1.EnableVirtualCursor(t3: {[any]: any}, vector2: Vector2) -- line: 172
	-- upvalues: GamepadService (copy), Enums (copy), RunService (copy), GuiService (copy), FFlagVCWasDisabledFromMenuOpen (copy)
	t3._cursorController:Enable(vector2)
	GamepadService:SetGamepadCursorPosition(vector2)
	t3._inputController:SetBehavior(Enums.Behavior.VirtualCursor)

	if not t3._boundToRenderStep then
		RunService:BindToRenderStep("VirtualCursorStepped", Enum.RenderPriority.Input.Value + 1, function(n2: number) -- line: 178
			-- upvalues: t3 (copy)
			t3:onRenderStep(n2)
		end)
		t3._boundToRenderStep = true
	end

	t3._menuOpenedEventConnection = GuiService.MenuOpened:Connect(function() -- line: 184
		-- upvalues: GamepadService (copy), FFlagVCWasDisabledFromMenuOpen (copy), t3 (copy)
		GamepadService.GamepadCursorEnabled = false

		if FFlagVCWasDisabledFromMenuOpen then
			t3._wasDisabledFromMenuOpen = true
		end
	end)
end
function t1.EnableSelectionPreview(p5) -- line: 192
	-- upvalues: Enums (copy), RunService (copy), GuiService (copy), FFlagVCWasDisabledFromMenuOpen (copy)
	local _menuOpenedEventConnection = p5._menuOpenedEventConnection

	if _menuOpenedEventConnection then
		_menuOpenedEventConnection:Disconnect()
		p5._menuOpenedEventConnection = nil
	end

	p5._cursorController:Disable()
	p5._inputController:SetBehavior(Enums.Behavior.SelectionPreview)

	if p5._boundToRenderStep then
		RunService:UnbindFromRenderStep("VirtualCursorStepped")
		p5._boundToRenderStep = false
	end

	GuiService.SelectedObject = nil

	if not FFlagVCWasDisabledFromMenuOpen or not p5._wasDisabledFromMenuOpen then
		GuiService.SelectedCoreObject = nil
	end

	if FFlagVCWasDisabledFromMenuOpen then
		p5._wasDisabledFromMenuOpen = false
	end
end

return t1.new()
