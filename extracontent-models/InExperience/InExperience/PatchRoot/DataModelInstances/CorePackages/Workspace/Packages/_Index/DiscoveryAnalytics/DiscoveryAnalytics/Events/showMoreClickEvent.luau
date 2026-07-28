local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("LuaAppShowMoreClickEventThrottlingHundredthsPercent", 10000)
local t1 = {
	eventName = "showMoreClick",
	description = "User clicked the show more button to reveal additional rows in a home game grid",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = v5,
	lastUpdated = {
		26,
		5,
		12
	}
}
local v7 = t.strictInterface({
	topicId = t.string,
	sortIndex = t.number,
	previousVisibleRows = t.number,
	newVisibleRows = t.number,
	visibleRowsPerReveal = t.number,
	totalNumberOfRows = t.number
})

return function(p1, p2) -- line: 28
	-- upvalues: v7 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v10, v11 = v7(p2)

	if not v10 then
		DiscoveryEventErrorLogger.reportError("ShowMoreClickEventInvalidInterface", v11)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = p1,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = p2
	})
end
