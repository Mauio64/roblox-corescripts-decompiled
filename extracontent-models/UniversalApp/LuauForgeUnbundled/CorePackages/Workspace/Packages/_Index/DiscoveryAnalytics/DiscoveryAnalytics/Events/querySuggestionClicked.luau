local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local v5 = {
	eventName = "querySuggestionClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt(
		"QuerySuggestionClickedEventThrottlingHundredthsPercent",
		10000
	),
	lastUpdated = { 26, 8, 13 },
	description = "User clicked a query suggestion"
}

local strictInterface = t.strictInterface({
	pos = t.optional(t.number),
	sortPos = t.optional(t.number),
	sortId = t.optional(t.string),
	queryText = t.string,
	componentType = t.string
})

return function(p2, p3)
	local v6, v7 = strictInterface(p3)

	if not v6 then
		discoveryEventErrorLogger.reportError("QuerySuggestionClickedInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p2,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p3
	})
end
