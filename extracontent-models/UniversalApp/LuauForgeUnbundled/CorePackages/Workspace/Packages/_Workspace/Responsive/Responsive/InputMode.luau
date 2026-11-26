local UserInputService = game:GetService("UserInputService")

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/AppCommonLib")
local signal = AppCommonLib.Signal

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/SharedFlags")
local fFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local fFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local v5 = { Pointer = "Pointer", Touch = "Touch", Directional = "Directional" }

local v6 = {
	[Enum.UserInputType.MouseButton1] = v5.Pointer,
	[Enum.UserInputType.MouseButton2] = v5.Pointer,
	[Enum.UserInputType.MouseButton3] = v5.Pointer,
	[Enum.UserInputType.MouseWheel] = v5.Pointer,
	[Enum.UserInputType.MouseMovement] = v5.Pointer,
	[Enum.UserInputType.Keyboard] = v5.Pointer,
	[Enum.UserInputType.TextInput] = v5.Pointer,
	[Enum.UserInputType.Gamepad1] = v5.Directional,
	[Enum.UserInputType.Gamepad2] = v5.Directional,
	[Enum.UserInputType.Gamepad3] = v5.Directional,
	[Enum.UserInputType.Gamepad4] = v5.Directional,
	[Enum.UserInputType.Gamepad5] = v5.Directional,
	[Enum.UserInputType.Gamepad6] = v5.Directional,
	[Enum.UserInputType.Gamepad7] = v5.Directional,
	[Enum.UserInputType.Gamepad8] = v5.Directional,
	[Enum.UserInputType.Touch] = v5.Touch,
	[Enum.UserInputType.None] = v5.Pointer
}

local v7 = signal.new()
local v8 = { preferred = nil, last = nil }

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
local v9

if fFlagLuaAppResponsiveEnginePreferredInput then
	v9 = {}
	v9[Enum.PreferredInput.Gamepad] = v5.Directional
	v9[Enum.PreferredInput.Touch] = v5.Touch
	v9[Enum.PreferredInput.KeyboardAndMouse] = v5.Pointer
else
	v9 = nil
end

if fFlagLuaAppResponsiveEnginePreferredInput and fFlagLuaSupportMicroGamepadPreferredInput then
	v9[Enum.PreferredInput.MicroGamepad] = v5.Directional
end

function LUAUFORGE_MODULE_GLOBALS_xN_getPreferredInput()
	if fFlagLuaAppResponsiveEnginePreferredInput then
		local preferredInput = UserInputService.PreferredInput or Enum.PreferredInput.KeyboardAndMouse
		return v9[preferredInput] or v5.Pointer
	end

	local platform = UserInputService:GetPlatform()
	local spatial = AppCommonLib.isSpatial()
	local v10 = set[platform] or false
	local v11 = set2[platform] or false

	if spatial then
		return v5.Pointer
	end

	if v10 then
		return v5.Directional
	end

	if v11 then
		return v5.Touch
	end

	return v5.Pointer
end

function LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput()
	local v10 = LUAUFORGE_MODULE_GLOBALS_xN_getPreferredInput()

	if v10 ~= v8.preferred then
		v8.preferred = v10

		if v8.last == nil then
			v8.last = v8.preferred
		end

		v7:fire()
	end
end

function LUAUFORGE_MODULE_GLOBALS_xN_updateLastInput()
	local v10 = v6[UserInputService:GetLastInputType()]

	if v10 and v10 ~= v8.last then
		v8.last = v10
		v7:fire()
	end
end

function LUAUFORGE_MODULE_GLOBALS_xN_init()
	if fFlagLuaAppResponsiveEnginePreferredInput then
		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput)
	end

	UserInputService.GamepadConnected:Connect(LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput)
	UserInputService:GetPropertyChangedSignal("GamepadEnabled"):Connect(LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput)
	AppCommonLib.connectToIsSpatialChanged(LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput)
	UserInputService.LastInputTypeChanged:Connect(LUAUFORGE_MODULE_GLOBALS_xN_updateLastInput)
	LUAUFORGE_MODULE_GLOBALS_xN_updateLastInput()
	LUAUFORGE_MODULE_GLOBALS_xN_updatePreferredInput()
end

LUAUFORGE_MODULE_GLOBALS_xN_init()

return {
	Enum = v5,
	preferredInputRules = {
		{ Key = v5.Directional, preferredInput = v5.Directional },
		{ Key = v5.Pointer, preferredInput = v5.Pointer },
		{ Key = v5.Touch, preferredInput = v5.Touch }
	},
	lastInputRules = {
		{ Key = v5.Directional, lastInput = v5.Directional },
		{ Key = v5.Pointer, lastInput = v5.Pointer },
		{ Key = v5.Touch, lastInput = v5.Touch }
	},
	connect = function(p2)
		return v7:connect(p2)
	end,
	preferred = function()
		return v8.preferred
	end,
	last = function()
		return v8.last
	end
}
