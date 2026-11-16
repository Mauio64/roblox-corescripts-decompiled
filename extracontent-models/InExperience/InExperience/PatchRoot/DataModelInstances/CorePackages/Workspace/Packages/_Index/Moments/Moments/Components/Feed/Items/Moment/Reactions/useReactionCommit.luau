local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsReactFeatureGate = SharedFlags.FFlagMomentsReactFeatureGate

local MomentContext = require(script.Parent.Parent.MomentContext)
local ReactionEffectsContext = require(script.Parent.ReactionEffectsContext)
local reactionTruthTable = require(script.Parent.reactionTruthTable)
local SignalActionType = require(Moments.Enums.SignalActionType)
local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeedOptional = FeedContext.useFeedOptional
local FFlagMomentsUseSharedReactions = require(Moments.Flags.FFlagMomentsUseSharedReactions)
local applyReactionTrigger

if FFlagMomentsUseSharedReactions then
	applyReactionTrigger = require(parent.Reactions.applyReactionTrigger)
else
	applyReactionTrigger = nil
end

local ReactionTrigger

if FFlagMomentsUseSharedReactions then
	ReactionTrigger = require(parent.Reactions.ReactionTrigger)
else
	ReactionTrigger = nil
end

local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local useReactionEffects = ReactionEffectsContext.useReactionEffects

local function decideWithSharedRules(selectedReaction, p, p2)
	local v = applyReactionTrigger ~= nil and ReactionTrigger ~= nil
	assert(v, "expected the shared Reactions rules")
	local set = {}

	if selectedReaction ~= nil then
		set[selectedReaction] = true
	end

	local v2

	if p == "tapButton" then
		v2 = ReactionTrigger.ButtonTap
	elseif p == "doubleTap" then
		v2 = ReactionTrigger.DoubleTap
	else
		v2 = ReactionTrigger.PickerSelect
	end

	local v3 = applyReactionTrigger({ selectedReactions = set, reactionCounts = {} }, v2, p2)

	return {
		action = v3.added == nil and (v3.removed == nil and "none" or "clear") or "commit",
		reaction = v3.added,
		effectReaction = v3.celebratedReaction
	}
end

local function useReactionCommit()
	local store = MomentContext.useMoment().store
	local v = useReactionEffects()

	local v2 = useFeedOptional()

	local v3 = not FFlagMomentsReactFeatureGate
		or SignalsReact.useSignalState(GetMomentsCapabilities(false).getCanReactToMoments)

	return React.useCallback(function(p, vector2: Vector2?, p2)
		if FFlagMomentsReactFeatureGate and not v3 then
			return
		end

		local selectedReaction = store.getSelectedReaction(false)
		local v4

		if FFlagMomentsUseSharedReactions then
			v4 = decideWithSharedRules(selectedReaction, p, p2)
		else
			v4 = reactionTruthTable.decide(selectedReaction, p, p2)
		end

		if v4.action == "commit" and v4.reaction ~= nil then
			store.commitReaction(v4.reaction)
		elseif v4.action == "clear" then
			store.clearReaction()
		end

		if v2 ~= nil and v4.action ~= "none" then
			local data = store.getData(false)

			local feedItemId = data.feedItemId

			if feedItemId ~= nil and feedItemId ~= "" then
				local v5 = {
					itemId = feedItemId,
					tracingId = data.feedSessionId,
					contentType = data.contentType
				}

				local success, result = pcall(function()
					if v4.action == "commit" and v4.reaction ~= nil then
						v2.logAction(SignalActionType.AddReaction, v5, {
							reactionType = v4.reaction
						})
					elseif v4.action == "clear" then
						v2.logAction(SignalActionType.RemoveReaction, v5, {})
					end
				end)

				if not success then
					warn("Failed to log reaction action event", result)
				end
			end
		end

		if v ~= nil and v4.effectReaction ~= nil then
			v.spawnExplosion(v4.effectReaction, vector2)
		end
	end, { store, v, v2, v3 })
end

return useReactionCommit
