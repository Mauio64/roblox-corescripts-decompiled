local HoldToPlay = script:FindFirstAncestor("HoldToPlay")
local HoldToPlayParent = HoldToPlay.Parent
local React = require(HoldToPlayParent.React)
local FocusNavigationUtils = require(HoldToPlayParent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local AppShortcutBarContext = require(HoldToPlayParent.AppShortcutBar).AppShortcutBarContext
local HoldToPlayLoader = require(HoldToPlay.HoldToPlayLoader)

local function HoldToPlayLauncher(t1: {[any]: any}) -- line: 36
	-- upvalues: AppShortcutBarContext (copy), React (copy), ButtonHoldStateEnum (copy), FocusNavigationEventNameEnum (copy), HoldToPlayLoader (copy)
	local v11 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v12 = AppShortcutBarContext.useDispatchButtonHoldEnded()

	React.useEffect(function() -- line: 40
		-- upvalues: t1 (copy), ButtonHoldStateEnum (copy), v11 (copy), FocusNavigationEventNameEnum (copy), v12 (copy)
		if t1.holdState == ButtonHoldStateEnum.JUST_PRESSED then
			v11(FocusNavigationEventNameEnum.HoldToPlay, t1.holdProgress)

			return
		end

		if t1.holdState == ButtonHoldStateEnum.NOT_HELD then
			v12(FocusNavigationEventNameEnum.HoldToPlay)
		end
	end, {
		t1.holdState,
		t1.holdProgress,
		v11,
		v12
	})

	local v13 = React.useCallback(function() -- line: 49
		-- upvalues: t1 (copy)
		t1.reportExperienceLaunched(t1.selectedEntry, t1.referralSource, nil, t1.launchContext, t1.selectedIndex)
	end, {
		t1.reportExperienceLaunched,
		t1.selectedEntry,
		t1.referralSource,
		t1.selectedIndex,
		t1.launchContext
	})
	local v14 = t1.selectedNavigationUniverseId or (t1.selectedEntry and t1.selectedEntry.universeId or nil)

	if v14 and (t1.holdState == ButtonHoldStateEnum.HOLDING or t1.holdState == ButtonHoldStateEnum.COMPLETED) then
		return React.createElement(HoldToPlayLoader, {
			universeId = v14,
			shouldAttemptLaunch = t1.holdState == ButtonHoldStateEnum.COMPLETED,
			reportExperienceLaunched = v13,
			onLaunched = t1.cancelHold
		})
	end

	return nil
end

return HoldToPlayLauncher
