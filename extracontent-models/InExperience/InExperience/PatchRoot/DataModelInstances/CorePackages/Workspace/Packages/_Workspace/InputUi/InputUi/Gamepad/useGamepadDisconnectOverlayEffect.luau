local parent = script:FindFirstAncestor("InputUi").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useInputType = RoactUtils.Hooks.useInputType
local InputType = require(parent.InputType)
local InputTypeConstants = InputType.InputTypeConstants
local RoactUtils2 = require(parent.RoactUtils)
local useIsGamepad = RoactUtils2.Hooks.useIsGamepad
local useGamepadConnectedEvent = require(script.Parent.useGamepadConnectedEvent)

local defineFastFlag = game:DefineFastFlag("EnableGamepadHookForCorescriptGlobalEffects", false)

local function useGamepadDisconnectOverlayEffect(callback, callback2, object, value: string?)
	local v

	if defineFastFlag then
		v = useIsGamepad()
	else
		v = useInputType() == InputTypeConstants.Gamepad
	end

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
		if not v then
			return
		end

		if not ref.current then
			object:sendEventDeferred(value or "", "gamepadConnectionEvent", {
				connectionEvent = "gamepadDisconnected"
			})

			ref.current = true
			callback()
		end
	end, { v, callback })))
end

return useGamepadDisconnectOverlayEffect
