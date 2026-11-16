local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("TopBarToggledThrottleHundredthsPercent", 0)

local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

local v = {
	eventName = "topbar_toggled",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 6, 10 },
	description = "Event fired every time TopBar is toggled open/close in UI-less mode",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/6270"
}

return function(flag: boolean)
	local customFields, standardizedFields

	if engineFeature then
		customFields = { is_toggled_on = tostring(flag) }
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId", "addSessionInfo" }
	else
		customFields = {
			is_toggled_on = tostring(flag),
			playsessionid = RbxAnalyticsService:GetPlaySessionId()
		}
		standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end
