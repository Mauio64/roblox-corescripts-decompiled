local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Services = require(Foundation.Utility.Wrappers.Services)
local UserInputService = Services.UserInputService

require(Foundation.Enums.InputPlatform)
local detectInputPlatform = require(script.Parent.detectInputPlatform)

local function useInputPlatform()
	local state, setState = React.useState(detectInputPlatform)

	React.useEffect(function()
		local function refresh() -- 1 equivalent call inferred from this helper
			setState(detectInputPlatform())
		end

		local gamepadConnectedConnection = UserInputService.GamepadConnected:Connect(refresh)
		local gamepadDisconnectedConnection = UserInputService.GamepadDisconnected:Connect(refresh)
		refresh() -- inferred equivalent call
		return function()
			gamepadConnectedConnection:Disconnect()
			gamepadDisconnectedConnection:Disconnect()
		end
	end, {})

	return state
end

return useInputPlatform
