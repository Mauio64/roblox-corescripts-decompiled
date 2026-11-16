local HoldToPlay = script:FindFirstAncestor("HoldToPlay")
local parent = HoldToPlay.Parent
local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useButtonHold = FocusNavigationUtils.useButtonHold
local Constants = require(HoldToPlay.Constants)
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum

local function useHoldToPlayStateAndCallbacks(p: number?, p2: number?)
	local v = useButtonHold(p or Constants.SIGNAL_HOLD_INTENT_SECONDS, p2 or Constants.SIGNAL_HOLD_COMPLETE_SECONDS)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)

	local onHoldableFocused = React.useCallback(function(p3, p4, p5)
		setState3(p3)
		setState2(p4)
		setState(p5)
	end, {})

	local onHoldableUnfocused = React.useCallback(function()
		setState(nil)
		setState2(nil)
		setState3(nil)
	end, {})

	local v2 = v.holdState == ButtonHoldStateEnum.HOLDING or v.holdState == ButtonHoldStateEnum.COMPLETED
	local shouldDisableHoldable = React.useCallback(function(p3: number)
		return v2 and state2 and p3 == state2
	end, { v2, state2 })

	return {
		selectedEntry = state3,
		selectedIndex = state2,
		selectedNavigationUniverseId = state,
		onHoldableFocused = onHoldableFocused,
		onHoldableUnfocused = onHoldableUnfocused,
		shouldRenderHoldToPlayLauncher = state3 ~= nil,
		shouldDisableHoldable = shouldDisableHoldable,
		holdState = v.holdState,
		holdProgress = v.holdProgress,
		cancelHold = v.cancelHold,
		holdToPlayEventHandler = v.eventHandler
	}
end

return useHoldToPlayStateAndCallbacks
