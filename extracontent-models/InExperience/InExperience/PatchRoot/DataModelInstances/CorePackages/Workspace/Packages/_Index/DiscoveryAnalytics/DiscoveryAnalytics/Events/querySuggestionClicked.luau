local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local v = {
	eventName = "querySuggestionClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("QuerySuggestionClickedEventThrottlingHundredthsPercent", 10000),
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

return function(eventContext: string, customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("QuerySuggestionClickedInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end
