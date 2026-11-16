local v = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("PlayerListReskinViewChangeTelemetryThrottleHundredthsPercent", 10000)

local lastUpdated = { 2026, 8, 13 }

local v2 = {
	eventName = "coreui_playerlist_leaderboard_view_change",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = lastUpdated,
	description = "Fired when the leaderboard is shown, hidden, the user switches tabs, a Friends/Global tab fails to load, or the user retries after a load error."
}

local v3 = {
	eventName = "coreui_playerlist_leaderboard_view_change",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = lastUpdated,
	description = "Counter for leaderboard show / hide / tab-switch / load-error / retry-error view changes."
}

local v4 = nil
local v5 = false
local flag = false

local function log(action: string, tab: string?)
	local customFields = { action = action }

	if tab ~= nil then
		customFields.tab = tab
	end

	local v6 = {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addSessionInfo",
			"addSessionId",
			"addPlaySessionId"
		},
		customFields = customFields
	}
	v:LogEvent(v2, v6)
	v:LogCounter(v3, v6, 1)
end

local LeaderboardViewChangeTelemetry = {}

function LeaderboardViewChangeTelemetry.logSwitchTab(tab: string)
	v4 = tab
	v5 = true
	log("switch_tab", tab)
end

function LeaderboardViewChangeTelemetry.logVisibility(flag2: boolean, flag3: boolean?)
	if flag2 and flag3 and not v5 then
		flag = true
		return
	end

	flag = false
	log(flag2 and "show_leaderboard" or "hide_leaderboard", v4)
end

function LeaderboardViewChangeTelemetry.logLoadError(tab: string)
	log("load_error", tab)
end

function LeaderboardViewChangeTelemetry.logRetryError(tab: string)
	log("retry_error", tab)
end

function LeaderboardViewChangeTelemetry.setCurrentTab(p: string?)
	v4 = p
	v5 = true

	if flag then
		flag = false
		log("show_leaderboard", v4)
	end
end

function LeaderboardViewChangeTelemetry.clearCurrentTab()
	v4 = nil
	v5 = false
end

function LeaderboardViewChangeTelemetry._setServicesForTesting(p)
	v = p
	v4 = nil
	v5 = false
	flag = false
end

return LeaderboardViewChangeTelemetry
