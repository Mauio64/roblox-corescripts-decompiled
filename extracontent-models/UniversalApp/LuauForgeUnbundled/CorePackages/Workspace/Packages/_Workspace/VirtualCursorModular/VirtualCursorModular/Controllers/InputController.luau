local ContextActionService = game:GetService("ContextActionService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Util = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Util")
local processThumbstickInput = Util.ProcessThumbstickInput
local getRectCenter = Util.GetRectCenter
local getThumbstickInputFromDirectionalInput = Util.GetThumbstickInputFromDirectionalInput

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Enums")

local class = {}
class.__index = class

function class.new(p2)
	return (setmetatable({
		_cursorController = p2,
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
	}, class))
end

function class:Destroy()
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

function class:OnMove(p2, p3)
	if not (self._behavior == Enums.Behavior.SelectionPreview and GuiService.SelectedObject ~= nil) then
		return Enum.ContextActionResult.Pass
	end

	if p3 then
		self._moveVector = processThumbstickInput(Vector2.new(p3.Position.X, p3.Position.Y))
	end

	local v5 = GuiService.SelectedCoreObject == nil or GuiService.SelectedObject ~= nil
	local v6 = self._moveVector ~= Vector2.zero

	local v7 = v5 and v6

	if v7 and not self._cursorController:GetEnabled() then
		if self._previousSelection then
			self._cursorController:Enable(getRectCenter(self._previousSelection.SelectionRect2D))
		elseif GuiService.SelectedObject then
			self._cursorController:Enable(getRectCenter(GuiService.SelectedObject.SelectionRect2D))
		end
	elseif not v7 and self._cursorController:GetEnabled() then
		self._cursorController:Disable()
	end

	local selectedRectChangedConnection = self._selectedRectChangedConnection

	if selectedRectChangedConnection then
		selectedRectChangedConnection:Disconnect()
		self._selectedRectChangedConnection = nil
	end

	if v7 and GuiService.SelectedObject then
		local selectedObject = GuiService.SelectedObject
		self._selectedRectChangedConnection = selectedObject:GetPropertyChangedSignal("SelectionRect2D"):Connect(function()
			if selectedObject and self._behavior == Enums.Behavior.SelectionPreview then
				self._cursorController:TweenPosition(getRectCenter(selectedObject.SelectionRect2D))
			end
		end)

		self._cursorController:TweenPosition(getRectCenter(GuiService.SelectedObject.SelectionRect2D))
	end

	return Enum.ContextActionResult.Pass
end

function class:OnScroll(p3, p4)
	if self._behavior ~= Enums.Behavior.VirtualCursor then
		return Enum.ContextActionResult.Pass
	end

	if p3 == Enum.UserInputState.Change and p4 then
		self._scrollVector = Vector2.new(p4.Position.X, p4.Position.Y) * Vector2.new(1, -1)
		return Enum.ContextActionResult.Sink
	end

	self._scrollVector = Vector2.zero

	return Enum.ContextActionResult.Pass
end

function class:OnActivate(p3, p4)
	if p3 == Enum.UserInputState.Begin then
		if GuiService.SelectedObject or GuiService.SelectedCoreObject then
			self._cursorController:PlayTweenActivate()
		end
	elseif
		p3 == Enum.UserInputState.End
		and (GuiService.SelectedObject or GuiService.SelectedCoreObject)
	then
		self._cursorController:PlayTweenDefault()
	end

	return Enum.ContextActionResult.Pass
end

function class:OnDirectionalButtons(p2, p3)
	if self._behavior ~= Enums.Behavior.VirtualCursor or not p3 then
		return Enum.ContextActionResult.Pass
	end

	local keyCode = p3.KeyCode

	if
		keyCode ~= Enum.KeyCode.ButtonUp
		and keyCode ~= Enum.KeyCode.ButtonDown
		and keyCode ~= Enum.KeyCode.ButtonLeft
		and keyCode ~= Enum.KeyCode.ButtonRight
	then
		return Enum.ContextActionResult.Pass
	end

	local v5 = Enum.ContextActionResult.Pass

	if p2 == Enum.UserInputState.Begin or p2 == Enum.UserInputState.Change then
		self._activeDirections[p3.KeyCode] = p3.Position.Z
		v5 = Enum.ContextActionResult.Sink
	else
		self._activeDirections[p3.KeyCode] = nil
	end

	local v6 = Vector2.zero

	for k, activeDirection in self._activeDirections do
		v6 += getThumbstickInputFromDirectionalInput(k, activeDirection)
	end

	if v6.Magnitude > 1 then
		v6 = v6.Unit
	end

	self._moveVector = processThumbstickInput(v6)

	return v5
end

function class:GetMoveVector()
	return self._moveVector
end

function class:GetScrollVector()
	return self._scrollVector
end

function class:SetBehavior(behavior)
	local behavior2 = self._behavior
	self._behavior = behavior

	if behavior2 == Enums.Behavior.VirtualCursor then
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
	elseif behavior2 == Enums.Behavior.SelectionPreview then
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
		ContextActionService:BindCoreActionAtPriority(Enums.Action.Scroll, function(p2, p3, p4)
			return self:OnScroll(p3, p4)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick2)

		ContextActionService:BindCoreActionAtPriority(Enums.Action.DirectionalMove, function(p2, p3, p4)
			return self:OnDirectionalButtons(p3, p4)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonUp, Enum.KeyCode.ButtonDown, Enum.KeyCode.ButtonLeft, Enum.KeyCode.ButtonRight)

		self._gamepadThumbstick1ChangedConnection = GamepadService.GamepadThumbstick1Changed:Connect(function(p2)
			self._moveVector = processThumbstickInput(p2)
		end)

		self._inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.ButtonCenter then
				self:OnActivate(Enum.UserInputState.Begin, input)
			end
		end)

		self._inputEndedConnection = UserInputService.InputEnded:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.ButtonCenter then
				self:OnActivate(Enum.UserInputState.End, input)
			end
		end)
	elseif self._behavior == Enums.Behavior.SelectionPreview then
		self._selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
			self:OnMove(Enum.UserInputState.Change, nil)
			self._previousSelection = GuiService.SelectedObject
		end)

		ContextActionService:BindCoreActionAtPriority(Enums.Action.Move, function(p2, p3, p4)
			return self:OnMove(p3, p4)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick1)
	end
end

return class
