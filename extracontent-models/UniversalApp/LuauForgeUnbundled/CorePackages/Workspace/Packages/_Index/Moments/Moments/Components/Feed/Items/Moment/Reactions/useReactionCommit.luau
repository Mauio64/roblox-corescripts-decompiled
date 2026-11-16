local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local fFlagMomentsReactFeatureGate = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsReactFeatureGate

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local ReactionEffectsContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/ReactionEffectsContext")
local reactionTruthTable = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/reactionTruthTable")
local SignalActionType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/SignalActionType")
local useFeedOptional = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeedOptional
local FFlagMomentsUseSharedReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUseSharedReactions")

local v5 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/applyReactionTrigger") else nil

local v6 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/ReactionTrigger") else nil

local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local useReactionEffects = ReactionEffectsContext.useReactionEffects

local function decideWithSharedRules(selectedReaction, p2, p3)
	local v7 = v5 ~= nil and v6 ~= nil
	assert(v7, "expected the shared Reactions rules")
	local set = {}

	if selectedReaction ~= nil then
		set[selectedReaction] = true
	end

	local v10

	if p2 == "tapButton" then
		v10 = v6.ButtonTap
	else
		v10 = if p2 == "doubleTap" then v6.DoubleTap else v6.PickerSelect
	end

	local v11 = v5({ selectedReactions = set, reactionCounts = {} }, v10, p3)

	return {
		action = v11.added == nil and (v11.removed == nil and "none" or "clear") or "commit",
		reaction = v11.added,
		effectReaction = v11.celebratedReaction
	}
end

local function useReactionCommit()
	local store = MomentContext.useMoment().store
	local v7 = useReactionEffects()

	local v8 = useFeedOptional()

	local v9 = not fFlagMomentsReactFeatureGate
		or SignalsReact.useSignalState(getMomentsCapabilities(false).getCanReactToMoments)

	return React.useCallback(function(p2, p3, p4)
		if fFlagMomentsReactFeatureGate and not v9 then
			return
		end

		local selectedReaction = store.getSelectedReaction(false)
		local v10

		if FFlagMomentsUseSharedReactions then
			v10 = decideWithSharedRules(selectedReaction, p2, p4)
		else
			v10 = reactionTruthTable.decide(selectedReaction, p2, p4)
		end

		if v10.action == "commit" and v10.reaction ~= nil then
			store.commitReaction(v10.reaction)
		elseif v10.action == "clear" then
			store.clearReaction()
		end

		if v8 ~= nil and v10.action ~= "none" then
			local data = store.getData(false)

			local feedItemId = data.feedItemId

			if feedItemId ~= nil and feedItemId ~= "" then
				local v11 = {
					itemId = feedItemId,
					tracingId = data.feedSessionId,
					contentType = data.contentType
				}

				local success, result = pcall(function()
					if v10.action == "commit" and v10.reaction ~= nil then
						v8.logAction(SignalActionType.AddReaction, v11, {
							reactionType = v10.reaction
						})
					elseif v10.action == "clear" then
						v8.logAction(SignalActionType.RemoveReaction, v11, {})
					end
				end)

				if not success then
					warn("Failed to log reaction action event", result)
				end
			end
		end

		if v7 ~= nil and v10.effectReaction ~= nil then
			v7.spawnExplosion(v10.effectReaction, p3)
		end
	end, { store, v7, v8, v9 })
end

return useReactionCommit
