local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Signals = require(MomentsParent.Signals)
local Cryo = require(MomentsParent.Cryo)

require(MomentsParent.DataHydration.MomentsStoreTypes)

local MomentsTypes = require(MomentsParent.MomentsTypes)
local ReactionAction = require(Moments.Enums.ReactionAction)
local MomentsGetMomentsReactionsStore = require(MomentsParent.DataHydration.MomentsGetMomentsReactionsStore)
local MomentsResolveEmoteId = require(MomentsParent.DataHydration.MomentsResolveEmoteId)
local FFlagMomentsReactToFeedItemV2 = require(Moments.Flags.FFlagMomentsReactToFeedItemV2)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local ReactionType = MomentsTypes.Enums.ReactionType
local t1 = {}

local function createReactionsStore(t2: {[any]: any}?) -- line: 47
	-- upvalues: MomentsGetMomentsReactionsStore (copy), createSignal (copy), t1 (copy), createComputed (copy), ReactionType (copy), Cryo (copy), ReactionAction (copy), MomentsResolveEmoteId (copy), FFlagMomentsReactToFeedItemV2 (copy)
	local v16 = t2 or {}
	local v17 = if v16.momentsReactionsStore == nil then MomentsGetMomentsReactionsStore(false) else v16.momentsReactionsStore
	local v18, v19 = createSignal({})
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}

	local function updateReaction(p1) -- line: 162
		-- upvalues: v18 (copy), ReactionAction (copy), Cryo (copy), v19 (copy)
		local action = p1.action
		local reaction = p1.reaction
		local momentId = p1.momentId
		local v46 = v18(false)
		local v47 = v46[momentId] or {}
		local userReaction = v47.userReaction

		if action == ReactionAction.Unreact and userReaction then
			v47 = Cryo.Dictionary.join(v47, {
				[userReaction] = math.max((v47[userReaction] or 0) - 1, 0),
				userReaction = Cryo.None
			})
		end

		if action == ReactionAction.Switch and userReaction and reaction ~= nil then
			v47 = Cryo.Dictionary.join(v47, {
				[userReaction] = math.max((v47[userReaction] or 0) - 1, 0),
				[reaction] = math.max((v47[reaction] or 0) + 1, 1),
				userReaction = reaction
			})
		end

		if action == ReactionAction.React and not userReaction and reaction ~= nil then
			v47 = Cryo.Dictionary.join(v47, {
				[reaction] = math.max((v47[reaction] or 0) + 1, 1),
				userReaction = reaction
			})
		end

		v19((Cryo.Dictionary.union(v46, {
			[momentId] = v47
		})))
	end
	local function postReactToFeedItemV2(p2) -- line: 198
		-- upvalues: v17 (copy), MomentsResolveEmoteId (copy)
		local v50 = if v17.getEmojis == nil then {} else v17.getEmojis(false)
		local reactToFeedItemV2 = v17.reactToFeedItemV2

		assert(reactToFeedItemV2 ~= nil, "expected reactToFeedItemV2 when FFlagMomentsReactToFeedItemV2 is on")

		return reactToFeedItemV2({
			feedItemId = p2.feedItemId,
			reactionType = p2.reactionType,
			emoteId = MomentsResolveEmoteId.resolveEmoteIdForReaction(v50, p2.reactionType),
			feedSessionId = p2.feedSessionId
		})
	end

	return {
		getReactionsByMomentId = v18,
		getReactions = function(s1: string, p3) -- line: 59
			-- upvalues: v18 (copy), t1 (copy)
			return v18(p3 or false)[s1] or t1
		end,
		getReactionsForMoment = function(s2: string) -- line: 63
			-- upvalues: t3 (copy), createComputed (copy), v18 (copy), t1 (copy)
			if t3[s2] == nil then
				t3[s2] = createComputed(function(p4) -- line: 65
					-- upvalues: s2 (copy), v18 (copy), t1 (copy)
					local v57 = s2

					return v18(p4 or false)[v57] or t1
				end)
			end

			return t3[s2]
		end,
		getUserReactionForMoment = function(s3: string) -- line: 72
			-- upvalues: t4 (copy), createComputed (copy), v18 (copy), t1 (copy)
			if t4[s3] == nil then
				t4[s3] = createComputed(function(p5) -- line: 75
					-- upvalues: s3 (copy), v18 (copy), t1 (copy)
					local v59 = s3

					return (v18(p5 or false)[v59] or t1).userReaction
				end)
			end

			return t4[s3]
		end,
		getTotalReactionCountForMoment = function(s4: string) -- line: 83
			-- upvalues: t5 (copy), createComputed (copy), v18 (copy), t1 (copy), ReactionType (copy)
			if t5[s4] == nil then
				t5[s4] = createComputed(function(p6) -- line: 85
					-- upvalues: s4 (copy), v18 (copy), t1 (copy), ReactionType (copy)
					local n1 = 0
					local v62 = s4
					local v63 = v18(p6 or false)[v62] or t1

					for _, v65 in ReactionType do
						n1 += v63[v65] or 0
					end

					return n1
				end)
			end

			return t5[s4]
		end,
		getIndividualReactionCountsForMoment = function(s5: string) -- line: 98
			-- upvalues: t6 (copy), createComputed (copy), v18 (copy), t1 (copy), ReactionType (copy)
			if t6[s5] == nil then
				t6[s5] = createComputed(function(p7) -- line: 100
					-- upvalues: s5 (copy), v18 (copy), t1 (copy), ReactionType (copy)
					local v67 = s5
					local v68 = v18(p7 or false)[v67] or t1
					local t7 = {}

					for _, v71 in ReactionType do
						local v72 = v68[v71]

						if v72 ~= nil and v72 > 0 then
							table.insert(t7, {
								reaction = v71,
								count = v72
							})
						end
					end

					table.sort(t7, function(p8, p9) -- line: 113
						if p8.count ~= p9.count then
							return p8.count > p9.count
						end

						return p8.reaction < p9.reaction
					end)

					return t7
				end)
			end

			return t6[s5]
		end,
		setBatchReactionCounts = function(p10) -- line: 127
			-- upvalues: v18 (copy), v19 (copy)
			local v33 = v18(false)
			local v34 = table.clone(v33)

			for v35, v36 in p10 do
				local v37 = v33[v35]

				if v37 ~= nil and v37.userReaction ~= nil and v36.userReaction == nil then
					local v38 = table.clone(v36)
					local userReaction = v37.userReaction

					v38.userReaction = userReaction
					v38[userReaction] = math.max(v36[userReaction] or 0, v37[userReaction] or 0)
					v34[v35] = v38
				else
					v34[v35] = v36
				end
			end

			v19(v34)
		end,
		setReactions = function(s6: string, p11) -- line: 148
			-- upvalues: v19 (copy), Cryo (copy), v18 (copy)
			v19((Cryo.Dictionary.union(v18(false), {
				[s6] = p11 or {}
			})))
		end,
		clear = function() -- line: 154
			-- upvalues: v19 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
			v19({})
			table.clear(t3)
			table.clear(t4)
			table.clear(t5)
			table.clear(t6)
		end,
		updateReaction = updateReaction,
		reactToFeedItem = function(p12) -- line: 210
			-- upvalues: v18 (copy), t1 (copy), updateReaction (copy), ReactionAction (copy), FFlagMomentsReactToFeedItemV2 (copy), postReactToFeedItemV2 (copy), v17 (copy)
			local entityId = p12.entityId
			local userReaction = (v18(false)[entityId] or t1).userReaction

			updateReaction({
				action = if userReaction == nil or userReaction == p12.reactionType then ReactionAction.React else ReactionAction.Switch,
				momentId = p12.entityId,
				reaction = p12.reactionType
			})

			if FFlagMomentsReactToFeedItemV2 then
				return postReactToFeedItemV2(p12)
			end

			return v17.reactToFeedItem(p12)
		end,
		removeFeedItemReaction = function(p13) -- line: 226
			-- upvalues: updateReaction (copy), ReactionAction (copy), FFlagMomentsReactToFeedItemV2 (copy), postReactToFeedItemV2 (copy)
			updateReaction({
				action = ReactionAction.Unreact,
				momentId = p13.entityId,
				reaction = p13.reactionType
			})

			if FFlagMomentsReactToFeedItemV2 then
				return postReactToFeedItemV2(p13)
			end

			return nil
		end
	}
end

return createReactionsStore
