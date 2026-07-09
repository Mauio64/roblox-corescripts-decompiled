local scriptParent = script.Parent
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local Properties = require(scriptParent.Properties)
local Interface = require(scriptParent.Interface)
local t1 = {}
local vector2 = Vector2.new()
local vector2_2 = Vector2.new()
local u11 = false
local u12 = false
local SelectedObject = nil

os.clock()

local connection = nil
local connection2 = nil
local connection3 = nil
local u17 = false

local function processThumbstickInput(p1) -- line: 29
	-- upvalues: Properties (copy)
	local n1 = 0
	local n2 = 0

	if p1.Magnitude >= Properties.ThumbstickDeadzone then
		local v27 = math.atan2(p1.y, p1.x)
		local v28 = math.abs(math.cos(v27) * Properties.ThumbstickDeadzone)
		local v29 = math.abs(math.sin(v27) * Properties.ThumbstickDeadzone)

		n1 = math.max(math.abs(p1.x) - v28, 0) / (1 - v28) * math.sign(p1.x)
		n2 = math.max(math.abs(p1.y) - v29, 0) / (1 - v29) * math.sign(p1.y)
	end

	return Vector2.new(n1, -n2)
end
local function onThumbstick2Input(_, p3, p4) -- line: 42
	-- upvalues: vector2_2 (ref)
	if p3 == Enum.UserInputState.Change then
		vector2_2 = Vector2.new(p4.Position.x, p4.Position.y * -1)

		return Enum.ContextActionResult.Sink
	end

	vector2_2 = Vector2.new()

	return Enum.ContextActionResult.Pass
end
local function getRectCenter(rect: Rect) -- line: 53
	return (rect.Min + rect.Max) / 2
end
local function processPreviewEnabled(b1: boolean) -- line: 57
	-- upvalues: u12 (ref), SelectedObject (ref), Interface (copy), GuiService (copy), connection3 (ref)
	if b1 and not u12 then
		if SelectedObject then
			local v35 = Interface
			local SelectionRect2D = SelectedObject.SelectionRect2D

			v35:EnableUI((SelectionRect2D.Min + SelectionRect2D.Max) / 2)
		else
			local v37 = Interface
			local SelectionRect2D = GuiService.SelectedObject.SelectionRect2D

			v37:EnableUI((SelectionRect2D.Min + SelectionRect2D.Max) / 2)
		end

		u12 = true
	elseif not b1 and u12 then
		Interface:DisableUI()
		u12 = false
	end

	if connection3 then
		connection3:Disconnect()
	end

	if u12 and GuiService.SelectedObject then
		local SelectedObject2 = GuiService.SelectedObject

		connection3 = SelectedObject2:GetPropertyChangedSignal("SelectionRect2D"):Connect(function() -- line: 78
			-- upvalues: SelectedObject2 (copy), u12 (ref), Interface (copy)
			if SelectedObject2 and u12 then
				local v58 = Interface
				local SelectionRect2D = SelectedObject2.SelectionRect2D

				v58:TweenCursorPosition((SelectionRect2D.Min + SelectionRect2D.Max) / 2)
			end
		end)
	end

	if b1 then
		local v40 = Interface
		local SelectionRect2D = GuiService.SelectedObject.SelectionRect2D

		v40:TweenCursorPosition((SelectionRect2D.Min + SelectionRect2D.Max) / 2)
	end
end
local function onThumbstick1Input() -- line: 90
	-- upvalues: GuiService (copy), UserInputService (copy), processThumbstickInput (copy), u17 (ref), processPreviewEnabled (copy), u12 (ref), Interface (copy), connection3 (ref)
	if GuiService.SelectedObject then
		local GamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
		local zero = Vector2.zero

		for _, v45 in GamepadState do
			if v45.KeyCode == Enum.KeyCode.Thumbstick1 then
				zero = processThumbstickInput(v45.Position)
			end
		end

		if u17 and zero == Vector2.zero then
			u17 = false
		end

		processPreviewEnabled(zero ~= Vector2.zero and (u17 and GuiService.SelectedCoreObject == nil))

		return
	end

	if u12 then
		Interface:DisableUI()
		u12 = false
	end

	if connection3 then
		connection3:Disconnect()
	end

	if u12 and GuiService.SelectedObject then
		local SelectedObject3 = GuiService.SelectedObject

		connection3 = SelectedObject3:GetPropertyChangedSignal("SelectionRect2D"):Connect(function() -- line: 78
			-- upvalues: SelectedObject3 (copy), u12 (ref), Interface (copy)
			if SelectedObject3 and u12 then
				local v60 = Interface
				local SelectionRect2D = SelectedObject3.SelectionRect2D

				v60:TweenCursorPosition((SelectionRect2D.Min + SelectionRect2D.Max) / 2)
			end
		end)
	end
end
local function onSelectedObjectChanged() -- line: 115
	-- upvalues: u17 (ref), onThumbstick1Input (copy), SelectedObject (ref), GuiService (copy)
	u17 = true
	onThumbstick1Input()
	SelectedObject = GuiService.SelectedObject
end

UserInputService.InputBegan:Connect(function(input) -- line: 123
	-- upvalues: u11 (ref), GuiService (copy), Interface (copy)
	if not u11 then
		return
	end

	if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA and (GuiService.SelectedObject or GuiService.SelectedCoreObject) then
		Interface:PlayCursorTweenActivate()
	end
end)
UserInputService.InputEnded:Connect(function(input) -- line: 136
	-- upvalues: u11 (ref), Interface (copy), onThumbstick1Input (copy)
	if u11 then
		if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA then
			Interface:PlayCursorTweenDefault()

			return
		end
	elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick1 then
		onThumbstick1Input()
	end
end)
UserInputService.InputChanged:Connect(function(input) -- line: 152
	-- upvalues: u11 (ref), onThumbstick1Input (copy)
	if u11 then
		return
	end

	if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick1 then
		onThumbstick1Input()
	end
end)

function t1.GetThumbstickVector(_) -- line: 163
	-- upvalues: vector2 (ref)
	return vector2
end
function t1.GetThumbstick2Vector(_) -- line: 167
	-- upvalues: vector2_2 (ref)
	return vector2_2
end
function t1.EnablePreview(_) -- line: 171
	-- upvalues: connection (ref), GuiService (copy), onSelectedObjectChanged (copy)
	connection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(onSelectedObjectChanged)
end
function t1.DisablePreview(_) -- line: 176
	-- upvalues: connection (ref)
	if connection then
		connection:Disconnect()
		connection = nil
	end
end
function t1.EnableInput(_) -- line: 183
	-- upvalues: connection2 (ref), GamepadService (copy), vector2 (ref), processThumbstickInput (copy), ContextActionService (copy), onThumbstick2Input (copy), u11 (ref)
	connection2 = GamepadService.GamepadThumbstick1Changed:Connect(function(p10) -- line: 184
		-- upvalues: vector2 (ref), processThumbstickInput (copy)
		vector2 = processThumbstickInput(p10)
	end)
	ContextActionService:BindCoreActionAtPriority("VirtualCursorThumbstick1Movement", function(_, _, _) -- line: 190
	end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick1)
	ContextActionService:BindCoreActionAtPriority("VirtualCursorThumbstick2Movement", onThumbstick2Input, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick2)
	u11 = true
end
function t1.DisableInput(_) -- line: 207
	-- upvalues: connection2 (ref), vector2 (ref), vector2_2 (ref), ContextActionService (copy), u11 (ref)
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	vector2 = Vector2.new()
	vector2_2 = Vector2.new()
	ContextActionService:UnbindCoreAction("VirtualCursorThumbstick1Movement")
	ContextActionService:UnbindCoreAction("VirtualCursorThumbstick2Movement")

	if Enum.UserInputState.Cancel == Enum.UserInputState.Change then
		vector2_2 = Vector2.new((nil).Position.x, (nil).Position.y * -1)

		local _ = Enum.ContextActionResult.Sink
	else
		vector2_2 = Vector2.new()

		local _ = Enum.ContextActionResult.Pass
	end

	u11 = false
end

return t1
