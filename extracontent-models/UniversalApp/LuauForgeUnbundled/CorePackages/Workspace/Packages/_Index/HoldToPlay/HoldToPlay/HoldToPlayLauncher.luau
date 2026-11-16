local React = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/React")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/FocusNavigationUtils")
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local buttonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local appShortcutBarContext = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/AppShortcutBar").AppShortcutBarContext

local HoldToPlayLoader = require("@game/CorePackages/Workspace/Packages/_Index/HoldToPlay/HoldToPlay/HoldToPlayLoader")
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry

local function HoldToPlayLauncher(props)
	local v5 = appShortcutBarContext.useDispatchButtonHoldStarted()
	local v6 = appShortcutBarContext.useDispatchButtonHoldEnded()

	React.useEffect(function()
		if props.holdState == buttonHoldStateEnum.JUST_PRESSED then
			v5(focusNavigationEventNameEnum.HoldToPlay, props.holdProgress)
		elseif props.holdState == buttonHoldStateEnum.NOT_HELD then
			v6(focusNavigationEventNameEnum.HoldToPlay)
		end
	end, { props.holdState, props.holdProgress, v5, v6 })

	local v7 = React.useCallback(function(p2)
		local reportExperienceLaunched = props.reportExperienceLaunched
		local selectedEntry = props.selectedEntry
		local referralSource = props.referralSource

		local launchContext = props.launchContext
		local selectedIndex = props.selectedIndex

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			p2 = nil
		end

		reportExperienceLaunched(selectedEntry, referralSource, nil, launchContext, selectedIndex, p2)
	end, {
		props.reportExperienceLaunched,
		props.selectedEntry,
		props.referralSource,
		props.selectedIndex,
		props.launchContext
	})

	local v8 = props.selectedNavigationUniverseId

	if not v8 then
		v8 = if props.selectedEntry then props.selectedEntry.universeId or nil else nil
	end

	if
		v8
		and (props.holdState == buttonHoldStateEnum.HOLDING or props.holdState == buttonHoldStateEnum.COMPLETED)
	then
		return React.createElement(HoldToPlayLoader, {
			universeId = v8,
			shouldAttemptLaunch = props.holdState == buttonHoldStateEnum.COMPLETED,
			reportExperienceLaunched = v7,
			onLaunched = props.cancelHold
		})
	end

	return nil
end

return HoldToPlayLauncher
