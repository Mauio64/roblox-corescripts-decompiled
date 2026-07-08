local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("Responsive").Parent
local AppCommonLib = require(Parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local FFlagLuaAppResponsiveEnginePreferredInput = require(Parent.SharedFlags).FFlagLuaAppResponsiveEnginePreferredInput
local t1 = {
	Pointer = "Pointer",
	Touch = "Touch",
	Directional = "Directional"
}
local t2 = {
	[Enum.UserInputType.MouseButton1] = t1.Pointer,
	[Enum.UserInputType.MouseButton2] = t1.Pointer,
	[Enum.UserInputType.MouseButton3] = t1.Pointer,
	[Enum.UserInputType.MouseWheel] = t1.Pointer,
	[Enum.UserInputType.MouseMovement] = t1.Pointer,
	[Enum.UserInputType.Keyboard] = t1.Pointer,
	[Enum.UserInputType.TextInput] = t1.Pointer,
	[Enum.UserInputType.Gamepad1] = t1.Directional,
	[Enum.UserInputType.Gamepad2] = t1.Directional,
	[Enum.UserInputType.Gamepad3] = t1.Directional,
	[Enum.UserInputType.Gamepad4] = t1.Directional,
	[Enum.UserInputType.Gamepad5] = t1.Directional,
	[Enum.UserInputType.Gamepad6] = t1.Directional,
	[Enum.UserInputType.Gamepad7] = t1.Directional,
	[Enum.UserInputType.Gamepad8] = t1.Directional,
	[Enum.UserInputType.Touch] = t1.Touch,
	[Enum.UserInputType.None] = t1.Pointer
}
local v8 = Signal.new()
local t3 = {
	preferred = nil,
	last = nil
}
local t4 = {
	[Enum.Platform.XBoxOne] = true,
	[Enum.Platform.XBox360] = true,
	[Enum.Platform.WiiU] = true,
	[Enum.Platform.PS3] = true,
	[Enum.Platform.PS4] = true,
	[Enum.Platform.PS5] = true,
	[Enum.Platform.Ouya] = true,
	[Enum.Platform.AndroidTV] = true
}
local t5 = {
	[Enum.Platform.IOS] = true,
	[Enum.Platform.Android] = true
}
local v12 = if not FFlagLuaAppResponsiveEnginePreferredInput then nil else {
	[Enum.PreferredInput.Gamepad] = t1.Directional,
	[Enum.PreferredInput.Touch] = t1.Touch,
	[Enum.PreferredInput.KeyboardAndMouse] = t1.Pointer
}

function getPreferredInput() -- line: 70
	-- upvalues: FFlagLuaAppResponsiveEnginePreferredInput (copy), UserInputService (copy), v12 (copy), t1 (copy), AppCommonLib (copy), t4 (copy), t5 (copy)
	if FFlagLuaAppResponsiveEnginePreferredInput then
		return v12[UserInputService.PreferredInput or Enum.PreferredInput.KeyboardAndMouse] or t1.Pointer
	end

	local Platform = UserInputService:GetPlatform()
	local v16 = AppCommonLib.isSpatial()
	local v17 = t4[Platform] or false
	local v18 = t5[Platform] or false

	if v16 then
		return t1.Pointer
	end

	if v17 then
		return t1.Directional
	end

	if v18 then
		return t1.Touch
	end

	return t1.Pointer
end
function updatePreferredInput() -- line: 92
	-- upvalues: t3 (copy), v8 (copy)
	local v19 = getPreferredInput()

	if v19 ~= t3.preferred then
		t3.preferred = v19

		if t3.last == nil then
			t3.last = t3.preferred
		end

		v8:fire()
	end
end
function updateLastInput() -- line: 103
	-- upvalues: t2 (copy), UserInputService (copy), t3 (copy), v8 (copy)
	local v20 = t2[UserInputService:GetLastInputType()]

	if v20 and v20 ~= t3.last then
		t3.last = v20
		v8:fire()
	end
end
function init() -- line: 111
	-- upvalues: FFlagLuaAppResponsiveEnginePreferredInput (copy), UserInputService (copy), AppCommonLib (copy)
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

local t6 = {
	{
		Key = t1.Directional,
		preferredInput = t1.Directional
	},
	{
		Key = t1.Pointer,
		preferredInput = t1.Pointer
	},
	{
		Key = t1.Touch,
		preferredInput = t1.Touch
	}
}
local t7 = {
	{
		Key = t1.Directional,
		lastInput = t1.Directional
	},
	{
		Key = t1.Pointer,
		lastInput = t1.Pointer
	},
	{
		Key = t1.Touch,
		lastInput = t1.Touch
	}
}

return {
	Enum = t1,
	preferredInputRules = t6,
	lastInputRules = t7,
	connect = function(p1) -- line: 144
		-- upvalues: v8 (copy)
		return v8:connect(p1)
	end,
	preferred = function() -- line: 147
		-- upvalues: t3 (copy)
		return t3.preferred
	end,
	last = function() -- line: 150
		-- upvalues: t3 (copy)
		return t3.last
	end
}
