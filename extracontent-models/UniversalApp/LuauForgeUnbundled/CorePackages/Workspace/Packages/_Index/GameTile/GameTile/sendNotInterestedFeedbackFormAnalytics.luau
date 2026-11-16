local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("NotInterestedFeedbackFormActionThrottleHundredthsPercent", 0)

local strictInterface = t.strictInterface({
	universeId = t.string,
	sortId = t.optional(t.string),
	actionType = t.string
})

local v5 = {
	eventName = "notInterestedFeedbackFormAction",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 10, 22 },
	description = "User has taken an action with the Not Interested Feedback Form"
}

return function(p2, p3)
	if not p3 then
		discoveryEventErrorLogger.reportError(
			"NotInterestedFeedbackFormActionInvalidInterface",
			"event is missing context"
		)
	end

	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("NotInterestedFeedbackFormActionInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
