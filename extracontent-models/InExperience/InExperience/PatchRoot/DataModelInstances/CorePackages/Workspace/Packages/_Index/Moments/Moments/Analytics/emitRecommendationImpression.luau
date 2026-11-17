local Moments = script:FindFirstAncestor("Moments")
local Constants = require(Moments.Constants)
require(script.Parent.RecommendationContentType)
require(Moments.Enums.MomentsFeedType)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local FFlagMomentsRecommendationFeedType = require(Moments.Flags.FFlagMomentsRecommendationFeedType)

local v = {
	eventName = "RecommendationImpressionEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 29 },
	description = "Fires when a moment becomes visible in the platform feed"
}

local function emitRecommendationImpression(data)
	local TelemetryService = game:GetService("TelemetryService")
	local contentType

	if FFlagMomentsRecommendationContentType then
		contentType = data.contentType
	end

	local feed_type

	if FFlagMomentsRecommendationFeedType then
		feed_type = data.feedType
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = {
			playsessionid = "",
			universeid = Constants.MOMENTS_UNIVERSE_ID,
			placeid = Constants.MOMENTS_PLACE_ID,
			client_event_timestamp_ms = DateTime.now().UnixTimestampMillis,
			item_id = data.itemId,
			tracing_id = data.tracingId,
			item_position = tostring(data.position),
			duration_seconds = tostring(data.durationSeconds or 0),
			impression_type = tostring(data.impressionType or 1),
			weight = tostring(data.weight or 1),
			departure_intent = data.departureIntent,
			moments_session_id = data.momentsSessionId,
			source_surface = Constants.SOURCE_SURFACE,
			content_type = contentType,
			feed_type = feed_type
		}
	})
end

return emitRecommendationImpression
