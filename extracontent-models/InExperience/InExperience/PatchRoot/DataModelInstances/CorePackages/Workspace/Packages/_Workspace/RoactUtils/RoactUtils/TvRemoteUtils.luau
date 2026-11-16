local parent = script:FindFirstAncestor("RoactUtils").Parent

local MockableProxyServices = require(parent.MockableProxyServices)
local UserInputService = MockableProxyServices.UserInputService

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local v

if game:GetEngineFeature("EnableMicroGamepadKeycodes") then
	v = Enum.KeyCode.ButtonCenter
else
	v = Enum.KeyCode.Return
end

local TvRemoteUtils = {}

function TvRemoteUtils.isTvRemoteDevice(): boolean
	local v2 = FFlagLuaSupportMicroGamepadPreferredInput
		and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad

	if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad and not v2 then
		return false
	end

	for _, v3 in UserInputService:GetConnectedGamepads() do
		if UserInputService:GamepadSupports(v3, v) then
			return true
		end
	end

	return false
end

function TvRemoteUtils.isRealGamepadConnected(): boolean
	for _, v2 in UserInputService:GetConnectedGamepads() do
		if not UserInputService:GamepadSupports(v2, v) then
			return true
		end
	end

	return false
end

return TvRemoteUtils
