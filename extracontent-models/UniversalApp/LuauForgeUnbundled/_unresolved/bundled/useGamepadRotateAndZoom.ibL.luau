local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/ibe")
local gamepadUtils = require("@luauforge/bundled/ibM").Gamepad.GamepadUtils

local module2 = require("@luauforge/bundled/ibx")

local function useGamepadRotateAndZoom(p2)
	local v5 = module2().useSceneInteractionCallbacks()

	local setAngularVelocityByPixels = v5.setAngularVelocityByPixels
	local rotateByRadians = v5.rotateByRadians
	local zoomStraight = v5.zoomStraight
	local runService = p2 and p2.runService or RunService
	local userInputService = p2 and p2.userInputService or UserInputService

	module.useEffect(function()
		local v6 = nil

		local function rotateHeldStick(p3)
			if v6 == nil then
				return
			end

			gamepadUtils.rotateAndZoom(v6, p3, setAngularVelocityByPixels, rotateByRadians, zoomStraight)
		end

		local heartbeatConnection = nil

		local function disconnectHeartbeat()
			if heartbeatConnection == nil then
				return
			end

			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
		end

		local function connectHeartbeatWhileHeld()
			if heartbeatConnection ~= nil then
				return
			end

			heartbeatConnection = runService.Heartbeat:Connect(rotateHeldStick)
		end

		local function releaseThumbstick()
			v6 = nil

			if heartbeatConnection == nil then
				return
			end

			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
		end

		local inputChangedConnection = userInputService.InputChanged:Connect(function(input)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			if input.UserInputState == Enum.UserInputState.Change then
				v6 = input

				if heartbeatConnection ~= nil then
					return
				end

				heartbeatConnection = runService.Heartbeat:Connect(rotateHeldStick)
			end
		end)

		local inputEndedConnection = userInputService.InputEnded:Connect(function(input)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			v6 = nil

			if heartbeatConnection == nil then
				return
			end

			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
		end)

		return function()
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end

			inputChangedConnection:Disconnect()
			inputEndedConnection:Disconnect()
		end
	end, {
		setAngularVelocityByPixels,
		rotateByRadians,
		zoomStraight,
		runService,
		userInputService
	})
end

return useGamepadRotateAndZoom
