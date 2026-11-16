local VirtualCursorModular = script:FindFirstAncestor("VirtualCursorModular")
local parent = VirtualCursorModular.Parent

game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableVirtualCursorMoveAssist = SharedFlags.FFlagEnableVirtualCursorMoveAssist
local FFlagVCWasDisabledFromMenuOpen = SharedFlags.FFlagVCWasDisabledFromMenuOpen
local FFlagEnableVirtualCursorDebugging = SharedFlags.FFlagEnableVirtualCursorDebugging

local InputController = require(VirtualCursorModular.Controllers.InputController)
local CursorController = require(VirtualCursorModular.Controllers.CursorController)
local SelectionController = require(VirtualCursorModular.Controllers.SelectionController)
local MoveAssistController = require(VirtualCursorModular.Controllers.MoveAssistController)

local Enums = require(VirtualCursorModular.Enums)

local class = {}
class.__index = class

function class.new()
	local cursorController = CursorController.new()
	local inputController = InputController.new(cursorController)
	local moveAssistController

	if FFlagEnableVirtualCursorMoveAssist then
		moveAssistController = MoveAssistController.new()
	end

	local selectionController = SelectionController.new(inputController, cursorController, moveAssistController)
	local moveAssistDebugView

	if FFlagEnableVirtualCursorDebugging and moveAssistController then
		local MoveAssistDebugView = require(VirtualCursorModular.Controllers.MoveAssistDebugView)
		moveAssistDebugView = MoveAssistDebugView.new()
	end

	local self = setmetatable({
		_cursorPosition = Vector2.new(),
		_selectedObject = nil,
		_previouslySelectedObject = nil,
		_wasDisabledFromOtherInput = false,
		_lastInputTypeChangedEventConnection = nil,
		_gamepadCursorEnabledConnection = nil,
		_menuOpenedEventConnection = nil,
		_cursorController = cursorController,
		_inputController = inputController,
		_selectionController = selectionController,
		_moveAssistController = moveAssistController,
		_moveAssistDebugView = moveAssistDebugView,
		_boundToRenderStep = false,
		_wasDisabledFromMenuOpen = false
	}, class)

	self:initialize()

	return self
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
	self._lastInputTypeChangedEventConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
		if
			p == Enum.UserInputType.Gamepad1
			or p == Enum.UserInputType.Focus
			or not GamepadService.GamepadCursorEnabled
		then
			if p == Enum.UserInputType.Gamepad1 and self._wasDisabledFromOtherInput then
				GamepadService.GamepadCursorEnabled = true
				self._wasDisabledFromOtherInput = false
			end
		else
			GamepadService.GamepadCursorEnabled = false
			self._wasDisabledFromOtherInput = true
		end

		if FFlagEnableVirtualCursorDebugging then
			print(
				"LastInputTypeChanged",
				p,
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

function class:onRenderStep(p: number)
	self._selectionController:onRenderStep(p)

	local moveAssistDebugView = self._moveAssistDebugView
	local moveAssistController = self._moveAssistController

	if moveAssistDebugView and moveAssistController then
		moveAssistDebugView:update(
			moveAssistController._debugSnapshot,
			self._cursorController:GetCursorScreenGuiOffset()
		)
	end
end

function class:EnableVirtualCursor(vector2: Vector2)
	self._cursorController:Enable(vector2)
	GamepadService:SetGamepadCursorPosition(vector2)
	self._inputController:SetBehavior(Enums.Behavior.VirtualCursor)

	if not self._boundToRenderStep then
		RunService:BindToRenderStep("VirtualCursorStepped", Enum.RenderPriority.Input.Value + 1, function(p: number)
			self:onRenderStep(p)
		end)
		self._boundToRenderStep = true
	end

	self._menuOpenedEventConnection = GuiService.MenuOpened:Connect(function()
		GamepadService.GamepadCursorEnabled = false

		if FFlagVCWasDisabledFromMenuOpen then
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

	if not (FFlagVCWasDisabledFromMenuOpen and self._wasDisabledFromMenuOpen) then
		GuiService.SelectedCoreObject = nil
	end

	if FFlagVCWasDisabledFromMenuOpen then
		self._wasDisabledFromMenuOpen = false
	end
end

return class.new()
