local Moments = script:FindFirstAncestor("Moments")
local Constants = require(Moments.Constants)
local t1 = {
	eventName = "RecommendationImpressionEvent",
	throttlingPercentage = 10000,
	description = "Fires when a moment becomes visible in the platform feed",
	backends = { "EventIngest" },
	lastUpdated = {
		26,
		6,
		2
	}
}

local function emitRecommendationImpression(t2: {[any]: any}) -- line: 25
	-- upvalues: t1 (copy), Constants (copy)
	game:GetService("TelemetryService"):LogEvent(t1, {
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = {
			playsessionid = "",
			universeid = Constants.MOMENTS_UNIVERSE_ID,
			placeid = Constants.MOMENTS_PLACE_ID,
			item_id = t2.itemId,
			tracing_id = t2.tracingId,
			item_position = tostring(t2.position),
			duration_seconds = tostring(t2.durationSeconds or 0),
			impression_type = tostring(t2.impressionType or 1),
			weight = tostring(t2.weight or 1),
			departure_intent = t2.departureIntent,
			moments_session_id = t2.momentsSessionId,
			source_surface = Constants.SOURCE_SURFACE
		}
	})
end

return emitRecommendationImpression
