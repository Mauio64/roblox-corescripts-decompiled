local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags")
local fFlagEnableVirtualCursorMoveAssist = SharedFlags.FFlagEnableVirtualCursorMoveAssist
local fFlagVCWasDisabledFromMenuOpen = SharedFlags.FFlagVCWasDisabledFromMenuOpen
local fFlagEnableVirtualCursorDebugging = SharedFlags.FFlagEnableVirtualCursorDebugging

local InputController = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Controllers/InputController")
local CursorController = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Controllers/CursorController")
local SelectionController = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Controllers/SelectionController")
local MoveAssistController = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Controllers/MoveAssistController")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Enums")

local class = {}
class.__index = class

function class.new()
	local v5 = CursorController.new()
	local v6 = InputController.new(v5)
	local v7 = if fFlagEnableVirtualCursorMoveAssist then MoveAssistController.new() else nil
	local v8 = SelectionController.new(v6, v5, v7)

	local v9 = if fFlagEnableVirtualCursorDebugging and v7 then require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Controllers/MoveAssistDebugView").new() else nil

	local object = setmetatable({
		_cursorPosition = Vector2.new(),
		_selectedObject = nil,
		_previouslySelectedObject = nil,
		_wasDisabledFromOtherInput = false,
		_lastInputTypeChangedEventConnection = nil,
		_gamepadCursorEnabledConnection = nil,
		_menuOpenedEventConnection = nil,
		_cursorController = v5,
		_inputController = v6,
		_selectionController = v8,
		_moveAssistController = v7,
		_moveAssistDebugView = v9,
		_boundToRenderStep = false,
		_wasDisabledFromMenuOpen = false
	}, class)

	object:initialize()

	return object
end

function class:Destroy()
	local lastInputTypeChangedEventConnection = self._lastInputTypeChangedEventConnection

	if lastInputTypeChangedEventConnection then
		lastInputTypeChangedEventConnection:Disconnect()
		self._lastInputTypeChangedEventConnection = nil
	end

	local gamepadCursorEnabledConnection = self._gamepadCursorEnabledConnection

	if gamepadCursorEnabledConnection then
		gamepadCursorEnabledConnection:Disconnect()
		self._gamepadCursorEnabledConnection = nil
	end

	local menuOpenedEventConnection = self._menuOpenedEventConnection

	if menuOpenedEventConnection then
		menuOpenedEventConnection:Disconnect()
		self._menuOpenedEventConnection = nil
	end

	if self._boundToRenderStep then
		RunService:UnbindFromRenderStep("VirtualCursorStepped")
		self._boundToRenderStep = false
	end

	if self._inputController then
		self._inputController:Destroy()
	end

	if self._cursorController then
		self._cursorController:Destroy()
	end

	if self._moveAssistDebugView then
		self._moveAssistDebugView:Destroy()
		self._moveAssistDebugView = nil
	end
end

function class:UpdateGamepadCursor()
	if GamepadService.GamepadCursorEnabled then
		self:EnableVirtualCursor((UserInputService:GetMouseLocation()))
	else
		self:EnableSelectionPreview()
	end
end

function class:initialize()
	self._lastInputTypeChangedEventConnection = UserInputService.LastInputTypeChanged:Connect(function(p2)
		if
			p2 == Enum.UserInputType.Gamepad1
			or p2 == Enum.UserInputType.Focus
			or not GamepadService.GamepadCursorEnabled
		then
			if p2 == Enum.UserInputType.Gamepad1 and self._wasDisabledFromOtherInput then
				GamepadService.GamepadCursorEnabled = true
				self._wasDisabledFromOtherInput = false
			end
		else
			GamepadService.GamepadCursorEnabled = false
			self._wasDisabledFromOtherInput = true
		end

		if fFlagEnableVirtualCursorDebugging then
			print(
				"LastInputTypeChanged",
				p2,
				"GamepadCursorEnabled",
				GamepadService.GamepadCursorEnabled,
				"_wasDisabledFromOtherInput",
				self._wasDisabledFromOtherInput
			)
		end
	end)

	self._gamepadCursorEnabledConnection = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function()
		self:UpdateGamepadCursor()
	end)

	self:UpdateGamepadCursor()
end

function class:onRenderStep(p2)
	self._selectionController:onRenderStep(p2)

	local moveAssistDebugView = self._moveAssistDebugView
	local moveAssistController = self._moveAssistController

	if moveAssistDebugView and moveAssistController then
		moveAssistDebugView:update(
			moveAssistController._debugSnapshot,
			self._cursorController:GetCursorScreenGuiOffset()
		)
	end
end

function class:EnableVirtualCursor(p2)
	self._cursorController:Enable(p2)
	GamepadService:SetGamepadCursorPosition(p2)
	self._inputController:SetBehavior(Enums.Behavior.VirtualCursor)

	if not self._boundToRenderStep then
		RunService:BindToRenderStep(
			"VirtualCursorStepped",
			Enum.RenderPriority.Input.Value + 1,
			function(p3)
				self:onRenderStep(p3)
			end
		)
		self._boundToRenderStep = true
	end

	self._menuOpenedEventConnection = GuiService.MenuOpened:Connect(function()
		GamepadService.GamepadCursorEnabled = false

		if fFlagVCWasDisabledFromMenuOpen then
			self._wasDisabledFromMenuOpen = true
		end
	end)
end

function class:EnableSelectionPreview()
	local menuOpenedEventConnection = self._menuOpenedEventConnection

	if menuOpenedEventConnection then
		menuOpenedEventConnection:Disconnect()
		self._menuOpenedEventConnection = nil
	end

	self._cursorController:Disable()
	self._inputController:SetBehavior(Enums.Behavior.SelectionPreview)

	if self._boundToRenderStep then
		RunService:UnbindFromRenderStep("VirtualCursorStepped")
		self._boundToRenderStep = false
	end

	GuiService.SelectedObject = nil

	if not (fFlagVCWasDisabledFromMenuOpen and self._wasDisabledFromMenuOpen) then
		GuiService.SelectedCoreObject = nil
	end

	if fFlagVCWasDisabledFromMenuOpen then
		self._wasDisabledFromMenuOpen = false
	end
end

return class.new()
