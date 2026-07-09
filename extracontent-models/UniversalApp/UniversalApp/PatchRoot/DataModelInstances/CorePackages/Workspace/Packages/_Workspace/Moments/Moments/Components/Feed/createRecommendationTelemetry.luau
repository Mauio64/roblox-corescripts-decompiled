local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.Signals)

local Constants = require(Moments.Constants)
local emitRecommendationImpression = require(Moments.Analytics.emitRecommendationImpression)
local emitRecommendationAction = require(Moments.Analytics.emitRecommendationAction)

require(Moments.SignalTracker)
require(script.Parent.FeedTypes)

local t1 = {
	AddReaction = Constants.RecommendationActionType.AddReaction,
	RemoveReaction = Constants.RecommendationActionType.RemoveReaction,
	Share = Constants.RecommendationActionType.Share,
	Report = Constants.RecommendationActionType.Report,
	Join = Constants.RecommendationActionType.Play
}

local function getSignalValue(p1, t2: {[any]: any}) -- line: 50
	if p1 == "AddReaction" or p1 == "RemoveReaction" then
		return t2.reactionType or ""
	end

	return ""
end
local function createRecommendationTelemetry(t3: {[any]: any}) -- line: 57
	-- upvalues: emitRecommendationImpression (copy), t1 (copy), emitRecommendationAction (copy)
	local getMomentsSessionId = t3.getMomentsSessionId
	local signalTracker = t3.signalTracker

	return {
		logView = function(p2, p3) -- line: 62
			-- upvalues: emitRecommendationImpression (copy), getMomentsSessionId (copy), signalTracker (copy)
			emitRecommendationImpression({
				itemId = p2.itemId,
				tracingId = p2.tracingId or "",
				momentsSessionId = getMomentsSessionId(false),
				position = p3.itemPosition,
				durationSeconds = p3.durationSeconds
			})

			if signalTracker then
				signalTracker:recordSignal(p2.itemId, "View", string.format("%.1f", p3.durationSeconds))
			end
		end,
		logAction = function(p4, p5, t4: {[any]: any}) -- line: 76
			-- upvalues: t1 (copy), emitRecommendationAction (copy), getMomentsSessionId (copy), signalTracker (copy)
			local v19 = t1[p4]

			if v19 == nil then
				return nil
			end

			local v20 = emitRecommendationAction({
				itemId = p5.itemId,
				tracingId = p5.tracingId or "",
				momentsSessionId = getMomentsSessionId(false),
				actionType = v19,
				reactionType = t4.reactionType,
				destinationPlaceId = t4.destinationPlaceId,
				commentText = t4.commentText,
				actionWeight = t4.actionWeight
			})

			if signalTracker then
				signalTracker:recordSignal(p5.itemId, p4, p4 ~= "AddReaction" and p4 ~= "RemoveReaction" and "" or (t4.reactionType or ""))
			end

			return v20
		end
	}
end

return createRecommendationTelemetry
