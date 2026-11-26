local TelemetryService = game:GetService("TelemetryService")

local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Analytics").getPlatformTarget

local defineFastInt = game:DefineFastInt("LuaAppSduiGameDwellThrottlingPercentage", 10000)

local v5 = {
	gameDwellStart = {
		eventName = "gameDwellStart",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 11, 3 },
		description = "Starts observed game tile dwell on opted-in SDUI collections"
	},
	gameDwellEnd = {
		eventName = "gameDwellEnd",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 11, 3 },
		description = "Ends observed game tile dwell on opted-in SDUI collections"
	}
}

return function(p2, p3, p4)
	TelemetryService:LogEvent(v5[p2], {
		eventContext = p4,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p3,
		legacyOverrideTargetForEventIngest = getPlatformTarget()
	})
end
