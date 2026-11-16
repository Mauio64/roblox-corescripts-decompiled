local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local v5 = {
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

return function(p2, p3)
	local v6, v7 = strictInterface(p3)

	if not v6 then
		discoveryEventErrorLogger.reportError("ShowMoreClickEventInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p2,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p3
	})
end
