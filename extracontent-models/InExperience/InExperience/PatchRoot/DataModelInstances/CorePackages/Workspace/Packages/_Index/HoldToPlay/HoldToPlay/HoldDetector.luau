local HoldToPlay = script:FindFirstAncestor("HoldToPlay")
local parent = HoldToPlay.Parent

local React = require(parent.React)
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useSelected = GuiObjectUtils.useSelected
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local AppShortcutBar = require(parent.AppShortcutBar)
local AppShortcutBarContext = AppShortcutBar.AppShortcutBarContext
local useButtonHold = FocusNavigationUtils.useButtonHold
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local Constants = require(HoldToPlay.Constants)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserSearchCancelTileActivationOnHoldIntent = SharedFlags.FFlagUserSearchCancelTileActivationOnHoldIntent

local function HoldDetectorForSelectedObject(data): nil
	local state, setState = React.useState(nil)

	local state2, setState2 = React.useState(nil)
	local v = state or data.keyCode

	local v2 = state2 or data.focusNavigationEventName

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)

	local v3 = useButtonHold(Constants.SIGNAL_HOLD_INTENT_SECONDS, Constants.SIGNAL_HOLD_COMPLETE_SECONDS, true)
	local v4 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v5 = AppShortcutBarContext.useDispatchButtonHoldEnded()

	local v6 = v3.holdState == ButtonHoldStateEnum.HOLDING
		or v3.holdState == ButtonHoldStateEnum.JUST_PRESSED
		or v3.holdState == ButtonHoldStateEnum.COMPLETED

	local v7 = FFlagUserSearchCancelTileActivationOnHoldIntent
		and (v3.holdState == ButtonHoldStateEnum.HOLDING or v3.holdState == ButtonHoldStateEnum.COMPLETED)

	local v8 = FFlagUserSearchCancelTileActivationOnHoldIntent and data.disableRegularActionOnHoldIntent == true

	local useEffect = React.useEffect
	local function fn()
		if v8 then
			if data.setDisabledForHold then
				data.setDisabledForHold(v7)
			end
		elseif not v6 and data.setDisabledForHold then
			data.setDisabledForHold(false)
		end

		return function()
			if data.setDisabledForHold and not (FFlagUserSearchCancelTileActivationOnHoldIntent and v8 and v7) then
				data.setDisabledForHold(false)
			end
		end
	end

	local setDisabledForHold = data.setDisabledForHold
	local v9 = if v8 then v7 else false
	useEffect(fn, { v6, setDisabledForHold, v9 })

	React.useEffect(function()
		if ref.current or not v6 then
			if ref.current and not v6 then
				if v2 then
					v5(v2)
				end

				setState(nil)
				setState2(nil)

				ref.current = false

				if ref2.current then
					ref2.current = false
				end
			end
		else
			ref.current = true

			if data.focusNavigationEventName then
				v4(data.focusNavigationEventName, v3.holdProgress)
			end

			setState(data.keyCode)
			setState2(data.focusNavigationEventName)
		end
	end, { v6, v3.holdProgress, v4, v5, data.focusNavigationEventName, data.keyCode, v2, v })
	local v10

	if v3.holdState == ButtonHoldStateEnum.COMPLETED then
		v10 = ref2.current == false
	else
		v10 = false
	end

	React.useEffect(function()
		if v10 and data.onHoldDetected then
			ref2.current = true

			if data.setDisabledForHold and not v8 then
				data.setDisabledForHold(true)
			end

			data.onHoldDetected(data.guiObject)
		end
	end, { v10, data.onHoldDetected, data.guiObject, data.setDisabledForHold, v8 })

	local v11 = React.useMemo(function()
		if v and v2 then
			return { [v] = v2 }
		end

		return {}
	end, { v, v2 })

	local v12 = React.useMemo(function()
		if v2 then
			return {
				[v2] = { handler = v3.eventHandler }
			}
		end

		return {}
	end, { v3.eventHandler, v2 })

	local v13 = ReactFocusNavigation.useEventMap(v11)

	local v14 = ReactFocusNavigation.useEventHandlerMap(v12, v13)

	React.useEffect(function()
		if v14 then
			v14(data.guiObject)
		end

		return function()
			v14(nil)
		end
	end, { v14, data.guiObject })

	return nil
end

local function HoldDetector(p)
	if useSelected({ current = p.guiObject }) then
		return React.createElement(HoldDetectorForSelectedObject, p)
	end

	return nil
end

return React.memo(HoldDetector)
