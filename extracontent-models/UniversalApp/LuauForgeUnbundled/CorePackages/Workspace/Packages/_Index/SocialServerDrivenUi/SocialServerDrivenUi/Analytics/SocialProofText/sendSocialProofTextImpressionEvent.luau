local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/SocialProofText/buildSocialProofTextEventParams")

local v5 = {
	eventName = "edpSocialProofTextImpression",
	description = "The EDP social proof text (friends who played, with an avatar stack) was shown",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("EdpSocialProofTextImpressionHundredthsPercent", 10000),
	lastUpdated = { 26, 11, 4 }
}

local function sendSocialProofTextImpressionEvent(p2)
	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p2
	})
end

return sendSocialProofTextImpressionEvent
