local Moments = script:FindFirstAncestor("Moments")
local Constants = require(Moments.Constants)
local t1 = {
	eventName = "RecommendationActionEvent",
	throttlingPercentage = 10000,
	description = "Fires on user actions in the moments platform feed",
	backends = { "EventIngest" },
	lastUpdated = {
		26,
		6,
		2
	}
}

local function emitRecommendationAction(t2: {[any]: any}) -- line: 28
	-- upvalues: Constants (copy), t1 (copy)
	local TelemetryService = game:GetService("TelemetryService")
	local HttpService = game:GetService("HttpService")
	local guid = nil

	if t2.actionType == Constants.RecommendationActionType.Play then
		guid = HttpService:GenerateGUID(false)
	end

	TelemetryService:LogEvent(t1, {
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
			action_type = tostring(t2.actionType),
			moments_session_id = t2.momentsSessionId,
			source_surface = Constants.SOURCE_SURFACE,
			reaction_type = t2.reactionType,
			destination_placeid = if not t2.destinationPlaceId then nil else tostring(t2.destinationPlaceId),
			comment_text = t2.commentText,
			action_weight = if not t2.actionWeight then nil else tostring(t2.actionWeight),
			moments_play_intent_id = guid
		}
	})

	return guid
end

return emitRecommendationAction
