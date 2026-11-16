local parent = script.Parent
local parent2 = parent.Parent

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(parent2.SharedFlags)
local FFlagVirtualCursorForTVRemoteKeycodes = SharedFlags.FFlagVirtualCursorForTVRemoteKeycodes

local Properties = require(parent.Properties)
local Interface = require(parent.Interface)
local getDirectionalMoveVector = require(parent.getDirectionalMoveVector)

local Input = {}

local thumbstickVector = Vector2.new()
local vector2 = Vector2.new()
local flag = false
local v = false
local selectedObject = nil
os.clock()
local selectedObjectChangedConnection = nil
local gamepadThumbstick1ChangedConnection = nil
local selectionRect2DChangedConnection = nil
local v2 = false
local v3 = {}

local function processThumbstickInput(data)
	local v4, v5

	if data.Magnitude >= Properties.ThumbstickDeadzone then
		local v6 = math.atan2(data.y, data.x)
		local v7 = math.abs(math.cos(v6) * Properties.ThumbstickDeadzone)
		local v8 = math.abs(math.sin(v6) * Properties.ThumbstickDeadzone)

		v4 = math.max(math.abs(data.x) - v7, 0) / (1 - v7) * math.sign(data.x)
		v5 = math.max(math.abs(data.y) - v8, 0) / (1 - v8) * math.sign(data.y)
	else
		v4 = 0
		v5 = 0
	end

	return Vector2.new(v4, -v5)
end

local function onThumbstick2Input(_, p, p2)
	if p == Enum.UserInputState.Change then
		vector2 = Vector2.new(p2.Position.x, p2.Position.y * -1)
		return Enum.ContextActionResult.Sink
	end

	vector2 = Vector2.new()
	return Enum.ContextActionResult.Pass
end

local function getRectCenter(selectionRect2D: Rect) -- 4 equivalent calls inferred from this helper
	return (selectionRect2D.Min + selectionRect2D.Max) / 2
end

local function processPreviewEnabled(flag2: boolean) -- 1 equivalent call inferred from this helper
	if flag2 and not v then
		if selectedObject then
			Interface:EnableUI(getRectCenter(selectedObject.SelectionRect2D)) -- inferred equivalent call
		else
			Interface:EnableUI(getRectCenter(GuiService.SelectedObject.SelectionRect2D)) -- inferred equivalent call
		end

		v = true
	elseif not flag2 and v then
		Interface:DisableUI()
		v = false
	end

	if selectionRect2DChangedConnection then
		selectionRect2DChangedConnection:Disconnect()
	end

	if v and GuiService.SelectedObject then
		local selectedObject2 = GuiService.SelectedObject
		selectionRect2DChangedConnection = selectedObject2:GetPropertyChangedSignal("SelectionRect2D"):Connect(function()
			if selectedObject2 and v then
				Interface:TweenCursorPosition(getRectCenter(selectedObject2.SelectionRect2D)) -- inferred equivalent call
			end
		end)
	end

	if flag2 then
		Interface:TweenCursorPosition(getRectCenter(GuiService.SelectedObject.SelectionRect2D)) -- inferred equivalent call
	end
end

local function onThumbstick1Input()
	if GuiService.SelectedObject then
		local gamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

		local v4 = Vector2.zero

		for _, v5 in gamepadState do
			if v5.KeyCode == Enum.KeyCode.Thumbstick1 then
				v4 = processThumbstickInput(v5.Position)
			end
		end

		if v2 and v4 == Vector2.zero then
			v2 = false
		end

		processPreviewEnabled(v4 ~= Vector2.zero and v2 and GuiService.SelectedCoreObject == nil)
	else
		processPreviewEnabled(false) -- inferred equivalent call
	end
end

local function onDirectionalButtonsInput(_: string, p, p2)
	if not (FFlagVirtualCursorForTVRemoteKeycodes and flag) then
		return Enum.ContextActionResult.Pass
	end

	local v4 = Enum.ContextActionResult.Pass

	if p == Enum.UserInputState.Begin or p == Enum.UserInputState.Change then
		v3[p2.KeyCode] = p2.Position.Z
		v4 = Enum.ContextActionResult.Sink
	else
		v3[p2.KeyCode] = nil
	end

	thumbstickVector = getDirectionalMoveVector(v3)

	return v4
end

local function onSelectedObjectChanged()
	v2 = true

	onThumbstick1Input()

	selectedObject = GuiService.SelectedObject
end

UserInputService.InputBegan:Connect(function(input)
	if not flag then
		return
	end

	if
		input.UserInputType == Enum.UserInputType.Gamepad1
		and (input.KeyCode == Enum.KeyCode.ButtonA or FFlagVirtualCursorForTVRemoteKeycodes and input.KeyCode == Enum.KeyCode.ButtonCenter)
		and (GuiService.SelectedObject or GuiService.SelectedCoreObject)
	then
		Interface:PlayCursorTweenActivate()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if flag then
		if
			input.UserInputType == Enum.UserInputType.Gamepad1
			and (input.KeyCode == Enum.KeyCode.ButtonA or FFlagVirtualCursorForTVRemoteKeycodes and input.KeyCode == Enum.KeyCode.ButtonCenter)
		then
			Interface:PlayCursorTweenDefault()
		end
	elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick1 then
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

function Input.GetThumbstickVector(_)
	return thumbstickVector
end

function Input.GetThumbstick2Vector(_)
	return vector2
end

function Input.EnablePreview(_)
	selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(onSelectedObjectChanged)
end

function Input.DisablePreview(_)
	if selectedObjectChangedConnection then
		selectedObjectChangedConnection:Disconnect()
		selectedObjectChangedConnection = nil
	end
end

function Input.EnableInput(_)
	gamepadThumbstick1ChangedConnection = GamepadService.GamepadThumbstick1Changed:Connect(function(p)
		thumbstickVector = processThumbstickInput(p)
	end)

	ContextActionService:BindCoreActionAtPriority(
		"VirtualCursorThumbstick1Movement",
		function(_, _, _) end,
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

	if FFlagVirtualCursorForTVRemoteKeycodes then
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

function Input.DisableInput(_)
	if gamepadThumbstick1ChangedConnection then
		gamepadThumbstick1ChangedConnection:Disconnect()
		gamepadThumbstick1ChangedConnection = nil
	end

	thumbstickVector = Vector2.new()
	vector2 = Vector2.new()

	ContextActionService:UnbindCoreAction("VirtualCursorThumbstick1Movement")
	ContextActionService:UnbindCoreAction("VirtualCursorThumbstick2Movement")

	if FFlagVirtualCursorForTVRemoteKeycodes then
		ContextActionService:UnbindCoreAction("VirtualCursorDirectionalButtonsMovement")
		table.clear(v3)
	end

	if Enum.UserInputState.Cancel == Enum.UserInputState.Change then
		vector2 = Vector2.new((nil).Position.x, (nil).Position.y * -1)
		local _sink = Enum.ContextActionResult.Sink
	else
		vector2 = Vector2.new()
		local _pass = Enum.ContextActionResult.Pass
	end

	flag = false
end

return Input
