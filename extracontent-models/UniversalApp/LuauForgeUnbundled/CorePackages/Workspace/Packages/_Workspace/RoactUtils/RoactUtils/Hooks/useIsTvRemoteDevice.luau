local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local fFlagLuaSupportMicroGamepadPreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/SharedFlags").FFlagLuaSupportMicroGamepadPreferredInput
local v5

if game:GetEngineFeature("EnableMicroGamepadKeycodes") then
	v5 = Enum.KeyCode.ButtonCenter
else
	v5 = Enum.KeyCode.Return
end

local function useIsTvRemoteDevice()
	local v6 = React.useCallback(function(): boolean
		local v7 = fFlagLuaSupportMicroGamepadPreferredInput
			and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad

		if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad and not v7 then
			return false
		end

		for i, v8 in ipairs(UserInputService:GetConnectedGamepads()) do
			if UserInputService:GamepadSupports(v8, v5) then
				return true
			end
		end

		return false
	end, {})

	local state, setState = React.useState(function()
		return v6()
	end)

	React.useEffect(function()
		local gamepadConnectedConnection = UserInputService.GamepadConnected:Connect(function()
			setState(v6())
		end)

		local preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			setState(v6())
		end)

		setState(v6())

		return function()
			gamepadConnectedConnection:Disconnect()
			preferredInputChangedConnection:Disconnect()
		end
	end, { v6 })

	return state
end

return useIsTvRemoteDevice
