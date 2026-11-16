local parent = script.Parent.Parent

local ContextActionService = game:GetService("ContextActionService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Util = require(parent.Util)
local ProcessThumbstickInput = Util.ProcessThumbstickInput
local GetRectCenter = Util.GetRectCenter
local GetThumbstickInputFromDirectionalInput = Util.GetThumbstickInputFromDirectionalInput

local Enums = require(parent.Enums)

local InputController = {}
InputController.__index = InputController

function InputController.new(cursorController)
	return (setmetatable({
		_cursorController = cursorController,
		_moveVector = Vector2.new(),
		_scrollVector = Vector2.new(),
		_enabled = false,
		_behavior = Enums.Behavior.SelectionPreview,
		_previousSelection = nil,
		_selectedObjectChangedConnection = nil,
		_gamepadSelectionRect2DChangedConnection = nil,
		_selectedRectChangedConnection = nil,
		_inputBeganConnection = nil,
		_inputEndedConnection = nil,
		_activeDirections = {}
	}, InputController))
end

function InputController:Destroy()
	if self._selectedObjectChangedConnection then
		self._selectedObjectChangedConnection:Disconnect()
	end

	if self._gamepadSelectionRect2DChangedConnection then
		self._gamepadSelectionRect2DChangedConnection:Disconnect()
	end

	if self._selectedRectChangedConnection then
		self._selectedRectChangedConnection:Disconnect()
	end

	if self._inputBeganConnection then
		self._inputBeganConnection:Disconnect()
	end

	if self._inputEndedConnection then
		self._inputEndedConnection:Disconnect()
	end
end

function InputController:OnMove(_, p)
	if not (self._behavior == Enums.Behavior.SelectionPreview and GuiService.SelectedObject ~= nil) then
		return Enum.ContextActionResult.Pass
	end

	if p then
		self._moveVector = ProcessThumbstickInput(Vector2.new(p.Position.X, p.Position.Y))
	end

	local v = GuiService.SelectedCoreObject == nil or GuiService.SelectedObject ~= nil
	local v2 = self._moveVector ~= Vector2.zero

	local v3 = v and v2

	if v3 and not self._cursorController:GetEnabled() then
		if self._previousSelection then
			self._cursorController:Enable(GetRectCenter(self._previousSelection.SelectionRect2D))
		elseif GuiService.SelectedObject then
			self._cursorController:Enable(GetRectCenter(GuiService.SelectedObject.SelectionRect2D))
		end
	elseif not v3 and self._cursorController:GetEnabled() then
		self._cursorController:Disable()
	end

	local selectedRectChangedConnection = self._selectedRectChangedConnection

	if selectedRectChangedConnection then
		selectedRectChangedConnection:Disconnect()
		self._selectedRectChangedConnection = nil
	end

	if v3 and GuiService.SelectedObject then
		local selectedObject = GuiService.SelectedObject
		self._selectedRectChangedConnection = selectedObject:GetPropertyChangedSignal("SelectionRect2D"):Connect(function()
			if selectedObject and self._behavior == Enums.Behavior.SelectionPreview then
				self._cursorController:TweenPosition(GetRectCenter(selectedObject.SelectionRect2D))
			end
		end)

		self._cursorController:TweenPosition(GetRectCenter(GuiService.SelectedObject.SelectionRect2D))
	end

	return Enum.ContextActionResult.Pass
end

function InputController:OnScroll(p, p2)
	if self._behavior ~= Enums.Behavior.VirtualCursor then
		return Enum.ContextActionResult.Pass
	end

	if p == Enum.UserInputState.Change and p2 then
		self._scrollVector = Vector2.new(p2.Position.X, p2.Position.Y) * Vector2.new(1, -1)
		return Enum.ContextActionResult.Sink
	end

	self._scrollVector = Vector2.zero

	return Enum.ContextActionResult.Pass
end

function InputController:OnActivate(p, _)
	if p == Enum.UserInputState.Begin then
		if GuiService.SelectedObject or GuiService.SelectedCoreObject then
			self._cursorController:PlayTweenActivate()
		end
	elseif p == Enum.UserInputState.End and (GuiService.SelectedObject or GuiService.SelectedCoreObject) then
		self._cursorController:PlayTweenDefault()
	end

	return Enum.ContextActionResult.Pass
end

function InputController:OnDirectionalButtons(p, p2)
	if self._behavior ~= Enums.Behavior.VirtualCursor or not p2 then
		return Enum.ContextActionResult.Pass
	end

	local keyCode = p2.KeyCode

	if
		keyCode ~= Enum.KeyCode.ButtonUp
		and keyCode ~= Enum.KeyCode.ButtonDown
		and keyCode ~= Enum.KeyCode.ButtonLeft
		and keyCode ~= Enum.KeyCode.ButtonRight
	then
		return Enum.ContextActionResult.Pass
	end

	local v = Enum.ContextActionResult.Pass

	if p == Enum.UserInputState.Begin or p == Enum.UserInputState.Change then
		self._activeDirections[p2.KeyCode] = p2.Position.Z
		v = Enum.ContextActionResult.Sink
	else
		self._activeDirections[p2.KeyCode] = nil
	end

	local v2 = Vector2.zero

	for k, activeDirection in self._activeDirections do
		v2 += GetThumbstickInputFromDirectionalInput(k, activeDirection)
	end

	if v2.Magnitude > 1 then
		v2 = v2.Unit
	end

	self._moveVector = ProcessThumbstickInput(v2)

	return v
end

function InputController:GetMoveVector()
	return self._moveVector
end

function InputController:GetScrollVector()
	return self._scrollVector
end

function InputController:SetBehavior(behavior)
	local _behavior = self._behavior
	self._behavior = behavior

	if _behavior == Enums.Behavior.VirtualCursor then
		self._moveVector = Vector2.new()
		self._scrollVector = Vector2.new()
		table.clear(self._activeDirections)

		ContextActionService:UnbindCoreAction(Enums.Action.DirectionalMove)
		ContextActionService:UnbindCoreAction(Enums.Action.Scroll)

		local gamepadThumbstick1ChangedConnection = self._gamepadThumbstick1ChangedConnection

		if gamepadThumbstick1ChangedConnection then
			gamepadThumbstick1ChangedConnection:Disconnect()
			self._gamepadThumbstick1ChangedConnection = nil
		end

		local inputBeganConnection = self._inputBeganConnection

		if inputBeganConnection then
			inputBeganConnection:Disconnect()
			self._inputBeganConnection = nil
		end

		local inputEndedConnection = self._inputEndedConnection

		if inputEndedConnection then
			inputEndedConnection:Disconnect()
			self._inputEndedConnection = nil
		end

		self:OnScroll(Enum.UserInputState.Cancel, nil)
	elseif _behavior == Enums.Behavior.SelectionPreview then
		ContextActionService:UnbindCoreAction(Enums.Action.Move)

		local selectedObjectChangedConnection = self._selectedObjectChangedConnection

		if selectedObjectChangedConnection then
			selectedObjectChangedConnection:Disconnect()
			self._selectedObjectChangedConnection = nil
		end

		local selectedRectChangedConnection = self._selectedRectChangedConnection

		if selectedRectChangedConnection then
			selectedRectChangedConnection:Disconnect()
			self._selectedRectChangedConnection = nil
		end
	end

	if self._behavior == Enums.Behavior.VirtualCursor then
		ContextActionService:BindCoreActionAtPriority(Enums.Action.Scroll, function(_: string, p, p2)
			return self:OnScroll(p, p2)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick2)

		ContextActionService:BindCoreActionAtPriority(Enums.Action.DirectionalMove, function(_: string, p, p2)
			return self:OnDirectionalButtons(p, p2)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonUp, Enum.KeyCode.ButtonDown, Enum.KeyCode.ButtonLeft, Enum.KeyCode.ButtonRight)

		self._gamepadThumbstick1ChangedConnection = GamepadService.GamepadThumbstick1Changed:Connect(function(p)
			self._moveVector = ProcessThumbstickInput(p)
		end)

		self._inputBeganConnection = UserInputService.InputBegan:Connect(function(input, _)
			if input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.ButtonCenter then
				self:OnActivate(Enum.UserInputState.Begin, input)
			end
		end)

		self._inputEndedConnection = UserInputService.InputEnded:Connect(function(input, _)
			if input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.ButtonCenter then
				self:OnActivate(Enum.UserInputState.End, input)
			end
		end)
	elseif self._behavior == Enums.Behavior.SelectionPreview then
		self._selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
			self:OnMove(Enum.UserInputState.Change, nil)
			self._previousSelection = GuiService.SelectedObject
		end)

		ContextActionService:BindCoreActionAtPriority(Enums.Action.Move, function(_: string, p, p2)
			return self:OnMove(p, p2)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick1)
	end
end

return InputController
