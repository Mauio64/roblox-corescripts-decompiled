local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("RequestRefundClickThrottleHundredthsPercent", 0)

local strictInterface = t.strictInterface({ placeId = t.string })

local v5 = {
	eventName = "requestRefundClick",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 4, 24 }
}

return function(p2, value)
	if type(value) ~= "string" or value == "" then
		discoveryEventErrorLogger.reportError(
			"RequestRefundClickInvalidInterface",
			`string eventContext expected, got {type(value)} with value {tostring(value)}`
		)
	end

	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("RequestRefundClickInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = value,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
