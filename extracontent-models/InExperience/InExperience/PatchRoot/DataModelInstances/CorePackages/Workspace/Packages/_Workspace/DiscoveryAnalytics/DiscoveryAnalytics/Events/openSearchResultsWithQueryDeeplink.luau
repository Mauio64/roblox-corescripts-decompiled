local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("OpenSearchResultsWithQueryDeeplinkEventThrottlingHundredthsPercent", 10000)
local t1 = {
	eventName = "openSearchResultsWithQueryDeeplink",
	description = "User opened Search Results via SDUI OpenSearchResultsWithQuery",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		26,
		6,
		17
	}
}
local v7 = t.strictInterface({
	kwd = t.string,
	searchType = t.string
})

return function(s1: string, t2: {[any]: any}) -- line: 24
	-- upvalues: v7 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v10, v11 = v7(t2)

	if not v10 then
		DiscoveryEventErrorLogger.reportError("OpenSearchResultsWithQueryDeeplinkInvalidInterface", v11)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = t2
	})
end
