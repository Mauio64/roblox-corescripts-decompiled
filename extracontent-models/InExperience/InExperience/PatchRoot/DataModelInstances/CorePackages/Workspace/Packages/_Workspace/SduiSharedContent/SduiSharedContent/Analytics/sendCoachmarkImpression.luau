local TelemetryService = game:GetService("TelemetryService")

local v = {
	eventName = "coachmarkImpression",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("CoachmarkImpressionThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 6, 16 },
	description = "Sent when a coachmark is shown"
}

local standardizedFields = { "addOSInfo", "addSessionInfo" }

local function sendCoachmarkImpression(collectionServiceAnchorTag: string, hasMedia: boolean)
	TelemetryService:LogEvent(v, {
		standardizedFields = standardizedFields,
		customFields = {
			collectionServiceAnchorTag = collectionServiceAnchorTag,
			hasMedia = hasMedia
		}
	})
end

return sendCoachmarkImpression
