local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local fFlagMomentsComments = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsComments
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/RecommendationContentType")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")

local v5 = {
	eventName = "RecommendationActionEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 29 },
	description = "Fires on user actions in the moments platform feed"
}

local function emitRecommendationAction(data)
	local TelemetryService = game:GetService("TelemetryService")
	local HttpService = game:GetService("HttpService")
	local v6

	if data.actionType == Constants.RecommendationActionType.Play then
		v6 = HttpService:GenerateGUID(false)
	end

	local contentType = if FFlagMomentsRecommendationContentType then data.contentType else nil

	local v9 = {
		playsessionid = "",
		universeid = Constants.MOMENTS_UNIVERSE_ID,
		placeid = Constants.MOMENTS_PLACE_ID,
		client_event_timestamp_ms = DateTime.now().UnixTimestampMillis,
		item_id = data.itemId,
		tracing_id = data.tracingId,
		action_type = tostring(data.actionType),
		moments_session_id = data.momentsSessionId,
		source_surface = Constants.SOURCE_SURFACE,
		reaction_type = data.reactionType,
		destination_placeid = 0,
		comment_text = 0,
		comment_section_open_duration_seconds = 0,
		action_weight = 0,
		moments_play_intent_id = 0,
		content_type = 0
	}
	local v10 = if data.destinationPlaceId then tostring(data.destinationPlaceId) else nil
	v9.destination_placeid = v10
	v9.comment_text = data.commentText

	local v11 = if fFlagMomentsComments and data.commentSectionOpenDurationSeconds ~= nil then tostring(data.commentSectionOpenDurationSeconds) else nil
	v9.comment_section_open_duration_seconds = v11

	local v12 = if data.actionWeight then tostring(data.actionWeight) else nil
	v9.action_weight = v12
	v9.moments_play_intent_id = v6
	v9.content_type = contentType
	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = v9
	})

	return v6
end

return emitRecommendationAction
