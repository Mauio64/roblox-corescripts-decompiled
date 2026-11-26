local React = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/React")
local useSelected = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/GuiObjectUtils").useSelected
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/FocusNavigationUtils")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/ReactFocusNavigation")
local appShortcutBarContext = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/AppShortcutBar").AppShortcutBarContext
local useButtonHold = FocusNavigationUtils.useButtonHold
local buttonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/HoldToPlay/HoldToPlay/Constants")

local fFlagUserSearchCancelTileActivationOnHoldIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/SharedFlags").FFlagUserSearchCancelTileActivationOnHoldIntent

local function HoldDetectorForSelectedObject(data): nil
	local state, setState = React.useState(nil)

	local state2, setState2 = React.useState(nil)
	local v5 = state or data.keyCode

	local v6 = state2 or data.focusNavigationEventName

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)

	local v7 = useButtonHold(Constants.SIGNAL_HOLD_INTENT_SECONDS, Constants.SIGNAL_HOLD_COMPLETE_SECONDS, true)
	local v8 = appShortcutBarContext.useDispatchButtonHoldStarted()
	local v9 = appShortcutBarContext.useDispatchButtonHoldEnded()

	local v10 = v7.holdState == buttonHoldStateEnum.HOLDING
		or v7.holdState == buttonHoldStateEnum.JUST_PRESSED
		or v7.holdState == buttonHoldStateEnum.COMPLETED

	local v11 = fFlagUserSearchCancelTileActivationOnHoldIntent
		and (v7.holdState == buttonHoldStateEnum.HOLDING or v7.holdState == buttonHoldStateEnum.COMPLETED)

	local v12 = fFlagUserSearchCancelTileActivationOnHoldIntent
		and data.disableRegularActionOnHoldIntent == true

	local function fn()
		if v12 then
			if data.setDisabledForHold then
				data.setDisabledForHold(v11)
			end
		elseif not v10 and data.setDisabledForHold then
			data.setDisabledForHold(false)
		end

		return function()
			if
				data.setDisabledForHold
				and not (fFlagUserSearchCancelTileActivationOnHoldIntent and v12 and v11)
			then
				data.setDisabledForHold(false)
			end
		end
	end

	React.useEffect(fn, { v10, data.setDisabledForHold, if v12 then v11 else false })

	React.useEffect(function()
		if ref.current or not v10 then
			if ref.current and not v10 then
				if v6 then
					v9(v6)
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
				v8(data.focusNavigationEventName, v7.holdProgress)
			end

			setState(data.keyCode)
			setState2(data.focusNavigationEventName)
		end
	end, {
		v10,
		v7.holdProgress,
		v8,
		v9,
		data.focusNavigationEventName,
		data.keyCode,
		v6,
		v5
	})

	local v15 = v7.holdState == buttonHoldStateEnum.COMPLETED and ref2.current == false

	React.useEffect(function()
		if v15 and data.onHoldDetected then
			ref2.current = true

			if data.setDisabledForHold and not v12 then
				data.setDisabledForHold(true)
			end

			data.onHoldDetected(data.guiObject)
		end
	end, { v15, data.onHoldDetected, data.guiObject, data.setDisabledForHold, v12 })

	local v16 = React.useMemo(function()
		if v5 and v6 then
			return { [v5] = v6 }
		end

		return {}
	end, { v5, v6 })

	local v17 = React.useMemo(function()
		if v6 then
			return {
				[v6] = { handler = v7.eventHandler }
			}
		end

		return {}
	end, { v7.eventHandler, v6 })

	local v18 = ReactFocusNavigation.useEventMap(v16)

	local v19 = ReactFocusNavigation.useEventHandlerMap(v17, v18)

	React.useEffect(function()
		if v19 then
			v19(data.guiObject)
		end

		return function()
			v19(nil)
		end
	end, { v19, data.guiObject })

	return nil
end

local function HoldDetector(p2)
	if useSelected({ current = p2.guiObject }) then
		return React.createElement(HoldDetectorForSelectedObject, p2)
	end

	return nil
end

return React.memo(HoldDetector)
