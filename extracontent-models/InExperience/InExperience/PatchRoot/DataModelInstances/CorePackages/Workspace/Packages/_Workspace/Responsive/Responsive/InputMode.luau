local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("Responsive").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local enum = { Pointer = "Pointer", Touch = "Touch", Directional = "Directional" }

local v = {
	[Enum.UserInputType.MouseButton1] = enum.Pointer,
	[Enum.UserInputType.MouseButton2] = enum.Pointer,
	[Enum.UserInputType.MouseButton3] = enum.Pointer,
	[Enum.UserInputType.MouseWheel] = enum.Pointer,
	[Enum.UserInputType.MouseMovement] = enum.Pointer,
	[Enum.UserInputType.Keyboard] = enum.Pointer,
	[Enum.UserInputType.TextInput] = enum.Pointer,
	[Enum.UserInputType.Gamepad1] = enum.Directional,
	[Enum.UserInputType.Gamepad2] = enum.Directional,
	[Enum.UserInputType.Gamepad3] = enum.Directional,
	[Enum.UserInputType.Gamepad4] = enum.Directional,
	[Enum.UserInputType.Gamepad5] = enum.Directional,
	[Enum.UserInputType.Gamepad6] = enum.Directional,
	[Enum.UserInputType.Gamepad7] = enum.Directional,
	[Enum.UserInputType.Gamepad8] = enum.Directional,
	[Enum.UserInputType.Touch] = enum.Touch,
	[Enum.UserInputType.None] = enum.Pointer
}

local v2 = Signal.new()
local v3 = { preferred = nil, last = nil }

local set = {
	[Enum.Platform.XBoxOne] = true,
	[Enum.Platform.XBox360] = true,
	[Enum.Platform.WiiU] = true,
	[Enum.Platform.PS3] = true,
	[Enum.Platform.PS4] = true,
	[Enum.Platform.PS5] = true,
	[Enum.Platform.Ouya] = true,
	[Enum.Platform.AndroidTV] = true
}

local set2 = { [Enum.Platform.IOS] = true, [Enum.Platform.Android] = true }
local v4

if FFlagLuaAppResponsiveEnginePreferredInput then
	v4 = {}
	v4[Enum.PreferredInput.Gamepad] = enum.Directional
	v4[Enum.PreferredInput.Touch] = enum.Touch
	v4[Enum.PreferredInput.KeyboardAndMouse] = enum.Pointer
else
	v4 = nil
end

if FFlagLuaAppResponsiveEnginePreferredInput and FFlagLuaSupportMicroGamepadPreferredInput then
	v4[Enum.PreferredInput.MicroGamepad] = enum.Directional
end

function getPreferredInput()
	if FFlagLuaAppResponsiveEnginePreferredInput then
		local preferredInput = UserInputService.PreferredInput or Enum.PreferredInput.KeyboardAndMouse
		return v4[preferredInput] or enum.Pointer
	end

	local platform = UserInputService:GetPlatform()
	local spatial = AppCommonLib.isSpatial()
	local v5 = set[platform] or false
	local v6 = set2[platform] or false

	if spatial then
		return enum.Pointer
	end

	if v5 then
		return enum.Directional
	end

	return if v6 then enum.Touch else enum.Pointer
end

function updatePreferredInput()
	local preferredInput = getPreferredInput()

	if preferredInput ~= v3.preferred then
		v3.preferred = preferredInput

		if v3.last == nil then
			v3.last = v3.preferred
		end

		v2:fire()
	end
end

function updateLastInput()
	local last = v[UserInputService:GetLastInputType()]

	if last and last ~= v3.last then
		v3.last = last
		v2:fire()
	end
end

function init()
	if FFlagLuaAppResponsiveEnginePreferredInput then
		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(updatePreferredInput)
	end

	UserInputService.GamepadConnected:Connect(updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("GamepadEnabled"):Connect(updatePreferredInput)
	AppCommonLib.connectToIsSpatialChanged(updatePreferredInput)
	UserInputService.LastInputTypeChanged:Connect(updateLastInput)
	updateLastInput()
	updatePreferredInput()
end

init()
local InputMode = {}
InputMode.Enum = enum
InputMode.preferredInputRules = {
	{ Key = enum.Directional, preferredInput = enum.Directional },
	{ Key = enum.Pointer, preferredInput = enum.Pointer },
	{ Key = enum.Touch, preferredInput = enum.Touch }
}

InputMode.lastInputRules = {
	{ Key = enum.Directional, lastInput = enum.Directional },
	{ Key = enum.Pointer, lastInput = enum.Pointer },
	{ Key = enum.Touch, lastInput = enum.Touch }
}

function InputMode:connect()
	return v2:connect(self)
end

function InputMode.preferred()
	return v3.preferred
end

function InputMode.last()
	return v3.last
end

return InputMode
