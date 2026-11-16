require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Analytics

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local emitRecommendationImpression = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/emitRecommendationImpression")
local emitRecommendationAction = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/emitRecommendationAction")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/SignalTracker")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local fFlagMomentsComments = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsComments

local v5 = {
	AddReaction = Constants.RecommendationActionType.AddReaction,
	RemoveReaction = Constants.RecommendationActionType.RemoveReaction,
	Share = Constants.RecommendationActionType.Share,
	Report = Constants.RecommendationActionType.Report,
	Join = Constants.RecommendationActionType.Play,
	Comment = 0,
	CommentDelete = 0,
	CommentSectionOpen = 0
}
local v6 = if fFlagMomentsComments then Constants.RecommendationActionType.Comment else nil
v5.Comment = v6
local v7 = if fFlagMomentsComments then Constants.RecommendationActionType.CommentDelete else nil
v5.CommentDelete = v7
local v8 = if fFlagMomentsComments then Constants.RecommendationActionType.CommentSectionOpen else nil
v5.CommentSectionOpen = v8

local v9 = { AddFollow = true, RemoveFollow = true }

local v10 = {
	AddReaction = "reaction_add",
	RemoveReaction = "reaction_remove",
	Share = "share",
	Report = "report",
	Join = "join"
}

local function getSignalValue(p2, p3)
	if p2 == "AddReaction" or p2 == "RemoveReaction" then
		return p3.reactionType or ""
	end

	return ""
end

local function createRecommendationTelemetry(p2)
	local getMomentsSessionId = p2.getMomentsSessionId
	local signalTracker = p2.signalTracker

	return {
		logView = function(data, p3)
			emitRecommendationImpression({
				itemId = data.itemId,
				tracingId = data.tracingId or "",
				momentsSessionId = getMomentsSessionId(false),
				position = p3.itemPosition,
				durationSeconds = p3.durationSeconds,
				contentType = data.contentType
			})

			if signalTracker then
				signalTracker:recordSignal(data.itemId, "View", string.format("%.1f", p3.durationSeconds))
			end
		end,
		logAction = function(p3, data, data2)
			local v11 = v5[p3]

			if v11 == nil then
				if signalTracker and v9[p3] then
					signalTracker:recordSignal(
						data.itemId,
						p3,
						(p3 == "AddReaction" or p3 == "RemoveReaction") and data2.reactionType or ""
					)
				end

				return nil
			else
				local v12 = v10[p3]

				if v12 ~= nil then
					analytics.reportMomentsEngagement(v12)
				end

				local v14 = {
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
				local v15 = if fFlagMomentsComments and data2.momentsSessionId ~= nil then data2.momentsSessionId else getMomentsSessionId(false)
				v14.momentsSessionId = v15

				v14.actionType = v11
				v14.reactionType = data2.reactionType
				v14.destinationPlaceId = data2.destinationPlaceId
				v14.commentText = data2.commentText
				v14.actionWeight = data2.actionWeight
				v14.contentType = data.contentType

				local v16 = if fFlagMomentsComments then data2.commentSectionOpenDurationSeconds else nil
				v14.commentSectionOpenDurationSeconds = v16
				local v17 = emitRecommendationAction(v14)

				if signalTracker then
					signalTracker:recordSignal(
						data.itemId,
						p3,
						(p3 == "AddReaction" or p3 == "RemoveReaction") and data2.reactionType or ""
					)
				end

				return v17
			end
		end
	}
end

return createRecommendationTelemetry
