local HoldToPlay = script:FindFirstAncestor("HoldToPlay")
local HoldToPlayParent = HoldToPlay.Parent
local React = require(HoldToPlayParent.React)
local FocusNavigationUtils = require(HoldToPlayParent.FocusNavigationUtils)
local useButtonHold = FocusNavigationUtils.useButtonHold
local Constants = require(HoldToPlay.Constants)
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum

local function useHoldToPlayStateAndCallbacks(n1: number?, n2: number?) -- line: 13
	-- upvalues: useButtonHold (copy), Constants (copy), React (copy), ButtonHoldStateEnum (copy)
	local v11 = useButtonHold(n1 or Constants.SIGNAL_HOLD_INTENT_SECONDS, n2 or Constants.SIGNAL_HOLD_COMPLETE_SECONDS)
	local v12, v13 = React.useState(nil)
	local v14, v15 = React.useState(nil)
	local v16, v17 = React.useState(nil)
	local v18 = React.useCallback(function(p1, p2, p3) -- line: 24
		-- upvalues: v17 (copy), v15 (copy), v13 (copy)
		v17(p1)
		v15(p2)
		v13(p3)
	end, {})
	local v19 = React.useCallback(function() -- line: 30
		-- upvalues: v13 (copy), v15 (copy), v17 (copy)
		v13(nil)
		v15(nil)
		v17(nil)
	end, {})
	local v20 = v11.holdState == ButtonHoldStateEnum.HOLDING or v11.holdState == ButtonHoldStateEnum.COMPLETED
	local v21 = React.useCallback(function(n3: number) -- line: 38
		-- upvalues: v20 (copy), v14 (copy)
		return v20 and (v14 and n3 == v14)
	end, {
		v20,
		v14
	})
	local v22 = v16 ~= nil

	return {
		selectedEntry = v16,
		selectedIndex = v14,
		selectedNavigationUniverseId = v12,
		onHoldableFocused = v18,
		onHoldableUnfocused = v19,
		shouldRenderHoldToPlayLauncher = v22,
		shouldDisableHoldable = v21,
		holdState = v11.holdState,
		holdProgress = v11.holdProgress,
		cancelHold = v11.cancelHold,
		holdToPlayEventHandler = v11.eventHandler
	}
end

return useHoldToPlayStateAndCallbacks
