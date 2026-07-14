local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity
local MomentContext = require(script.Parent.Parent.MomentContext)
local ReactionEffectsContext = require(script.Parent.ReactionEffectsContext)
local reactionTruthTable = require(script.Parent.reactionTruthTable)
local SignalActionType = require(Moments.Enums.SignalActionType)
local useFeedOptional = require(Moments.Components.Feed.FeedContext).useFeedOptional
local useReactionEffects = ReactionEffectsContext.useReactionEffects

local function useReactionCommit() -- line: 32
	-- upvalues: MomentContext (copy), useReactionEffects (copy), useFeedOptional (copy), React (copy), reactionTruthTable (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), SignalActionType (copy)
	local store = MomentContext.useMoment().store
	local v14 = useReactionEffects()
	local v15 = useFeedOptional()

	return React.useCallback(function(p1, vector2: Vector2?, p2) -- line: 41
		-- upvalues: store (copy), reactionTruthTable (copy), v15 (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), SignalActionType (copy), v14 (copy)
		local v19 = store.getSelectedReaction(false)
		local v20 = reactionTruthTable.decide(v19, p1, p2)

		if v20.action == "commit" and v20.reaction ~= nil then
			store.commitReaction(v20.reaction)
		elseif v20.action == "clear" then
			store.clearReaction()
		end

		if v15 ~= nil and v20.action ~= "none" then
			local v21 = store.getData(false)
			local v22 = if not GetFFlagMomentsAnalyticsSchemaIdentity() then v21.feedItemId else v21.feedItemIdRaw

			if v22 ~= nil and v22 ~= "" then
				local t1 = {
					itemId = v22,
					tracingId = v21.feedSessionId
				}
				local ok, result = pcall(function() -- line: 67
					-- upvalues: v20 (copy), v15 (copy), SignalActionType (copy), t1 (copy)
					if v20.action == "commit" and v20.reaction ~= nil then
						v15.logAction(SignalActionType.AddReaction, t1, {
							reactionType = v20.reaction
						})

						return
					end

					if v20.action == "clear" then
						v15.logAction(SignalActionType.RemoveReaction, t1, {})
					end
				end)

				if not ok then
					warn("Failed to log reaction action event", result)
				end
			end
		end

		if v14 ~= nil and v20.effectReaction ~= nil then
			v14.spawnExplosion(v20.effectReaction, vector2)
		end
	end, {
		store,
		v14,
		v15
	})
end

return useReactionCommit
