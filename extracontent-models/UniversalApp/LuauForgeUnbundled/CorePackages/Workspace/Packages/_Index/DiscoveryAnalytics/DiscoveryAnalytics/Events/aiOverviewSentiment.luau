local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger
local AiOverviewSentiment = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Constants/AiOverviewSentiment")

local defineFastInt = game:DefineFastInt("AiOverviewSentimentThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface({
	sentiment = t.union(t.literal(AiOverviewSentiment.ThumbsUp), t.literal(AiOverviewSentiment.ThumbsDown)),
	searchSessionId = t.string,
	query = t.string,
	universeIds = t.optional(t.string)
})

return function(p2, p3)
	local v5, v6 = strictInterface(p2)

	if not v5 then
		discoveryEventErrorLogger.reportError("AiOverviewSentimentInvalidInterface", v6)
	end

	TelemetryService:LogEvent({
		eventName = "aiOverviewSentiment",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 6, 24 },
		description = "User tapped thumbs up or down on AI Overview card"
	}, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
