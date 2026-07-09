local HoldToPlay = script:FindFirstAncestor("HoldToPlay")
local HoldToPlayParent = HoldToPlay.Parent
local React = require(HoldToPlayParent.React)
local useSelected = require(HoldToPlayParent.GuiObjectUtils).useSelected
local FocusNavigationUtils = require(HoldToPlayParent.FocusNavigationUtils)
local ReactFocusNavigation = require(HoldToPlayParent.ReactFocusNavigation)
local AppShortcutBarContext = require(HoldToPlayParent.AppShortcutBar).AppShortcutBarContext
local useButtonHold = FocusNavigationUtils.useButtonHold
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local Constants = require(HoldToPlay.Constants)

local function HoldDetectorForSelectedObject(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), useButtonHold (copy), Constants (copy), AppShortcutBarContext (copy), ButtonHoldStateEnum (copy), ReactFocusNavigation (copy)
	local v14, v15 = React.useState(nil)
	local v16, v17 = React.useState(nil)
	local v18 = v14 or t1.keyCode
	local v19 = v16 or t1.focusNavigationEventName
	local v20 = React.useRef(false)
	local v21 = React.useRef(false)
	local v22 = useButtonHold(Constants.SIGNAL_HOLD_INTENT_SECONDS, Constants.SIGNAL_HOLD_COMPLETE_SECONDS, true)
	local v23 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v24 = AppShortcutBarContext.useDispatchButtonHoldEnded()
	local v25 = v22.holdState == ButtonHoldStateEnum.HOLDING or (v22.holdState == ButtonHoldStateEnum.JUST_PRESSED or v22.holdState == ButtonHoldStateEnum.COMPLETED)

	React.useEffect(function() -- line: 55
		-- upvalues: v25 (copy), t1 (copy)
		if not v25 and t1.setDisabledForHold then
			t1.setDisabledForHold(false)
		end

		return function() -- line: 61
			-- upvalues: t1 (copy)
			if t1.setDisabledForHold then
				t1.setDisabledForHold(false)
			end
		end
	end, {
		v25,
		t1.setDisabledForHold
	})
	React.useEffect(function() -- line: 75
		-- upvalues: v20 (copy), v25 (copy), t1 (copy), v23 (copy), v22 (copy), v15 (copy), v17 (copy), v19 (copy), v24 (copy), v21 (copy)
		if not v20.current and v25 then
			v20.current = true

			if t1.focusNavigationEventName then
				v23(t1.focusNavigationEventName, v22.holdProgress)
			end

			v15(t1.keyCode)
			v17(t1.focusNavigationEventName)

			return
		end

		if v20.current and not v25 then
			if v19 then
				v24(v19)
			end

			v15(nil)
			v17(nil)
			v20.current = false

			if v21.current then
				v21.current = false
			end
		end
	end, {
		v25,
		v22.holdProgress,
		v23,
		v24,
		t1.focusNavigationEventName,
		t1.keyCode,
		v19,
		v18
	})

	local v26 = v22.holdState == ButtonHoldStateEnum.COMPLETED and v21.current == false

	React.useEffect(function() -- line: 113
		-- upvalues: v26 (copy), t1 (copy), v21 (copy)
		if v26 and t1.onHoldDetected then
			v21.current = true

			if t1.setDisabledForHold then
				t1.setDisabledForHold(true)
			end

			t1.onHoldDetected(t1.guiObject)
		end
	end, {
		v26,
		t1.onHoldDetected,
		t1.guiObject,
		t1.setDisabledForHold
	})

	local v27 = React.useMemo(function() -- line: 133
		-- upvalues: v18 (copy), v19 (copy)
		if v18 and v19 then
			return {
				[v18] = v19
			}
		end

		return {}
	end, {
		v18,
		v19
	})
	local v28 = React.useMemo(function() -- line: 143
		-- upvalues: v19 (copy), v22 (copy)
		if v19 then
			return {
				[v19] = {
					handler = v22.eventHandler
				}
			}
		end

		return {}
	end, {
		v22.eventHandler,
		v19
	})
	local v29 = ReactFocusNavigation.useEventMap(v27)
	local v30 = ReactFocusNavigation.useEventHandlerMap(v28, v29)

	React.useEffect(function() -- line: 159
		-- upvalues: v30 (copy), t1 (copy)
		if v30 then
			v30(t1.guiObject)
		end

		return function() -- line: 163
			-- upvalues: v30 (copy)
			v30(nil)
		end
	end, {
		v30,
		t1.guiObject
	})

	return nil
end
local function HoldDetector(t2: {[any]: any}) -- line: 171
	-- upvalues: useSelected (copy), React (copy), HoldDetectorForSelectedObject (copy)
	if useSelected({
		current = t2.guiObject
	}) then
		return React.createElement(HoldDetectorForSelectedObject, t2)
	end

	return nil
end

return React.memo(HoldDetector)
