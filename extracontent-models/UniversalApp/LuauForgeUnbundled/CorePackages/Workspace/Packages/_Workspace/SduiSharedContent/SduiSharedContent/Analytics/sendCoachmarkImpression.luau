local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "coachmarkImpression",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("CoachmarkImpressionThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 6, 16 },
	description = "Sent when a coachmark is shown"
}

local v6 = { "addOSInfo", "addSessionInfo" }

local function sendCoachmarkImpression(p2, p3)
	TelemetryService:LogEvent(v5, {
		standardizedFields = v6,
		customFields = { collectionServiceAnchorTag = p2, hasMedia = p3 }
	})
end

return sendCoachmarkImpression
