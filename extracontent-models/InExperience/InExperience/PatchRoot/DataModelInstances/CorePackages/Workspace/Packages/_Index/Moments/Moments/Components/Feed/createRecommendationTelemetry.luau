local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.Signals)

local MomentsCommon = require(parent.MomentsCommon)
local Analytics = MomentsCommon.Analytics

local Constants = require(Moments.Constants)
require(Moments.Enums.MomentsFeedType)
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

local function createRecommendationTelemetry(data)
	local getMomentsSessionId = data.getMomentsSessionId
	local signalTracker = data.signalTracker
	local feedType = data.feedType

	return {
		logView = function(data2, p)
			emitRecommendationImpression({
				itemId = data2.itemId,
				tracingId = data2.tracingId or "",
				momentsSessionId = getMomentsSessionId(false),
				position = p.itemPosition,
				durationSeconds = p.durationSeconds,
				contentType = data2.contentType,
				feedType = feedType
			})

			if signalTracker then
				signalTracker:recordSignal(data2.itemId, "View", string.format("%.1f", p.durationSeconds))
			end
		end,
		logAction = function(p, data2, data3)
			local actionType = v[p]

			if actionType == nil then
				if signalTracker and v2[p] then
					signalTracker:recordSignal(
						data2.itemId,
						p,
						(p == "AddReaction" or p == "RemoveReaction") and data3.reactionType or ""
					)
				end

				return nil
			else
				local v4 = v3[p]

				if v4 ~= nil then
					Analytics.reportMomentsEngagement(v4)
				end

				local v5 = {
					itemId = data2.itemId,
					tracingId = data2.tracingId or "",
					momentsSessionId = 0,
					actionType = 0,
					reactionType = 0,
					destinationPlaceId = 0,
					commentText = 0,
					actionWeight = 0,
					contentType = 0,
					commentSectionOpenDurationSeconds = 0,
					feedType = 0
				}
				local momentsSessionId

				if FFlagMomentsComments and data3.momentsSessionId ~= nil then
					momentsSessionId = data3.momentsSessionId
				else
					momentsSessionId = getMomentsSessionId(false)
				end

				v5.momentsSessionId = momentsSessionId

				v5.actionType = actionType
				v5.reactionType = data3.reactionType
				v5.destinationPlaceId = data3.destinationPlaceId
				v5.commentText = data3.commentText
				v5.actionWeight = data3.actionWeight
				v5.contentType = data2.contentType
				local commentSectionOpenDurationSeconds

				if FFlagMomentsComments then
					commentSectionOpenDurationSeconds = data3.commentSectionOpenDurationSeconds
				end

				v5.commentSectionOpenDurationSeconds = commentSectionOpenDurationSeconds

				v5.feedType = feedType
				local v6 = emitRecommendationAction(v5)

				if signalTracker then
					signalTracker:recordSignal(
						data2.itemId,
						p,
						(p == "AddReaction" or p == "RemoveReaction") and data3.reactionType or ""
					)
				end

				return v6
			end
		end
	}
end

return createRecommendationTelemetry
