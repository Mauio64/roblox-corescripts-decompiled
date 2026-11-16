local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("RequestRefundClickThrottleHundredthsPercent", 0)

local strictInterface = t.strictInterface({ placeId = t.string })

local v = {
	eventName = "requestRefundClick",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 4, 24 }
}

return function(customFields, eventContext)
	if type(eventContext) ~= "string" or eventContext == "" then
		DiscoveryEventErrorLogger.reportError(
			"RequestRefundClickInvalidInterface",
			`string eventContext expected, got {type(eventContext)} with value {tostring(eventContext)}`
		)
	end

	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("RequestRefundClickInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
