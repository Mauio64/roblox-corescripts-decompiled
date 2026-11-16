local TelemetryService = game:GetService("TelemetryService")
local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local parent = DiscoveryAnalytics.Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local AiOverviewSentiment = require(DiscoveryAnalytics.Constants.AiOverviewSentiment)

local defineFastInt = game:DefineFastInt("AiOverviewSentimentThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface({
	sentiment = t.union(t.literal(AiOverviewSentiment.ThumbsUp), t.literal(AiOverviewSentiment.ThumbsDown)),
	searchSessionId = t.string,
	query = t.string,
	universeIds = t.optional(t.string)
})

return function(customFields, eventContext: string)
	local v, v2 = strictInterface(customFields)

	if not v then
		DiscoveryEventErrorLogger.reportError("AiOverviewSentimentInvalidInterface", v2)
	end

	TelemetryService:LogEvent({
		eventName = "aiOverviewSentiment",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 6, 24 },
		description = "User tapped thumbs up or down on AI Overview card"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
