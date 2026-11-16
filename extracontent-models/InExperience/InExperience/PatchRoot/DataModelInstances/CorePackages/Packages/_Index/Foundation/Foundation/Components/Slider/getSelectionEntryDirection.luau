local Foundation = script:FindFirstAncestor("Foundation")

local Services = require(Foundation.Utility.Wrappers.Services)
local UserInputService = Services.UserInputService

local constants = require(script.Parent.constants)

local function getActiveGamepad() -- 2 equivalent calls inferred from this helper
	local lastInputType = UserInputService:GetLastInputType()

	if
		lastInputType.Name:match("^Gamepad")
		and table.find(UserInputService:GetConnectedGamepads(), lastInputType) ~= nil
	then
		return lastInputType
	end

	return nil
end

local function isHeld(p, p2) -- 8 equivalent calls inferred from this helper
	if UserInputService:IsKeyDown(p) then
		return true
	end

	local activeGamepad = getActiveGamepad() -- inferred equivalent call
	return activeGamepad ~= nil and UserInputService:IsGamepadButtonDown(activeGamepad, p2)
end

local function getThumbstickDirection(flag: boolean): number
	local activeGamepad = getActiveGamepad() -- inferred equivalent call

	if not activeGamepad then
		return 0
	end

	for _, v in UserInputService:GetGamepadState(activeGamepad) do
		if v.KeyCode == Enum.KeyCode.Thumbstick1 then
			local x = v.Position.X
			local y = v.Position.Y
			local v2

			if flag then
				v2 = constants.thumbstickDeadzone <= y or constants.thumbstickDeadzone <= x
			else
				v2 = constants.thumbstickDeadzone <= x or y <= -constants.thumbstickDeadzone
			end

			local v3

			if flag then
				v3 = y <= -constants.thumbstickDeadzone or x <= -constants.thumbstickDeadzone
			else
				v3 = x <= -constants.thumbstickDeadzone or constants.thumbstickDeadzone <= y
			end

			if v2 then
				return 1
			end

			return if v3 then -1 else 0
		end
	end

	return 0
end

local function getSelectionEntryDirection(flag: boolean)
	local v

	if flag then
		v = isHeld(Enum.KeyCode.Up, Enum.KeyCode.DPadUp) or isHeld(Enum.KeyCode.Right, Enum.KeyCode.DPadRight) -- inferred equivalent call
	else
		v = isHeld(Enum.KeyCode.Right, Enum.KeyCode.DPadRight) or isHeld(Enum.KeyCode.Down, Enum.KeyCode.DPadDown) -- inferred equivalent call
	end

	local v2

	if flag then
		v2 = isHeld(Enum.KeyCode.Down, Enum.KeyCode.DPadDown) or isHeld(Enum.KeyCode.Left, Enum.KeyCode.DPadLeft) -- inferred equivalent call
	else
		v2 = isHeld(Enum.KeyCode.Left, Enum.KeyCode.DPadLeft) or isHeld(Enum.KeyCode.Up, Enum.KeyCode.DPadUp) -- inferred equivalent call
	end

	if v then
		return 1
	end

	if v2 then
		return -1
	end

	return getThumbstickDirection(flag)
end

return getSelectionEntryDirection
