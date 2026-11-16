local parent = script:FindFirstAncestor("RoactUtils").Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local v

if game:GetEngineFeature("EnableMicroGamepadKeycodes") then
	v = Enum.KeyCode.ButtonCenter
else
	v = Enum.KeyCode.Return
end

local function useIsTvRemoteDevice()
	local v2 = React.useCallback(function(): boolean
		local v2 = FFlagLuaSupportMicroGamepadPreferredInput
			and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad

		if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad and not v2 then
			return false
		end

		for _, v3 in ipairs(UserInputService:GetConnectedGamepads()) do
			if UserInputService:GamepadSupports(v3, v) then
				return true
			end
		end

		return false
	end, {})

	local state, setState = React.useState(function()
		return v2()
	end)

	React.useEffect(function()
		local gamepadConnectedConnection = UserInputService.GamepadConnected:Connect(function()
			setState(v2())
		end)

		local preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			setState(v2())
		end)

		setState(v2())

		return function()
			gamepadConnectedConnection:Disconnect()
			preferredInputChangedConnection:Disconnect()
		end
	end, { v2 })

	return state
end

return useIsTvRemoteDevice
