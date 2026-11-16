local React = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/FocusNavigationUtils")
local useButtonHold = FocusNavigationUtils.useButtonHold
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/HoldToPlay/HoldToPlay/Constants")
local buttonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum

local function useHoldToPlayStateAndCallbacks(p2, p3)
	local v5 = useButtonHold(
		p2 or Constants.SIGNAL_HOLD_INTENT_SECONDS,
		p3 or Constants.SIGNAL_HOLD_COMPLETE_SECONDS
	)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)

	local v6 = React.useCallback(function(p4, p5, p6)
		setState3(p4)
		setState2(p5)
		setState(p6)
	end, {})

	local v7 = React.useCallback(function()
		setState(nil)
		setState2(nil)
		setState3(nil)
	end, {})

	local v8 = v5.holdState == buttonHoldStateEnum.HOLDING or v5.holdState == buttonHoldStateEnum.COMPLETED
	local v9 = React.useCallback(function(p4)
		return v8 and state2 and p4 == state2
	end, { v8, state2 })

	return {
		selectedEntry = state3,
		selectedIndex = state2,
		selectedNavigationUniverseId = state,
		onHoldableFocused = v6,
		onHoldableUnfocused = v7,
		shouldRenderHoldToPlayLauncher = state3 ~= nil,
		shouldDisableHoldable = v9,
		holdState = v5.holdState,
		holdProgress = v5.holdProgress,
		cancelHold = v5.cancelHold,
		holdToPlayEventHandler = v5.eventHandler
	}
end

return useHoldToPlayStateAndCallbacks
