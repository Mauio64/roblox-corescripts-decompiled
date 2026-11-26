local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("TopBarToggledThrottleHundredthsPercent", 0)

local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

local v5 = {
	eventName = "topbar_toggled",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 6, 10 },
	description = "Event fired every time TopBar is toggled open/close in UI-less mode",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/6270"
}

return function(p2)
	local v6, v7

	if engineFeature then
		v6 = { is_toggled_on = tostring(p2) }
		v7 = { "addPlaceId", "addUniverseId", "addPlaySessionId", "addSessionInfo" }
	else
		v6 = {
			is_toggled_on = tostring(p2),
			playsessionid = RbxAnalyticsService:GetPlaySessionId()
		}
		v7 = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	end

	TelemetryService:LogEvent(v5, { standardizedFields = v7, customFields = v6 })
end
