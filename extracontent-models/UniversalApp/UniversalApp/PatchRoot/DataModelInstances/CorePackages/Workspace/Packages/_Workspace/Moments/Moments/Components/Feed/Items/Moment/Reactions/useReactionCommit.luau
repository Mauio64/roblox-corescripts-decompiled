local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.MomentsCommon)

local React = require(MomentsParent.React)
local MomentContext = require(script.Parent.Parent.MomentContext)
local ReactionEffectsContext = require(script.Parent.ReactionEffectsContext)
local reactionTruthTable = require(script.Parent.reactionTruthTable)
local SignalActionType = require(Moments.Enums.SignalActionType)
local useFeedOptional = require(Moments.Components.Feed.FeedContext).useFeedOptional
local useReactionEffects = ReactionEffectsContext.useReactionEffects

local function useReactionCommit() -- line: 31
	-- upvalues: MomentContext (copy), useReactionEffects (copy), useFeedOptional (copy), React (copy), reactionTruthTable (copy), SignalActionType (copy)
	local store = MomentContext.useMoment().store
	local v12 = useReactionEffects()
	local v13 = useFeedOptional()

	return React.useCallback(function(p1, vector2: Vector2?, p2) -- line: 40
		-- upvalues: store (copy), reactionTruthTable (copy), v13 (copy), SignalActionType (copy), v12 (copy)
		local v17 = store.getSelectedReaction(false)
		local v18 = reactionTruthTable.decide(v17, p1, p2)

		if v18.action == "commit" and v18.reaction ~= nil then
			store.commitReaction(v18.reaction)
		elseif v18.action == "clear" then
			store.clearReaction()
		end

		if v13 ~= nil and v18.action ~= "none" then
			local v19 = store.getData(false)
			local feedItemId = v19.feedItemId

			if feedItemId ~= nil and feedItemId ~= "" then
				local t1 = {
					itemId = feedItemId,
					tracingId = v19.feedSessionId
				}
				local ok, result = pcall(function() -- line: 62
					-- upvalues: v18 (copy), v13 (copy), SignalActionType (copy), t1 (copy)
					if v18.action == "commit" and v18.reaction ~= nil then
						v13.logAction(SignalActionType.AddReaction, t1, {
							reactionType = v18.reaction
						})

						return
					end

					if v18.action == "clear" then
						v13.logAction(SignalActionType.RemoveReaction, t1, {})
					end
				end)

				if not ok then
					warn("Failed to log reaction action event", result)
				end
			end
		end

		if v12 ~= nil and v18.effectReaction ~= nil then
			v12.spawnExplosion(v18.effectReaction, vector2)
		end
	end, {
		store,
		v12,
		v13
	})
end

return useReactionCommit
