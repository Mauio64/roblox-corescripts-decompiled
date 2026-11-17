local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent
local Constants = require(Moments.Constants)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
require(script.Parent.RecommendationContentType)
require(Moments.Enums.MomentsFeedType)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local FFlagMomentsRecommendationFeedType = require(Moments.Flags.FFlagMomentsRecommendationFeedType)

local v = {
	eventName = "RecommendationActionEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 29 },
	description = "Fires on user actions in the moments platform feed"
}

local function emitRecommendationAction(data)
	local TelemetryService = game:GetService("TelemetryService")
	local HttpService = game:GetService("HttpService")
	local moments_play_intent_id

	if data.actionType == Constants.RecommendationActionType.Play then
		moments_play_intent_id = HttpService:GenerateGUID(false)
	end

	local contentType

	if FFlagMomentsRecommendationContentType then
		contentType = data.contentType
	end

	local feedType

	if FFlagMomentsRecommendationFeedType then
		feedType = data.feedType
	end

	local customFields = {
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
		content_type = 0,
		feed_type = 0
	}
	local destination_placeid

	if data.destinationPlaceId then
		destination_placeid = tostring(data.destinationPlaceId)
	end

	customFields.destination_placeid = destination_placeid
	customFields.comment_text = data.commentText
	local comment_section_open_duration_seconds

	if FFlagMomentsComments and data.commentSectionOpenDurationSeconds ~= nil then
		comment_section_open_duration_seconds = tostring(data.commentSectionOpenDurationSeconds)
	end

	customFields.comment_section_open_duration_seconds = comment_section_open_duration_seconds
	local action_weight

	if data.actionWeight then
		action_weight = tostring(data.actionWeight)
	end

	customFields.action_weight = action_weight
	customFields.moments_play_intent_id = moments_play_intent_id
	customFields.content_type = contentType
	customFields.feed_type = feedType
	TelemetryService:LogEvent(v, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})

	return moments_play_intent_id
end

return emitRecommendationAction
