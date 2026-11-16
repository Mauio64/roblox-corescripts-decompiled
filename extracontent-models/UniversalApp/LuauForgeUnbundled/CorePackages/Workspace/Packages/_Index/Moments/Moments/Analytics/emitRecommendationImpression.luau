local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/RecommendationContentType")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")

local v5 = {
	eventName = "RecommendationImpressionEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 29 },
	description = "Fires when a moment becomes visible in the platform feed"
}

local function emitRecommendationImpression(data)
	local TelemetryService = game:GetService("TelemetryService")

	local v6 = if FFlagMomentsRecommendationContentType then data.contentType else nil

	TelemetryService:LogEvent(v5, {
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
			content_type = v6
		}
	})
end

return emitRecommendationImpression
