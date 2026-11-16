local TelemetryService = game:GetService("TelemetryService")
local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local parent = DiscoveryAnalytics.Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local AiOverviewSentiment = require(DiscoveryAnalytics.Constants.AiOverviewSentiment)

local defineFastInt = game:DefineFastInt("AiOverviewExplicitFeedbackThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface({
	sentiment = t.union(t.literal(AiOverviewSentiment.ThumbsUp), t.literal(AiOverviewSentiment.ThumbsDown)),
	searchSessionId = t.string,
	query = t.string,
	didSubmit = t.boolean,
	feedbackText = t.optional(t.string)
})

return function(customFields, eventContext: string)
	local v, v2 = strictInterface(customFields)

	if not v then
		DiscoveryEventErrorLogger.reportError("AiOverviewExplicitFeedbackInvalidInterface", v2)
	end

	TelemetryService:LogEvent({
		eventName = "aiOverviewExplicitFeedback",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 6, 24 },
		description = "User submitted or dismissed freeform text feedback on AI Overview"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
