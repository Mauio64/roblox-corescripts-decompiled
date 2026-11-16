local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)
local Signals = require(parent2.Signals)
local Foundation = require(parent2.Foundation)

local View = Foundation.View

local LeaderboardTabsBody = require(parent.Components.Presentation.LeaderboardTabsBody)
local usePlatformLeaderboard = require(parent.Hooks.usePlatformLeaderboard)
local FallbackSignals = require(parent.Common.FallbackSignals)
local FFlagPlayerListReskin = require(parent.Flags.FFlagPlayerListReskin)

local leaderboardViewChangeTelemetry = nil
local function getLeaderboardViewChangeTelemetry() -- 2 equivalent calls inferred from this helper
	if leaderboardViewChangeTelemetry == nil then
		local LeaderboardViewChangeTelemetry = require(parent.Common.LeaderboardViewChangeTelemetry)
		leaderboardViewChangeTelemetry = LeaderboardViewChangeTelemetry
	end

	return leaderboardViewChangeTelemetry
end

local function TabbedLeaderboardBody(props)
	local state, setState = React.useState("server")
	local onActivated

	if FFlagPlayerListReskin then
		local v = usePlatformLeaderboard()
		local getHasActiveLeaderboard

		if v == nil then
			getHasActiveLeaderboard = FallbackSignals.getHasActiveLeaderboard
		else
			getHasActiveLeaderboard = v.getHasActiveLeaderboard
		end

		React.useEffect(function()
			return Signals.createEffect(function(p)
				local hasActiveLeaderboard = getHasActiveLeaderboard(p)
				local setCurrentTab = getLeaderboardViewChangeTelemetry().setCurrentTab -- inferred equivalent call
				local v2

				if hasActiveLeaderboard then
					v2 = state
				end

				setCurrentTab(v2)
			end)
		end, { state, getHasActiveLeaderboard })

		React.useEffect(function()
			return function()
				if leaderboardViewChangeTelemetry == nil then
					local LeaderboardViewChangeTelemetry = require(parent.Common.LeaderboardViewChangeTelemetry)
					leaderboardViewChangeTelemetry = LeaderboardViewChangeTelemetry
				end

				leaderboardViewChangeTelemetry.clearCurrentTab()
			end
		end, {})

		onActivated = React.useCallback(function(p: string)
			if p ~= state then
				getLeaderboardViewChangeTelemetry().logSwitchTab(p) -- inferred equivalent call
			end

			setState(p)
		end, { state })
	else
		onActivated = setState
	end

	local onPlatformTabsUnavailable = React.useCallback(function()
		setState("server")
	end, {})

	local joined = {
		Header = props.panelHeader,
		HeaderDivider = props.panelDivider,
		LeaderboardTabsBody = React.createElement(LeaderboardTabsBody, {
			activeTabId = state,
			onActivated = onActivated,
			onPlatformTabsUnavailable = onPlatformTabsUnavailable,
			serverBody = props.serverBody
		})
	}

	if props.children then
		joined = Cryo.Dictionary.join(joined, props.children)
	end

	return React.createElement(View, props.panelProps, joined)
end

return React.memo(TabbedLeaderboardBody)
