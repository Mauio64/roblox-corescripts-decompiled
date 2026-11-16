local HoldToPlay = script:FindFirstAncestor("HoldToPlay")
local parent = HoldToPlay.Parent

local React = require(parent.React)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local AppShortcutBar = require(parent.AppShortcutBar)
local AppShortcutBarContext = AppShortcutBar.AppShortcutBarContext

local HoldToPlayLoader = require(HoldToPlay.HoldToPlayLoader)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry

local function HoldToPlayLauncher(props)
	local v = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v2 = AppShortcutBarContext.useDispatchButtonHoldEnded()

	React.useEffect(function()
		if props.holdState == ButtonHoldStateEnum.JUST_PRESSED then
			v(FocusNavigationEventNameEnum.HoldToPlay, props.holdProgress)
		elseif props.holdState == ButtonHoldStateEnum.NOT_HELD then
			v2(FocusNavigationEventNameEnum.HoldToPlay)
		end
	end, { props.holdState, props.holdProgress, v, v2 })

	local reportExperienceLaunched = React.useCallback(function(p: string?)
		local reportExperienceLaunched = props.reportExperienceLaunched
		local selectedEntry = props.selectedEntry
		local referralSource = props.referralSource

		local launchContext = props.launchContext
		local selectedIndex = props.selectedIndex

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			p = nil
		end

		reportExperienceLaunched(selectedEntry, referralSource, nil, launchContext, selectedIndex, p)
	end, {
		props.reportExperienceLaunched,
		props.selectedEntry,
		props.referralSource,
		props.selectedIndex,
		props.launchContext
	})

	local universeId = props.selectedNavigationUniverseId

	if not universeId then
		if props.selectedEntry then
			universeId = props.selectedEntry.universeId or nil
		else
			universeId = nil
		end
	end

	if
		universeId
		and (props.holdState == ButtonHoldStateEnum.HOLDING or props.holdState == ButtonHoldStateEnum.COMPLETED)
	then
		return React.createElement(HoldToPlayLoader, {
			universeId = universeId,
			shouldAttemptLaunch = props.holdState == ButtonHoldStateEnum.COMPLETED,
			reportExperienceLaunched = reportExperienceLaunched,
			onLaunched = props.cancelHold
		})
	end

	return nil
end

return HoldToPlayLauncher
