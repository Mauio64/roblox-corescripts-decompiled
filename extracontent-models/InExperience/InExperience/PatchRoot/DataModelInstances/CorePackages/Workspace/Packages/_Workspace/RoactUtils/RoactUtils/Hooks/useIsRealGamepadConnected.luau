local RoactUtils = script:FindFirstAncestor("RoactUtils")
local parent = RoactUtils.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)
local TvRemoteUtils = require(RoactUtils.TvRemoteUtils)

local function useIsRealGamepadConnected()
	local state, setState = React.useState(TvRemoteUtils.isRealGamepadConnected)

	local v = React.useCallback(function()
		setState(TvRemoteUtils.isRealGamepadConnected())
	end, {})

	useExternalEvent(UserInputService.GamepadConnected, v)
	useExternalEvent(UserInputService.GamepadDisconnected, v)

	React.useEffect(function()
		v()
	end, { v })

	return state
end

return useIsRealGamepadConnected
