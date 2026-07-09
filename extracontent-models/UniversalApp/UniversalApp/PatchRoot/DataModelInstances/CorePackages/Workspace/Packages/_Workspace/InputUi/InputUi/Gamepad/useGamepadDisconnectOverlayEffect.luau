local Parent = script:FindFirstAncestor("InputUi").Parent
local React = require(Parent.React)
local useInputType = require(Parent.RoactUtils).Hooks.useInputType
local InputTypeConstants = require(Parent.InputType).InputTypeConstants
local useIsGamepad = require(Parent.RoactUtils).Hooks.useIsGamepad
local useGamepadConnectedEvent = require(script.Parent.useGamepadConnectedEvent)
local v7 = game:DefineFastFlag("EnableGamepadHookForCorescriptGlobalEffects", false)

local function useGamepadDisconnectOverlayEffect(p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3, s1: string?) -- line: 11
	-- upvalues: v7 (copy), useIsGamepad (copy), useInputType (copy), InputTypeConstants (copy), React (copy), useGamepadConnectedEvent (copy)
	local u13 = if not v7 then useInputType() == InputTypeConstants.Gamepad else useIsGamepad()
	local v14 = React.useRef(false)
	local v15 = React.useCallback(function() -- line: 26
		-- upvalues: v14 (copy), p3 (copy), s1 (copy), p2 (copy)
		if v14.current then
			local t1 = {
				connectionEvent = "gamepadReconnected"
			}

			p3:sendEventDeferred(s1 or "", "gamepadConnectionEvent", t1)
			v14.current = false
			p2()
		end
	end, { p2 })
	local v16 = React.useCallback(function() -- line: 38
		-- upvalues: u13 (ref), v14 (copy), p3 (copy), s1 (copy), p1 (copy)
		if not u13 then
			return
		end

		if not v14.current then
			local t2 = {
				connectionEvent = "gamepadDisconnected"
			}

			p3:sendEventDeferred(s1 or "", "gamepadConnectionEvent", t2)
			v14.current = true
			p1()
		end
	end, {
		u13,
		p1
	})

	useGamepadConnectedEvent(v15, v16)
end

return useGamepadDisconnectOverlayEffect
