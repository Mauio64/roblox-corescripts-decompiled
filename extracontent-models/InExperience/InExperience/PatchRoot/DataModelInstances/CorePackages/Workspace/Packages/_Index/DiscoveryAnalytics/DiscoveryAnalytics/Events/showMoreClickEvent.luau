local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local v = {
	eventName = "showMoreClick",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppShowMoreClickEventThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 5, 12 },
	description = "User clicked the show more button to reveal additional rows in a home game grid"
}

local strictInterface = t.strictInterface({
	topicId = t.string,
	sortIndex = t.number,
	previousVisibleRows = t.number,
	newVisibleRows = t.number,
	visibleRowsPerReveal = t.number,
	totalNumberOfRows = t.number
})

return function(eventContext, customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("ShowMoreClickEventInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end
