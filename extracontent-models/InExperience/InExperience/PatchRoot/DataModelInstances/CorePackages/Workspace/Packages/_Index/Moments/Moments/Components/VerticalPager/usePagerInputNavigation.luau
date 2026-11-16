local parent = script:FindFirstAncestor("Moments").Parent

local UserInputService = game:GetService("UserInputService")

local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local Constants = require(script.Parent.Constants)
require(script.Parent.Types)
local pagerNavigation = require(script.Parent.pagerNavigation)

local PREVIOUS_EVENT = pagerNavigation.PREVIOUS_EVENT
local NEXT_EVENT = pagerNavigation.NEXT_EVENT
local KEYBOARD_KEY_EVENTS = pagerNavigation.KEYBOARD_KEY_EVENTS

local function usePagerInputNavigation(data)
	local active = data.active
	local keyboardNavigation = data.keyboardNavigation

	local ref = React.useRef(data.goNext)
	ref.current = data.goNext
	local ref2 = React.useRef(data.goPrevious)
	ref2.current = data.goPrevious

	local state, setState = React.useState(nil)
	local v = useDescendantHasFocus(state)

	local v2 = useAutoFocus({ state }, 0.1)

	local v3 = useLastInputMode() == "Focus"
	local v4

	if active then
		if state == nil then
			v4 = false
		else
			v4 = not v and v3
		end
	else
		v4 = active
	end

	React.useEffect(function()
		local v5

		if v4 then
			v5 = v2()
		else
			v5 = nil
		end

		return function()
			if v5 then
				v5.cancel()
			end
		end
	end, { v4, v2 })

	local v5 = React.useMemo(function()
		return pagerNavigation.buildEventMap(active, keyboardNavigation)
	end, { active, keyboardNavigation })

	local v6 = React.useMemo(function()
		return {
			[PREVIOUS_EVENT] = {
				handler = InputHandlers.onRelease(function()
					ref2.current()
				end)
			},
			[NEXT_EVENT] = {
				handler = InputHandlers.onRelease(function()
					ref.current()
				end)
			}
		}
	end, {})

	local v7 = ReactFocusNavigation.useEventMap(v5)
	local v8 = ReactFocusNavigation.useEventHandlerMap(v6, v7)

	React.useEffect(function()
		if active and v then
			local v9 = 0
			local inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
				if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
					return
				end

				local thumbstickDirection = pagerNavigation.thumbstickDirection(
					input.Position.Y,
					Constants.THUMBSTICK_THRESHOLD
				)

				if thumbstickDirection == nil then
					return
				end

				local now = os.clock()

				if now - v9 < Constants.THUMBSTICK_COOLDOWN_SECONDS then
					return
				end

				v9 = now

				if thumbstickDirection == "previous" then
					ref2.current()
				else
					ref.current()
				end
			end)
			return function()
				inputChangedConnection:Disconnect()
			end
		end
	end, { active, v })

	React.useEffect(function()
		if not active or keyboardNavigation ~= "global" then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean)
			if gameProcessed then
				return
			end

			local v9 = KEYBOARD_KEY_EVENTS[input.KeyCode]

			if v9 == PREVIOUS_EVENT then
				ref2.current()
			elseif v9 == NEXT_EVENT then
				ref.current()
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { active, keyboardNavigation })

	return React.useCallback(function(p)
		v8(p)
		setState(p)
	end, { v8 })
end

return usePagerInputNavigation
