local TelemetryService = game:GetService("TelemetryService")

require(script.Parent.buildSocialProofTextEventParams)

local v = {
	eventName = "edpSocialProofTextClicked",
	description = "The user tapped the EDP social proof text to open the full list of friends who played",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("EdpSocialProofTextClickedHundredthsPercent", 10000),
	lastUpdated = { 26, 11, 4 }
}

local function sendSocialProofTextClickedEvent(customFields)
	TelemetryService:LogEvent(v, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end

return sendSocialProofTextClickedEvent
