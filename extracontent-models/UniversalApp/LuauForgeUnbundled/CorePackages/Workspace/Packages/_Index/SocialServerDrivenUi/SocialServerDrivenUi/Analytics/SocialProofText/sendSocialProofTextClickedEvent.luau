local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/SocialProofText/buildSocialProofTextEventParams")

local v5 = {
	eventName = "edpSocialProofTextClicked",
	description = "The user tapped the EDP social proof text to open the full list of friends who played",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("EdpSocialProofTextClickedHundredthsPercent", 10000),
	lastUpdated = { 26, 11, 4 }
}

local function sendSocialProofTextClickedEvent(p2)
	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p2
	})
end

return sendSocialProofTextClickedEvent
