local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Signals = require(MomentsParent.Signals)
local Cryo = require(MomentsParent.Cryo)

require(MomentsParent.DataHydration.MomentsStoreTypes)

local MomentsTypes = require(MomentsParent.MomentsTypes)
local ReactionAction = require(Moments.Enums.ReactionAction)
local MomentsGetMomentsReactionsStore = require(MomentsParent.DataHydration.MomentsGetMomentsReactionsStore)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local ReactionType = MomentsTypes.Enums.ReactionType
local t1 = {}

local function createReactionsStore(t2: {[any]: any}?) -- line: 44
	-- upvalues: MomentsGetMomentsReactionsStore (copy), createSignal (copy), t1 (copy), createComputed (copy), ReactionType (copy), Cryo (copy), ReactionAction (copy)
	local v14 = t2 or {}
	local v15 = if v14.momentsReactionsStore == nil then MomentsGetMomentsReactionsStore(false) else v14.momentsReactionsStore
	local v16, v17 = createSignal({})
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}

	local function updateReaction(p1) -- line: 159
		-- upvalues: v16 (copy), ReactionAction (copy), Cryo (copy), v17 (copy)
		local action = p1.action
		local reaction = p1.reaction
		local momentId = p1.momentId
		local v43 = v16(false)
		local v44 = v43[momentId] or {}
		local userReaction = v44.userReaction

		if action == ReactionAction.Unreact and userReaction then
			v44 = Cryo.Dictionary.join(v44, {
				[userReaction] = math.max((v44[userReaction] or 0) - 1, 0),
				userReaction = Cryo.None
			})
		end

		if action == ReactionAction.Switch and userReaction and reaction ~= nil then
			v44 = Cryo.Dictionary.join(v44, {
				[userReaction] = math.max((v44[userReaction] or 0) - 1, 0),
				[reaction] = math.max((v44[reaction] or 0) + 1, 1),
				userReaction = reaction
			})
		end

		if action == ReactionAction.React and not userReaction and reaction ~= nil then
			v44 = Cryo.Dictionary.join(v44, {
				[reaction] = math.max((v44[reaction] or 0) + 1, 1),
				userReaction = reaction
			})
		end

		v17((Cryo.Dictionary.union(v43, {
			[momentId] = v44
		})))
	end

	return {
		getReactionsByMomentId = v16,
		getReactions = function(s1: string, p2) -- line: 56
			-- upvalues: v16 (copy), t1 (copy)
			return v16(p2 or false)[s1] or t1
		end,
		getReactionsForMoment = function(s2: string) -- line: 60
			-- upvalues: t3 (copy), createComputed (copy), v16 (copy), t1 (copy)
			if t3[s2] == nil then
				t3[s2] = createComputed(function(p3) -- line: 62
					-- upvalues: s2 (copy), v16 (copy), t1 (copy)
					local v50 = s2

					return v16(p3 or false)[v50] or t1
				end)
			end

			return t3[s2]
		end,
		getUserReactionForMoment = function(s3: string) -- line: 69
			-- upvalues: t4 (copy), createComputed (copy), v16 (copy), t1 (copy)
			if t4[s3] == nil then
				t4[s3] = createComputed(function(p4) -- line: 72
					-- upvalues: s3 (copy), v16 (copy), t1 (copy)
					local v52 = s3

					return (v16(p4 or false)[v52] or t1).userReaction
				end)
			end

			return t4[s3]
		end,
		getTotalReactionCountForMoment = function(s4: string) -- line: 80
			-- upvalues: t5 (copy), createComputed (copy), v16 (copy), t1 (copy), ReactionType (copy)
			if t5[s4] == nil then
				t5[s4] = createComputed(function(p5) -- line: 82
					-- upvalues: s4 (copy), v16 (copy), t1 (copy), ReactionType (copy)
					local n1 = 0
					local v55 = s4
					local v56 = v16(p5 or false)[v55] or t1

					for _, v58 in ReactionType do
						n1 += v56[v58] or 0
					end

					return n1
				end)
			end

			return t5[s4]
		end,
		getIndividualReactionCountsForMoment = function(s5: string) -- line: 95
			-- upvalues: t6 (copy), createComputed (copy), v16 (copy), t1 (copy), ReactionType (copy)
			if t6[s5] == nil then
				t6[s5] = createComputed(function(p6) -- line: 97
					-- upvalues: s5 (copy), v16 (copy), t1 (copy), ReactionType (copy)
					local v60 = s5
					local v61 = v16(p6 or false)[v60] or t1
					local t7 = {}

					for _, v64 in ReactionType do
						local v65 = v61[v64]

						if v65 ~= nil and v65 > 0 then
							table.insert(t7, {
								reaction = v64,
								count = v65
							})
						end
					end

					table.sort(t7, function(p7, p8) -- line: 110
						if p7.count ~= p8.count then
							return p7.count > p8.count
						end

						return p7.reaction < p8.reaction
					end)

					return t7
				end)
			end

			return t6[s5]
		end,
		setBatchReactionCounts = function(p9) -- line: 124
			-- upvalues: v16 (copy), v17 (copy)
			local v30 = v16(false)
			local v31 = table.clone(v30)

			for v32, v33 in p9 do
				local v34 = v30[v32]

				if v34 ~= nil and v34.userReaction ~= nil and v33.userReaction == nil then
					local v35 = table.clone(v33)
					local userReaction = v34.userReaction

					v35.userReaction = userReaction
					v35[userReaction] = math.max(v33[userReaction] or 0, v34[userReaction] or 0)
					v31[v32] = v35
				else
					v31[v32] = v33
				end
			end

			v17(v31)
		end,
		setReactions = function(s6: string, p10) -- line: 145
			-- upvalues: v17 (copy), Cryo (copy), v16 (copy)
			v17((Cryo.Dictionary.union(v16(false), {
				[s6] = p10 or {}
			})))
		end,
		clear = function() -- line: 151
			-- upvalues: v17 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
			v17({})
			table.clear(t3)
			table.clear(t4)
			table.clear(t5)
			table.clear(t6)
		end,
		updateReaction = updateReaction,
		reactToFeedItem = function(p11) -- line: 195
			-- upvalues: v16 (copy), t1 (copy), updateReaction (copy), ReactionAction (copy), v15 (copy)
			local entityId = p11.entityId
			local userReaction = (v16(false)[entityId] or t1).userReaction

			updateReaction({
				action = if userReaction == nil or userReaction == p11.reactionType then ReactionAction.React else ReactionAction.Switch,
				momentId = p11.entityId,
				reaction = p11.reactionType
			})

			return v15.reactToFeedItem(p11)
		end
	}
end

return createReactionsStore
