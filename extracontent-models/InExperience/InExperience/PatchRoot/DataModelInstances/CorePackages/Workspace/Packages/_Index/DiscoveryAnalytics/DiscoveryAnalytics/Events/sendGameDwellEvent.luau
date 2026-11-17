local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget

local defineFastInt = game:DefineFastInt("LuaAppSduiGameDwellThrottlingPercentage", 10000)

local v = {
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

return function(p: string, customFields, eventContext: string)
	TelemetryService:LogEvent(v[p], {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields,
		legacyOverrideTargetForEventIngest = getPlatformTarget()
	})
end
