local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("RequestRefundClickThrottleHundredthsPercent", 0)
local v6 = t.strictInterface({
	placeId = t.string
})
local t1 = {
	eventName = "requestRefundClick",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		26,
		4,
		24
	}
}

return function(p1, p2) -- line: 23
	-- upvalues: DiscoveryEventErrorLogger (copy), v6 (copy), TelemetryService (copy), t1 (copy)
	if type(p2) ~= "string" or p2 == "" then
		DiscoveryEventErrorLogger.reportError("RequestRefundClickInvalidInterface", `string eventContext expected, got { type(p2) } with value { tostring(p2) }`)
	end

	local v10, v11 = v6(p1)

	if not v10 then
		DiscoveryEventErrorLogger.reportError("RequestRefundClickInvalidInterface", v11)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = p2,
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
