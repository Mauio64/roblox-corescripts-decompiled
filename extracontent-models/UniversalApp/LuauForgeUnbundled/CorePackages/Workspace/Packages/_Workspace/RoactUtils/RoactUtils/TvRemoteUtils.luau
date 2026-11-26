local userInputService = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/MockableProxyServices").UserInputService

local fFlagLuaSupportMicroGamepadPreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/SharedFlags").FFlagLuaSupportMicroGamepadPreferredInput
local v5

if game:GetEngineFeature("EnableMicroGamepadKeycodes") then
	v5 = Enum.KeyCode.ButtonCenter
else
	v5 = Enum.KeyCode.Return
end

return {
	isTvRemoteDevice = function(): boolean
		local v6 = fFlagLuaSupportMicroGamepadPreferredInput
			and userInputService.PreferredInput == Enum.PreferredInput.MicroGamepad

		if userInputService.PreferredInput ~= Enum.PreferredInput.Gamepad and not v6 then
			return false
		end

		for k, v7 in userInputService:GetConnectedGamepads() do
			if userInputService:GamepadSupports(v7, v5) then
				return true
			end
		end

		return false
	end,
	isRealGamepadConnected = function(): boolean
		for k, v6 in userInputService:GetConnectedGamepads() do
			if not userInputService:GamepadSupports(v6, v5) then
				return true
			end
		end

		return false
	end
}
