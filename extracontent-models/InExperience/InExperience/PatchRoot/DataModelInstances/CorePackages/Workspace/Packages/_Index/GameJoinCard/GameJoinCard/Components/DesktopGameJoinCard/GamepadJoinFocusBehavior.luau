local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local HoldToPlay = require(parent.HoldToPlay)
local AppShortcutBar = require(parent.AppShortcutBar)
local AppShortcutBarContext = AppShortcutBar.AppShortcutBarContext

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local useButtonHold = FocusNavigationUtils.useButtonHold
local Constants = HoldToPlay.Constants

local function GamepadJoinFocusBehavior(data): nil
	local v = ReactFocusNavigation.useFocusedGuiObject()

	local ref = React.useRef(data.joinExperience)
	ref.current = data.joinExperience

	local v2 = useButtonHold(Constants.SIGNAL_HOLD_INTENT_SECONDS, Constants.SIGNAL_HOLD_COMPLETE_SECONDS)

	local v3 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v4 = AppShortcutBarContext.useDispatchButtonHoldEnded()

	local ref2 = React.useRef(false)
	local v5 = v2.holdState == ButtonHoldStateEnum.HOLDING
		or v2.holdState == ButtonHoldStateEnum.JUST_PRESSED
		or v2.holdState == ButtonHoldStateEnum.COMPLETED

	React.useEffect(function()
		if ref2.current or not v5 then
			if ref2.current and not v5 then
				v4(FocusNavigationEventNameEnum.HoldToJoinFriend)
				ref2.current = false
			end
		else
			ref2.current = true
			v3(FocusNavigationEventNameEnum.HoldToJoinFriend, v2.holdProgress)
		end
	end, { v5, v2.holdProgress, v3, v4 })

	local ref3 = React.useRef(false)
	React.useEffect(function()
		if v2.holdState ~= ButtonHoldStateEnum.COMPLETED then
			ref3.current = false
			return
		end

		if ref3.current then
			return
		end

		ref3.current = true
		ref.current()

		if v2.cancelHold then
			v2.cancelHold()
		end
	end, { v2.holdState, v2.cancelHold })

	local v6 = React.useMemo(function()
		return { [Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.HoldToJoinFriend }
	end, {})

	local v7 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.HoldToJoinFriend] = { handler = v2.eventHandler }
		}
	end, { v2.eventHandler })

	local v8 = ReactFocusNavigation.useEventMap(v6)

	local v9 = ReactFocusNavigation.useEventHandlerMap(v7, v8)

	React.useEffect(function()
		if not v9 then
			return
		end

		local current = data.tileRef.current
		local current2

		if data.cardRef then
			current2 = data.cardRef.current
		end

		local v10 = nil

		if v then
			local v11 = current and (v == current or v:IsDescendantOf(current))
			local v12 = current2 and (v == current2 or v:IsDescendantOf(current2))

			if v11 or v12 then
				v10 = v
			end
		end

		v9(v10)
		return function()
			v9(nil)
		end
	end, { v9, data.tileRef, data.cardRef, v })

	return nil
end

return GamepadJoinFocusBehavior
