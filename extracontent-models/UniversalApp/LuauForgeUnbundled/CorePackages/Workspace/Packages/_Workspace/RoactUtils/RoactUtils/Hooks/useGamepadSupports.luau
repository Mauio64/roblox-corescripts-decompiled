local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/useExternalEvent")
local doesGamepadSupportKeyCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/doesGamepadSupportKeyCodes")

local function useGamepadSupports(p2, p3)
	local v5 = React.useCallback(function()
		return doesGamepadSupportKeyCodes(p2, UserInputService:GetLastInputType())
	end, { p2, p3 })

	local state, setState = React.useState(v5)

	local v6 = React.useCallback(function()
		setState(v5())
	end, { v5 })

	useExternalEvent(UserInputService.GamepadConnected, v6)
	useExternalEvent(UserInputService.GamepadDisconnected, v6)

	React.useEffect(function()
		v6()
	end, { v6 })

	return state
end

return useGamepadSupports
