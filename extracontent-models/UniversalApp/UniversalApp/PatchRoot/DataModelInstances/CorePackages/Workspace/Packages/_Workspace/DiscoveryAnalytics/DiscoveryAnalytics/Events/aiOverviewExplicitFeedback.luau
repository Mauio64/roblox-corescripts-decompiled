local TelemetryService = game:GetService("TelemetryService")
local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local DiscoveryAnalyticsParent = DiscoveryAnalytics.Parent
local t = require(DiscoveryAnalyticsParent.t)
local DiscoveryEventErrorLogger = require(DiscoveryAnalyticsParent.DiscoveryUtils).DiscoveryEventErrorLogger
local AiOverviewSentiment = require(DiscoveryAnalytics.Constants.AiOverviewSentiment)
local v7 = game:DefineFastInt("AiOverviewExplicitFeedbackThrottleHundrethsPercent", 10000)
local v8 = t.strictInterface({
	sentiment = t.union(t.literal(AiOverviewSentiment.ThumbsUp), t.literal(AiOverviewSentiment.ThumbsDown)),
	searchSessionId = t.string,
	query = t.string,
	didSubmit = t.boolean,
	feedbackText = t.optional(t.string)
})

return function(t1: {[any]: any}, s1: string) -- line: 28
	-- upvalues: v8 (copy), DiscoveryEventErrorLogger (copy), v7 (copy), TelemetryService (copy)
	local v11, v12 = v8(t1)

	if not v11 then
		DiscoveryEventErrorLogger.reportError("AiOverviewExplicitFeedbackInvalidInterface", v12)
	end

	local t2 = {
		eventName = "aiOverviewExplicitFeedback",
		description = "User submitted or dismissed freeform text feedback on AI Overview",
		backends = { "EventIngest" },
		throttlingPercentage = v7,
		lastUpdated = {
			26,
			6,
			24
		}
	}

	TelemetryService:LogEvent(t2, {
		eventContext = s1,
		standardizedFields = { "addSessionInfo" },
		customFields = t1
	})
end
