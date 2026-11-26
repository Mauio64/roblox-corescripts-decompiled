local UserInputService = game:GetService("UserInputService")

local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Types")
local pagerNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/pagerNavigation")

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
	local v5 = useDescendantHasFocus(state)

	local v6 = useAutoFocus({ state }, 0.1)

	local v7 = useLastInputMode() == "Focus"
	local v8 = if active then not (state == nil) and (not v5 and v7) else active
	React.useEffect(function()
		local v9 = if v8 then v6() else nil

		return function()
			if v9 then
				v9.cancel()
			end
		end
	end, { v8, v6 })

	local v9 = React.useMemo(function()
		return pagerNavigation.buildEventMap(active, keyboardNavigation)
	end, { active, keyboardNavigation })

	local v10 = React.useMemo(function()
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

	local v11 = ReactFocusNavigation.useEventMap(v9)
	local v12 = ReactFocusNavigation.useEventHandlerMap(v10, v11)

	React.useEffect(function()
		if active and v5 then
			local v13 = 0
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

				if now - v13 < Constants.THUMBSTICK_COOLDOWN_SECONDS then
					return
				end

				v13 = now

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
	end, { active, v5 })

	React.useEffect(function()
		if not active or keyboardNavigation ~= "global" then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			local v13 = KEYBOARD_KEY_EVENTS[input.KeyCode]

			if v13 == PREVIOUS_EVENT then
				ref2.current()
			elseif v13 == NEXT_EVENT then
				ref.current()
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { active, keyboardNavigation })

	return React.useCallback(function(p2)
		v12(p2)
		setState(p2)
	end, { v12 })
end

return usePagerInputNavigation
