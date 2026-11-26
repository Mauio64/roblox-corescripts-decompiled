local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")

local fFlagVirtualCursorForTVRemoteKeycodes = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/SharedFlags").FFlagVirtualCursorForTVRemoteKeycodes

local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Properties")
local Interface = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Interface")
local getDirectionalMoveVector = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/getDirectionalMoveVector")

local v5 = {}

local thumbstickVector = Vector2.new()
local vector2 = Vector2.new()
local flag = false
local flag2 = false
local selectedObject = nil
os.clock()
local selectedObjectChangedConnection = nil
local gamepadThumbstick1ChangedConnection = nil
local selectionRect2DChangedConnection = nil
local v6 = false
local v7 = {}

local function processThumbstickInput(data)
	local v8, v9

	if data.Magnitude >= Properties.ThumbstickDeadzone then
		local v10 = math.atan2(data.y, data.x)
		local v11 = math.abs(math.cos(v10) * Properties.ThumbstickDeadzone)
		local v12 = math.abs(math.sin(v10) * Properties.ThumbstickDeadzone)

		v8 = math.max(math.abs(data.x) - v11, 0) / (1 - v11) * math.sign(data.x)
		v9 = math.max(math.abs(data.y) - v12, 0) / (1 - v12) * math.sign(data.y)
	else
		v8 = 0
		v9 = 0
	end

	return Vector2.new(v8, -v9)
end

local function onThumbstick2Input(p2, p3, p4)
	if p3 == Enum.UserInputState.Change then
		vector2 = Vector2.new(p4.Position.x, p4.Position.y * -1)
		return Enum.ContextActionResult.Sink
	end

	vector2 = Vector2.new()
	return Enum.ContextActionResult.Pass
end

local function getRectCenter(p2)
	return (p2.Min + p2.Max) / 2
end

local function processPreviewEnabled(p2)
	if p2 and not flag2 then
		if selectedObject then
			local selectionRect2D = selectedObject.SelectionRect2D
			Interface:EnableUI((selectionRect2D.Min + selectionRect2D.Max) / 2)
		else
			local selectionRect2D = GuiService.SelectedObject.SelectionRect2D
			Interface:EnableUI((selectionRect2D.Min + selectionRect2D.Max) / 2)
		end

		flag2 = true
	elseif not p2 and flag2 then
		Interface:DisableUI()
		flag2 = false
	end

	if selectionRect2DChangedConnection then
		selectionRect2DChangedConnection:Disconnect()
	end

	if flag2 and GuiService.SelectedObject then
		local selectedObject2 = GuiService.SelectedObject
		selectionRect2DChangedConnection = selectedObject2:GetPropertyChangedSignal("SelectionRect2D"):Connect(function()
			if selectedObject2 and flag2 then
				local selectionRect2D = selectedObject2.SelectionRect2D
				Interface:TweenCursorPosition((selectionRect2D.Min + selectionRect2D.Max) / 2)
			end
		end)
	end

	if p2 then
		local selectionRect2D = GuiService.SelectedObject.SelectionRect2D
		Interface:TweenCursorPosition((selectionRect2D.Min + selectionRect2D.Max) / 2)
	end
end

local function onThumbstick1Input()
	if GuiService.SelectedObject then
		local gamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

		local v8 = Vector2.zero

		for k, v9 in gamepadState do
			if v9.KeyCode == Enum.KeyCode.Thumbstick1 then
				v8 = processThumbstickInput(v9.Position)
			end
		end

		if v6 and v8 == Vector2.zero then
			v6 = false
		end

		processPreviewEnabled(v8 ~= Vector2.zero and v6 and GuiService.SelectedCoreObject == nil)
	else
		if flag2 then
			Interface:DisableUI()
			flag2 = false
		end

		if selectionRect2DChangedConnection then
			selectionRect2DChangedConnection:Disconnect()
		end

		if flag2 and GuiService.SelectedObject then
			local selectedObject2 = GuiService.SelectedObject
			selectionRect2DChangedConnection = selectedObject2:GetPropertyChangedSignal("SelectionRect2D"):Connect(function()
				if selectedObject2 and flag2 then
					local selectionRect2D = selectedObject2.SelectionRect2D
					Interface:TweenCursorPosition((selectionRect2D.Min + selectionRect2D.Max) / 2)
				end
			end)
		end
	end
end

local function onDirectionalButtonsInput(p2, p3, p4)
	if not (fFlagVirtualCursorForTVRemoteKeycodes and flag) then
		return Enum.ContextActionResult.Pass
	end

	local v8 = Enum.ContextActionResult.Pass

	if p3 == Enum.UserInputState.Begin or p3 == Enum.UserInputState.Change then
		v7[p4.KeyCode] = p4.Position.Z
		v8 = Enum.ContextActionResult.Sink
	else
		v7[p4.KeyCode] = nil
	end

	thumbstickVector = getDirectionalMoveVector(v7)

	return v8
end

local function onSelectedObjectChanged()
	v6 = true

	onThumbstick1Input()

	selectedObject = GuiService.SelectedObject
end

UserInputService.InputBegan:Connect(function(input)
	if not flag then
		return
	end

	if
		input.UserInputType == Enum.UserInputType.Gamepad1
		and (input.KeyCode == Enum.KeyCode.ButtonA or fFlagVirtualCursorForTVRemoteKeycodes and input.KeyCode == Enum.KeyCode.ButtonCenter)
		and (GuiService.SelectedObject or GuiService.SelectedCoreObject)
	then
		Interface:PlayCursorTweenActivate()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if flag then
		if
			input.UserInputType == Enum.UserInputType.Gamepad1
			and (input.KeyCode == Enum.KeyCode.ButtonA or fFlagVirtualCursorForTVRemoteKeycodes and input.KeyCode == Enum.KeyCode.ButtonCenter)
		then
			Interface:PlayCursorTweenDefault()
		end
	elseif
		input.UserInputType == Enum.UserInputType.Gamepad1
		and input.KeyCode == Enum.KeyCode.Thumbstick1
	then
		onThumbstick1Input()
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if flag then
		return
	end

	if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick1 then
		onThumbstick1Input()
	end
end)

function v5:GetThumbstickVector()
	return thumbstickVector
end

function v5:GetThumbstick2Vector()
	return vector2
end

function v5:EnablePreview()
	selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(onSelectedObjectChanged)
end

function v5:DisablePreview()
	if selectedObjectChangedConnection then
		selectedObjectChangedConnection:Disconnect()
		selectedObjectChangedConnection = nil
	end
end

function v5:EnableInput()
	gamepadThumbstick1ChangedConnection = GamepadService.GamepadThumbstick1Changed:Connect(function(p3)
		thumbstickVector = processThumbstickInput(p3)
	end)

	ContextActionService:BindCoreActionAtPriority(
		"VirtualCursorThumbstick1Movement",
		function(p3, p4, p5) end,
		false,
		Enum.ContextActionPriority.High.Value,
		Enum.KeyCode.Thumbstick1
	)

	ContextActionService:BindCoreActionAtPriority(
		"VirtualCursorThumbstick2Movement",
		onThumbstick2Input,
		false,
		Enum.ContextActionPriority.High.Value,
		Enum.KeyCode.Thumbstick2
	)

	if fFlagVirtualCursorForTVRemoteKeycodes then
		ContextActionService:BindCoreActionAtPriority(
			"VirtualCursorDirectionalButtonsMovement",
			onDirectionalButtonsInput,
			false,
			Enum.ContextActionPriority.High.Value,
			Enum.KeyCode.ButtonUp,
			Enum.KeyCode.ButtonDown,
			Enum.KeyCode.ButtonLeft,
			Enum.KeyCode.ButtonRight
		)
	end

	flag = true
end

function v5:DisableInput()
	if gamepadThumbstick1ChangedConnection then
		gamepadThumbstick1ChangedConnection:Disconnect()
		gamepadThumbstick1ChangedConnection = nil
	end

	thumbstickVector = Vector2.new()
	vector2 = Vector2.new()

	ContextActionService:UnbindCoreAction("VirtualCursorThumbstick1Movement")
	ContextActionService:UnbindCoreAction("VirtualCursorThumbstick2Movement")

	if fFlagVirtualCursorForTVRemoteKeycodes then
		ContextActionService:UnbindCoreAction("VirtualCursorDirectionalButtonsMovement")
		table.clear(v7)
	end

	if Enum.UserInputState.Cancel == Enum.UserInputState.Change then
		vector2 = Vector2.new((nil).Position.x, (nil).Position.y * -1)
		local sink = Enum.ContextActionResult.Sink
	else
		vector2 = Vector2.new()
		local pass = Enum.ContextActionResult.Pass
	end

	flag = false
end

return v5
