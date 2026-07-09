local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local v3 = game:DefineFastInt("TopBarToggledThrottleHundredthsPercent", 0)
local EngineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local t1 = {
	eventName = "topbar_toggled",
	description = "Event fired every time TopBar is toggled open/close in UI-less mode",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/6270",
	backends = { "EventIngest" },
	throttlingPercentage = v3,
	lastUpdated = {
		25,
		6,
		10
	}
}

return function(b1: boolean) -- line: 22
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy), TelemetryService (copy), t1 (copy)
	local t2, t3

	if EngineFeature then
		t2 = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId",
			"addSessionInfo"
		}
		t3 = {
			is_toggled_on = tostring(b1)
		}
	else
		t2 = {
			"addPlaceId",
			"addUniverseId",
			"addSessionInfo"
		}
		t3 = {
			is_toggled_on = tostring(b1),
			playsessionid = RbxAnalyticsService:GetPlaySessionId()
		}
	end

	TelemetryService:LogEvent(t1, {
		standardizedFields = t2,
		customFields = t3
	})
end
