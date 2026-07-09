local Parent = script:FindFirstAncestor("Moments").Parent
local UserInputService = game:GetService("UserInputService")
local InputHandlers = require(Parent.InputHandlers)
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Constants = require(script.Parent.Constants)

require(script.Parent.Types)

local pagerNavigation = require(script.Parent.pagerNavigation)
local PREVIOUS_EVENT = pagerNavigation.PREVIOUS_EVENT
local NEXT_EVENT = pagerNavigation.NEXT_EVENT
local KEYBOARD_KEY_EVENTS = pagerNavigation.KEYBOARD_KEY_EVENTS

local function usePagerInputNavigation(t1: {[any]: any}) -- line: 53
	-- upvalues: React (copy), useDescendantHasFocus (copy), useAutoFocus (copy), useLastInputMode (copy), pagerNavigation (copy), PREVIOUS_EVENT (copy), InputHandlers (copy), NEXT_EVENT (copy), ReactFocusNavigation (copy), UserInputService (copy), Constants (copy), KEYBOARD_KEY_EVENTS (copy)
	local active = t1.active
	local keyboardNavigation = t1.keyboardNavigation
	local v19 = React.useRef(t1.goNext)

	v19.current = t1.goNext

	local v20 = React.useRef(t1.goPrevious)

	v20.current = t1.goPrevious

	local v21, v22 = React.useState(nil)
	local v23 = useDescendantHasFocus(v21)
	local v24 = useAutoFocus({ v21 }, 0.1)
	local v25 = useLastInputMode() == "Focus"
	local v26 = active and (v21 ~= nil and (not v23 and v25))

	React.useEffect(function() -- line: 78
		-- upvalues: v26 (copy), v24 (copy)
		local u31 = nil

		if v26 then
			u31 = v24()
		end

		return function() -- line: 83
			-- upvalues: u31 (ref)
			if u31 then
				u31.cancel()
			end
		end
	end, {
		v26,
		v24
	})

	local v27 = React.useMemo(function() -- line: 91
		-- upvalues: pagerNavigation (copy), active (copy), keyboardNavigation (copy)
		return pagerNavigation.buildEventMap(active, keyboardNavigation)
	end, {
		active,
		keyboardNavigation
	})
	local v28 = React.useMemo(function() -- line: 95
		-- upvalues: PREVIOUS_EVENT (copy), InputHandlers (copy), v20 (copy), NEXT_EVENT (copy), v19 (copy)
		return {
			[PREVIOUS_EVENT] = {
				handler = InputHandlers.onRelease(function() -- line: 98
					-- upvalues: v20 (copy)
					v20.current()
				end)
			},
			[NEXT_EVENT] = {
				handler = InputHandlers.onRelease(function() -- line: 103
					-- upvalues: v19 (copy)
					v19.current()
				end)
			}
		}
	end, {})
	local v29 = ReactFocusNavigation.useEventMap(v27)
	local v30 = ReactFocusNavigation.useEventHandlerMap(v28, v29)

	React.useEffect(function() -- line: 115
		-- upvalues: active (copy), v23 (copy), UserInputService (copy), pagerNavigation (copy), Constants (copy), v20 (copy), v19 (copy)
		if not active or not v23 then
			return
		end

		local n1 = 0
		local connection = UserInputService.InputChanged:Connect(function(input) -- line: 120
			-- upvalues: pagerNavigation (copy), Constants (copy), n1 (ref), v20 (copy), v19 (copy)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
				return
			end

			local v37 = pagerNavigation.thumbstickDirection(input.Position.Y, Constants.THUMBSTICK_THRESHOLD)

			if v37 == nil then
				return
			end

			local elapsed = os.clock()

			if elapsed - n1 < Constants.THUMBSTICK_COOLDOWN_SECONDS then
				return
			end

			n1 = elapsed

			if v37 == "previous" then
				v20.current()

				return
			end

			v19.current()
		end)

		return function() -- line: 139
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		active,
		v23
	})
	React.useEffect(function() -- line: 145
		-- upvalues: active (copy), keyboardNavigation (copy), UserInputService (copy), KEYBOARD_KEY_EVENTS (copy), PREVIOUS_EVENT (copy), v20 (copy), NEXT_EVENT (copy), v19 (copy)
		if not active or keyboardNavigation ~= "global" then
			return
		end

		local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean) -- line: 149
			-- upvalues: KEYBOARD_KEY_EVENTS (copy), PREVIOUS_EVENT (copy), v20 (copy), NEXT_EVENT (copy), v19 (copy)
			if gameProcessed then
				return
			end

			local v41 = KEYBOARD_KEY_EVENTS[input.KeyCode]

			if v41 == PREVIOUS_EVENT then
				v20.current()

				return
			end

			if v41 == NEXT_EVENT then
				v19.current()
			end
		end)

		return function() -- line: 160
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		active,
		keyboardNavigation
	})

	return React.useCallback(function(p1) -- line: 169
		-- upvalues: v30 (copy), v22 (copy)
		v30(p1)
		v22(p1)
	end, { v30 })
end

return usePagerInputNavigation
