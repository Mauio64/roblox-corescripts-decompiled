local ParentParent = script.Parent.Parent
local ContextActionService = game:GetService("ContextActionService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local Util = require(ParentParent.Util)
local ProcessThumbstickInput = Util.ProcessThumbstickInput
local GetRectCenter = Util.GetRectCenter
local Enums = require(ParentParent.Enums)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 32
	-- upvalues: Enums (copy), t1 (copy)
	return (setmetatable({
		_enabled = false,
		_previousSelection = nil,
		_selectedObjectChangedConnection = nil,
		_gamepadSelectionRect2DChangedConnection = nil,
		_selectedRectChangedConnection = nil,
		_cursorController = p1,
		_moveVector = Vector2.new(),
		_scrollVector = Vector2.new(),
		_behavior = Enums.Behavior.SelectionPreview
	}, t1))
end
function t1.Destroy(p2) -- line: 48
	if p2._selectedObjectChangedConnection then
		p2._selectedObjectChangedConnection:Disconnect()
	end

	if p2._gamepadSelectionRect2DChangedConnection then
		p2._gamepadSelectionRect2DChangedConnection:Disconnect()
	end

	if p2._selectedRectChangedConnection then
		p2._selectedRectChangedConnection:Disconnect()
	end
end
function t1.OnMove(t2: {[any]: any}, _, p4) -- line: 62
	-- upvalues: Enums (copy), GuiService (copy), ProcessThumbstickInput (copy), GetRectCenter (copy)
	if t2._behavior ~= Enums.Behavior.SelectionPreview then
		return Enum.ContextActionResult.Pass
	end

	if GuiService.SelectedObject == nil then
		return Enum.ContextActionResult.Pass
	end

	if p4 then
		t2._moveVector = ProcessThumbstickInput(Vector2.new(p4.Position.X, p4.Position.Y))
	end

	local v15 = GuiService.SelectedCoreObject == nil or GuiService.SelectedObject ~= nil
	local v16 = t2._moveVector ~= Vector2.zero
	local v17 = v15 and v16

	if v17 and not t2._cursorController:GetEnabled() then
		if t2._previousSelection then
			t2._cursorController:Enable(GetRectCenter(t2._previousSelection.SelectionRect2D))
		elseif GuiService.SelectedObject then
			t2._cursorController:Enable(GetRectCenter(GuiService.SelectedObject.SelectionRect2D))
		end
	elseif not v17 and t2._cursorController:GetEnabled() then
		t2._cursorController:Disable()
	end

	local _selectedRectChangedConnection = t2._selectedRectChangedConnection

	if _selectedRectChangedConnection then
		_selectedRectChangedConnection:Disconnect()
		t2._selectedRectChangedConnection = nil
	end

	if v17 and GuiService.SelectedObject then
		local SelectedObject = GuiService.SelectedObject

		t2._selectedRectChangedConnection = SelectedObject:GetPropertyChangedSignal("SelectionRect2D"):Connect(function() -- line: 103
			-- upvalues: SelectedObject (copy), t2 (copy), Enums (copy), GetRectCenter (copy)
			if SelectedObject and t2._behavior == Enums.Behavior.SelectionPreview then
				t2._cursorController:TweenPosition(GetRectCenter(SelectedObject.SelectionRect2D))
			end
		end)
		t2._cursorController:TweenPosition(GetRectCenter(GuiService.SelectedObject.SelectionRect2D))
	end

	return Enum.ContextActionResult.Pass
end
function t1.OnScroll(t3: {[any]: any}, p5, p6) -- line: 116
	-- upvalues: Enums (copy)
	if t3._behavior == Enums.Behavior.VirtualCursor then
		if p5 == Enum.UserInputState.Change and p6 then
			t3._scrollVector = Vector2.new(p6.Position.X, p6.Position.Y) * Vector2.new(1, -1)

			return Enum.ContextActionResult.Sink
		end

		t3._scrollVector = Vector2.zero
	end

	return Enum.ContextActionResult.Pass
end
function t1.OnActivate(t4: {[any]: any}, p7, _) -- line: 129
	-- upvalues: GuiService (copy)
	if p7 == Enum.UserInputState.Begin then
		if GuiService.SelectedObject or GuiService.SelectedCoreObject then
			t4._cursorController:PlayTweenActivate()
		end
	elseif p7 == Enum.UserInputState.End and (GuiService.SelectedObject or GuiService.SelectedCoreObject) then
		t4._cursorController:PlayTweenDefault()
	end

	return Enum.ContextActionResult.Pass
end
function t1.GetMoveVector(p9) -- line: 143
	return p9._moveVector
end
function t1.GetScrollVector(p10) -- line: 147
	return p10._scrollVector
end
function t1.SetBehavior(p11, p12) -- line: 151
	-- upvalues: Enums (copy), ContextActionService (copy), GamepadService (copy), ProcessThumbstickInput (copy), GuiService (copy)
	local _behavior = p11._behavior

	p11._behavior = p12

	if _behavior == Enums.Behavior.VirtualCursor then
		p11._moveVector = Vector2.new()
		p11._scrollVector = Vector2.new()
		ContextActionService:UnbindCoreAction(Enums.Action.Activate)
		ContextActionService:UnbindCoreAction(Enums.Action.Scroll)

		local _gamepadThumbstick1ChangedConnection = p11._gamepadThumbstick1ChangedConnection

		if _gamepadThumbstick1ChangedConnection then
			_gamepadThumbstick1ChangedConnection:Disconnect()
			p11._gamepadThumbstick1ChangedConnection = nil
		end

		p11:OnScroll(Enum.UserInputState.Cancel, nil)
	elseif _behavior == Enums.Behavior.SelectionPreview then
		ContextActionService:UnbindCoreAction(Enums.Action.Move)

		local _selectedObjectChangedConnection = p11._selectedObjectChangedConnection

		if _selectedObjectChangedConnection then
			_selectedObjectChangedConnection:Disconnect()
			p11._selectedObjectChangedConnection = nil
		end

		local _selectedRectChangedConnection = p11._selectedRectChangedConnection

		if _selectedRectChangedConnection then
			_selectedRectChangedConnection:Disconnect()
			p11._selectedRectChangedConnection = nil
		end
	end

	if p11._behavior == Enums.Behavior.VirtualCursor then
		ContextActionService:BindCoreActionAtPriority(Enums.Action.Activate, function(_: string, p13, p14) -- line: 188
			-- upvalues: p11 (copy)
			return p11:OnActivate(p13, p14)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonA)
		ContextActionService:BindCoreActionAtPriority(Enums.Action.Scroll, function(_: string, p15, p16) -- line: 198
			-- upvalues: p11 (copy)
			return p11:OnScroll(p15, p16)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick2)
		p11._gamepadThumbstick1ChangedConnection = GamepadService.GamepadThumbstick1Changed:Connect(function(p17) -- line: 206
			-- upvalues: p11 (copy), ProcessThumbstickInput (copy)
			p11._moveVector = ProcessThumbstickInput(p17)
		end)

		return
	end

	if p11._behavior == Enums.Behavior.SelectionPreview then
		p11._selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 210
			-- upvalues: p11 (copy), GuiService (copy)
			p11:OnMove(Enum.UserInputState.Change, nil)
			p11._previousSelection = GuiService.SelectedObject
		end)
		ContextActionService:BindCoreActionAtPriority(Enums.Action.Move, function(_: string, p18, p19) -- line: 217
			-- upvalues: p11 (copy)
			return p11:OnMove(p18, p19)
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick1)
	end
end

return t1
