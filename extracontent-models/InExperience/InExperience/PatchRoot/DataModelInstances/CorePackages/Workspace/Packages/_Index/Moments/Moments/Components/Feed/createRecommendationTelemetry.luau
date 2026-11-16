local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.Signals)

local MomentsCommon = require(parent.MomentsCommon)
local Analytics = MomentsCommon.Analytics

local Constants = require(Moments.Constants)
local emitRecommendationImpression = require(Moments.Analytics.emitRecommendationImpression)
local emitRecommendationAction = require(Moments.Analytics.emitRecommendationAction)

require(Moments.SignalTracker)
require(script.Parent.FeedTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments

local v = {
	AddReaction = Constants.RecommendationActionType.AddReaction,
	RemoveReaction = Constants.RecommendationActionType.RemoveReaction,
	Share = Constants.RecommendationActionType.Share,
	Report = Constants.RecommendationActionType.Report,
	Join = Constants.RecommendationActionType.Play,
	Comment = 0,
	CommentDelete = 0,
	CommentSectionOpen = 0
}
local comment

if FFlagMomentsComments then
	comment = Constants.RecommendationActionType.Comment
end

v.Comment = comment
local commentDelete

if FFlagMomentsComments then
	commentDelete = Constants.RecommendationActionType.CommentDelete
end

v.CommentDelete = commentDelete
local commentSectionOpen

if FFlagMomentsComments then
	commentSectionOpen = Constants.RecommendationActionType.CommentSectionOpen
end

v.CommentSectionOpen = commentSectionOpen

local v2 = { AddFollow = true, RemoveFollow = true }

local v3 = {
	AddReaction = "reaction_add",
	RemoveReaction = "reaction_remove",
	Share = "share",
	Report = "report",
	Join = "join"
}

local function getSignalValue(p, p2)
	if p == "AddReaction" or p == "RemoveReaction" then
		return p2.reactionType or ""
	end

	return ""
end

local function createRecommendationTelemetry(p)
	local getMomentsSessionId = p.getMomentsSessionId
	local signalTracker = p.signalTracker

	return {
		logView = function(data, p2)
			emitRecommendationImpression({
				itemId = data.itemId,
				tracingId = data.tracingId or "",
				momentsSessionId = getMomentsSessionId(false),
				position = p2.itemPosition,
				durationSeconds = p2.durationSeconds,
				contentType = data.contentType
			})

			if signalTracker then
				signalTracker:recordSignal(data.itemId, "View", string.format("%.1f", p2.durationSeconds))
			end
		end,
		logAction = function(p2, data, data2)
			local actionType = v[p2]

			if actionType == nil then
				if signalTracker and v2[p2] then
					signalTracker:recordSignal(
						data.itemId,
						p2,
						(p2 == "AddReaction" or p2 == "RemoveReaction") and data2.reactionType or ""
					)
				end

				return nil
			else
				local v4 = v3[p2]

				if v4 ~= nil then
					Analytics.reportMomentsEngagement(v4)
				end

				local v5 = {
					itemId = data.itemId,
					tracingId = data.tracingId or "",
					momentsSessionId = 0,
					actionType = 0,
					reactionType = 0,
					destinationPlaceId = 0,
					commentText = 0,
					actionWeight = 0,
					contentType = 0,
					commentSectionOpenDurationSeconds = 0
				}
				local momentsSessionId

				if FFlagMomentsComments and data2.momentsSessionId ~= nil then
					momentsSessionId = data2.momentsSessionId
				else
					momentsSessionId = getMomentsSessionId(false)
				end

				v5.momentsSessionId = momentsSessionId

				v5.actionType = actionType
				v5.reactionType = data2.reactionType
				v5.destinationPlaceId = data2.destinationPlaceId
				v5.commentText = data2.commentText
				v5.actionWeight = data2.actionWeight
				v5.contentType = data.contentType
				local commentSectionOpenDurationSeconds

				if FFlagMomentsComments then
					commentSectionOpenDurationSeconds = data2.commentSectionOpenDurationSeconds
				end

				v5.commentSectionOpenDurationSeconds = commentSectionOpenDurationSeconds
				local v6 = emitRecommendationAction(v5)

				if signalTracker then
					signalTracker:recordSignal(
						data.itemId,
						p2,
						(p2 == "AddReaction" or p2 == "RemoveReaction") and data2.reactionType or ""
					)
				end

				return v6
			end
		end
	}
end

return createRecommendationTelemetry
