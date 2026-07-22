local HoldToPlay = script:FindFirstAncestor("HoldToPlay")
local HoldToPlayParent = HoldToPlay.Parent
local React = require(HoldToPlayParent.React)
local FocusNavigationUtils = require(HoldToPlayParent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local AppShortcutBarContext = require(HoldToPlayParent.AppShortcutBar).AppShortcutBarContext
local HoldToPlayLoader = require(HoldToPlay.HoldToPlayLoader)
local FFlagLuaAppDemoModePlayButtonTelemetry = require(HoldToPlayParent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry

local function HoldToPlayLauncher(t1: {[any]: any}) -- line: 38
	-- upvalues: AppShortcutBarContext (copy), React (copy), ButtonHoldStateEnum (copy), FocusNavigationEventNameEnum (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy), HoldToPlayLoader (copy)
	local v12 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v13 = AppShortcutBarContext.useDispatchButtonHoldEnded()

	React.useEffect(function() -- line: 42
		-- upvalues: t1 (copy), ButtonHoldStateEnum (copy), v12 (copy), FocusNavigationEventNameEnum (copy), v13 (copy)
		if t1.holdState == ButtonHoldStateEnum.JUST_PRESSED then
			v12(FocusNavigationEventNameEnum.HoldToPlay, t1.holdProgress)

			return
		end

		if t1.holdState == ButtonHoldStateEnum.NOT_HELD then
			v13(FocusNavigationEventNameEnum.HoldToPlay)
		end
	end, {
		t1.holdState,
		t1.holdProgress,
		v12,
		v13
	})

	local v14 = React.useCallback(function(s1: string?) -- line: 51
		-- upvalues: t1 (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
		t1.reportExperienceLaunched(t1.selectedEntry, t1.referralSource, nil, t1.launchContext, t1.selectedIndex, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1)
	end, {
		t1.reportExperienceLaunched,
		t1.selectedEntry,
		t1.referralSource,
		t1.selectedIndex,
		t1.launchContext
	})
	local v15 = t1.selectedNavigationUniverseId or (t1.selectedEntry and t1.selectedEntry.universeId or nil)

	if v15 and (t1.holdState == ButtonHoldStateEnum.HOLDING or t1.holdState == ButtonHoldStateEnum.COMPLETED) then
		return React.createElement(HoldToPlayLoader, {
			universeId = v15,
			shouldAttemptLaunch = t1.holdState == ButtonHoldStateEnum.COMPLETED,
			reportExperienceLaunched = v14,
			onLaunched = t1.cancelHold
		})
	end

	return nil
end

return HoldToPlayLauncher
