local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/useExternalEvent")
local TvRemoteUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/TvRemoteUtils")

local function useIsRealGamepadConnected()
	local state, setState = React.useState(TvRemoteUtils.isRealGamepadConnected)

	local v5 = React.useCallback(function()
		setState(TvRemoteUtils.isRealGamepadConnected())
	end, {})

	useExternalEvent(UserInputService.GamepadConnected, v5)
	useExternalEvent(UserInputService.GamepadDisconnected, v5)

	React.useEffect(function()
		v5()
	end, { v5 })

	return state
end

return useIsRealGamepadConnected
