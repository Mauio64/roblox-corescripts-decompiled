local set = {
	[Enum.UserInputType.MouseWheel] = true,
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.Touch] = true
}

local set2 = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}

local set3 = { [Enum.KeyCode.Thumbstick1] = true, [Enum.KeyCode.Thumbstick2] = true }

local function isScrollInput(data, flag: boolean): boolean
	if set[data.UserInputType] then
		return true
	end

	if not set2[data.UserInputType] then
		return false
	end

	return not flag or set3[data.KeyCode] == true and data.Position.Magnitude > 0.2
end

return isScrollInput
