require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Analytics

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/MomentsFeedType")
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

local function createRecommendationTelemetry(data)
	local getMomentsSessionId = data.getMomentsSessionId
	local signalTracker = data.signalTracker
	local feedType = data.feedType

	return {
		logView = function(data2, p2)
			emitRecommendationImpression({
				itemId = data2.itemId,
				tracingId = data2.tracingId or "",
				momentsSessionId = getMomentsSessionId(false),
				position = p2.itemPosition,
				durationSeconds = p2.durationSeconds,
				contentType = data2.contentType,
				feedType = feedType
			})

			if signalTracker then
				signalTracker:recordSignal(data2.itemId, "View", string.format("%.1f", p2.durationSeconds))
			end
		end,
		logAction = function(p2, data2, data3)
			local v11 = v5[p2]

			if v11 == nil then
				if signalTracker and v9[p2] then
					signalTracker:recordSignal(
						data2.itemId,
						p2,
						(p2 == "AddReaction" or p2 == "RemoveReaction") and data3.reactionType or ""
					)
				end

				return nil
			else
				local v12 = v10[p2]

				if v12 ~= nil then
					analytics.reportMomentsEngagement(v12)
				end

				local v14 = {
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
				local v15 = if fFlagMomentsComments and data3.momentsSessionId ~= nil then data3.momentsSessionId else getMomentsSessionId(false)
				v14.momentsSessionId = v15

				v14.actionType = v11
				v14.reactionType = data3.reactionType
				v14.destinationPlaceId = data3.destinationPlaceId
				v14.commentText = data3.commentText
				v14.actionWeight = data3.actionWeight
				v14.contentType = data2.contentType

				local v16 = if fFlagMomentsComments then data3.commentSectionOpenDurationSeconds else nil
				v14.commentSectionOpenDurationSeconds = v16

				v14.feedType = feedType
				local v17 = emitRecommendationAction(v14)

				if signalTracker then
					signalTracker:recordSignal(
						data2.itemId,
						p2,
						(p2 == "AddReaction" or p2 == "RemoveReaction") and data3.reactionType or ""
					)
				end

				return v17
			end
		end
	}
end

return createRecommendationTelemetry
