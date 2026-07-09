local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local HoldToPlay = require(Parent.HoldToPlay)
local AppShortcutBarContext = require(Parent.AppShortcutBar).AppShortcutBarContext
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local useButtonHold = FocusNavigationUtils.useButtonHold
local Constants = HoldToPlay.Constants

local function GamepadJoinFocusBehavior(t1: {[any]: any}) -- line: 21
	-- upvalues: ReactFocusNavigation (copy), React (copy), useButtonHold (copy), Constants (copy), AppShortcutBarContext (copy), ButtonHoldStateEnum (copy), FocusNavigationEventNameEnum (copy)
	local v13 = ReactFocusNavigation.useFocusedGuiObject()
	local v14 = React.useRef(t1.joinExperience)

	v14.current = t1.joinExperience

	local v15 = useButtonHold(Constants.SIGNAL_HOLD_INTENT_SECONDS, Constants.SIGNAL_HOLD_COMPLETE_SECONDS)
	local v16 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v17 = AppShortcutBarContext.useDispatchButtonHoldEnded()
	local v18 = React.useRef(false)
	local v19 = v15.holdState == ButtonHoldStateEnum.HOLDING or (v15.holdState == ButtonHoldStateEnum.JUST_PRESSED or v15.holdState == ButtonHoldStateEnum.COMPLETED)

	React.useEffect(function() -- line: 39
		-- upvalues: v18 (copy), v19 (copy), v16 (copy), FocusNavigationEventNameEnum (copy), v15 (copy), v17 (copy)
		if not v18.current and v19 then
			v18.current = true
			v16(FocusNavigationEventNameEnum.HoldToJoinFriend, v15.holdProgress)

			return
		end

		if v18.current and not v19 then
			v17(FocusNavigationEventNameEnum.HoldToJoinFriend)
			v18.current = false
		end
	end, {
		v19,
		v15.holdProgress,
		v16,
		v17
	})

	local v20 = React.useRef(false)

	React.useEffect(function() -- line: 57
		-- upvalues: v15 (copy), ButtonHoldStateEnum (copy), v20 (copy), v14 (copy)
		if v15.holdState ~= ButtonHoldStateEnum.COMPLETED then
			v20.current = false

			return
		end

		if v20.current then
			return
		end

		v20.current = true
		v14.current()

		if v15.cancelHold then
			v15.cancelHold()
		end
	end, {
		v15.holdState,
		v15.cancelHold
	})

	local v21 = React.useMemo(function() -- line: 72
		-- upvalues: FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.HoldToJoinFriend
		}
	end, {})
	local v22 = React.useMemo(function() -- line: 78
		-- upvalues: FocusNavigationEventNameEnum (copy), v15 (copy)
		return {
			[FocusNavigationEventNameEnum.HoldToJoinFriend] = {
				handler = v15.eventHandler
			}
		}
	end, { v15.eventHandler })
	local v23 = ReactFocusNavigation.useEventMap(v21)
	local v24 = ReactFocusNavigation.useEventHandlerMap(v22, v23)

	React.useEffect(function() -- line: 90
		-- upvalues: v24 (copy), t1 (copy), v13 (copy)
		if not v24 then
			return
		end

		local current = t1.tileRef.current
		local v26 = if not t1.cardRef then nil else t1.cardRef.current
		local v27 = nil

		if v13 then
			local v28 = current and (current == v13 or v13:IsDescendantOf(current))
			local v29 = v26 and (v26 == v13 or v13:IsDescendantOf(v26))

			if v28 or v29 then
				v27 = v13
			end
		end

		v24(v27)

		return function() -- line: 105
			-- upvalues: v24 (copy)
			v24(nil)
		end
	end, {
		v24,
		t1.tileRef,
		t1.cardRef,
		v13
	})

	return nil
end

return GamepadJoinFocusBehavior
