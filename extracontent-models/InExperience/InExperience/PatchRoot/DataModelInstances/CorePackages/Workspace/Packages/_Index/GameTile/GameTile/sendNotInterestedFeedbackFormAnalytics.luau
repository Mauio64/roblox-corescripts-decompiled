local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("GameTile").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("NotInterestedFeedbackFormActionThrottleHundredthsPercent", 0)

local strictInterface = t.strictInterface({
	universeId = t.string,
	sortId = t.optional(t.string),
	actionType = t.string
})

local v = {
	eventName = "notInterestedFeedbackFormAction",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 10, 22 },
	description = "User has taken an action with the Not Interested Feedback Form"
}

return function(customFields, eventContext: string)
	if not eventContext then
		DiscoveryEventErrorLogger.reportError(
			"NotInterestedFeedbackFormActionInvalidInterface",
			"event is missing context"
		)
	end

	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("NotInterestedFeedbackFormActionInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
