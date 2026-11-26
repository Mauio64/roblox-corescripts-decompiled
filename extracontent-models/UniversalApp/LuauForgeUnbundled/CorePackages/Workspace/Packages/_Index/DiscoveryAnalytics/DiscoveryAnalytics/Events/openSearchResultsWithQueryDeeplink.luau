local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local v5 = {
	eventName = "openSearchResultsWithQueryDeeplink",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt(
		"OpenSearchResultsWithQueryDeeplinkEventThrottlingHundredthsPercent",
		10000
	),
	lastUpdated = { 26, 6, 17 },
	description = "User opened Search Results via SDUI OpenSearchResultsWithQuery"
}

local strictInterface = t.strictInterface({
	kwd = t.string,
	searchType = t.string
})

return function(p2, p3)
	local v6, v7 = strictInterface(p3)

	if not v6 then
		discoveryEventErrorLogger.reportError("OpenSearchResultsWithQueryDeeplinkInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p2,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p3
	})
end
