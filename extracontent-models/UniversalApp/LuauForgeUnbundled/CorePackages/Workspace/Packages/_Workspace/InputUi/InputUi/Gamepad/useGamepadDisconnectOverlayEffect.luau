local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/React")
local useInputType = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/RoactUtils").Hooks.useInputType
local inputTypeConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputType").InputTypeConstants
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/RoactUtils").Hooks.useIsGamepad
local useGamepadConnectedEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/useGamepadConnectedEvent")

local defineFastFlag = game:DefineFastFlag("EnableGamepadHookForCorescriptGlobalEffects", false)

local function useGamepadDisconnectOverlayEffect(callback, callback2, object, value)
	local v5 = if defineFastFlag then useIsGamepad() else useInputType() == inputTypeConstants.Gamepad

	local ref = React.useRef(false)

	useGamepadConnectedEvent(React.useCallback(function()
		if ref.current then
			object:sendEventDeferred(value or "", "gamepadConnectionEvent", {
				connectionEvent = "gamepadReconnected"
			})

			ref.current = false
			callback2()
		end
	end, { callback2 }), (React.useCallback(function()
		if not v5 then
			return
		end

		if not ref.current then
			object:sendEventDeferred(value or "", "gamepadConnectionEvent", {
				connectionEvent = "gamepadDisconnected"
			})

			ref.current = true
			callback()
		end
	end, { v5, callback })))
end

return useGamepadDisconnectOverlayEffect
