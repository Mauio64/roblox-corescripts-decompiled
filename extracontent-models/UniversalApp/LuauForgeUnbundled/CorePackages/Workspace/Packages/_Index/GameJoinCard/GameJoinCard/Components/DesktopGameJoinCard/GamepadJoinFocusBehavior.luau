local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/FocusNavigationUtils")
local HoldToPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/HoldToPlay")
local appShortcutBarContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/AppShortcutBar").AppShortcutBarContext

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local buttonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local useButtonHold = FocusNavigationUtils.useButtonHold
local constants = HoldToPlay.Constants

local function GamepadJoinFocusBehavior(data): nil
	local v5 = ReactFocusNavigation.useFocusedGuiObject()

	local ref = React.useRef(data.joinExperience)
	ref.current = data.joinExperience

	local v6 = useButtonHold(constants.SIGNAL_HOLD_INTENT_SECONDS, constants.SIGNAL_HOLD_COMPLETE_SECONDS)

	local v7 = appShortcutBarContext.useDispatchButtonHoldStarted()
	local v8 = appShortcutBarContext.useDispatchButtonHoldEnded()

	local ref2 = React.useRef(false)
	local v9 = v6.holdState == buttonHoldStateEnum.HOLDING
		or v6.holdState == buttonHoldStateEnum.JUST_PRESSED
		or v6.holdState == buttonHoldStateEnum.COMPLETED

	React.useEffect(function()
		if ref2.current or not v9 then
			if ref2.current and not v9 then
				v8(focusNavigationEventNameEnum.HoldToJoinFriend)
				ref2.current = false
			end
		else
			ref2.current = true
			v7(focusNavigationEventNameEnum.HoldToJoinFriend, v6.holdProgress)
		end
	end, { v9, v6.holdProgress, v7, v8 })

	local ref3 = React.useRef(false)
	React.useEffect(function()
		if v6.holdState ~= buttonHoldStateEnum.COMPLETED then
			ref3.current = false
			return
		end

		if ref3.current then
			return
		end

		ref3.current = true
		ref.current()

		if v6.cancelHold then
			v6.cancelHold()
		end
	end, { v6.holdState, v6.cancelHold })

	local v10 = React.useMemo(function()
		return {
			[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.HoldToJoinFriend
		}
	end, {})

	local v11 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.HoldToJoinFriend] = {
				handler = v6.eventHandler
			}
		}
	end, { v6.eventHandler })

	local v12 = ReactFocusNavigation.useEventMap(v10)

	local v13 = ReactFocusNavigation.useEventHandlerMap(v11, v12)

	React.useEffect(function()
		if not v13 then
			return
		end

		local current = data.tileRef.current
		local current2 = if data.cardRef then data.cardRef.current else nil
		local v14 = nil

		if v5 then
			local v15 = current and (v5 == current or v5:IsDescendantOf(current))
			local v16 = current2 and (v5 == current2 or v5:IsDescendantOf(current2))

			if v15 or v16 then
				v14 = v5
			end
		end

		v13(v14)
		return function()
			v13(nil)
		end
	end, { v13, data.tileRef, data.cardRef, v5 })

	return nil
end

return GamepadJoinFocusBehavior
