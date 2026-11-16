local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local v = {
	eventName = "openSearchResultsWithQueryDeeplink",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt(
		"OpenSearchResultsWithQueryDeeplinkEventThrottlingHundredthsPercent",
		10000
	),
	lastUpdated = { 26, 6, 17 },
	description = "User opened Search Results via SDUI OpenSearchResultsWithQuery"
}

local strictInterface = t.strictInterface({ kwd = t.string, searchType = t.string })

return function(eventContext: string, customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("OpenSearchResultsWithQueryDeeplinkInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end
