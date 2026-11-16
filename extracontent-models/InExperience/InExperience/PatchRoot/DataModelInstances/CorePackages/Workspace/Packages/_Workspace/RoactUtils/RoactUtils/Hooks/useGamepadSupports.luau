local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)
local doesGamepadSupportKeyCodes = require(script.Parent.doesGamepadSupportKeyCodes)

local function useGamepadSupports(p, p2)
	local v = React.useCallback(function()
		return doesGamepadSupportKeyCodes(p, UserInputService:GetLastInputType())
	end, { p, p2 })

	local state, setState = React.useState(v)

	local v2 = React.useCallback(function()
		setState(v())
	end, { v })

	useExternalEvent(UserInputService.GamepadConnected, v2)
	useExternalEvent(UserInputService.GamepadDisconnected, v2)

	React.useEffect(function()
		v2()
	end, { v2 })

	return state
end

return useGamepadSupports
