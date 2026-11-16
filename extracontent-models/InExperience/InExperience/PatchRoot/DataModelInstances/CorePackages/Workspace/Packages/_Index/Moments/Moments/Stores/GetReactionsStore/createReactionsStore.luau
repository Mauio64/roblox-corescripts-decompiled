local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)
local Dash = require(parent.Dash)
local debounce = Dash.debounce

require(parent.DataHydration.MomentsStoreTypes)
local MomentsTypes = require(parent.MomentsTypes)
local ReactionAction = require(Moments.Enums.ReactionAction)
local MomentsGetMomentsReactionsStore = require(parent.DataHydration.MomentsGetMomentsReactionsStore)
local MomentsResolveEmoteId = require(parent.DataHydration.MomentsResolveEmoteId)
local FFlagMomentsReactToFeedItemV2 = require(Moments.Flags.FFlagMomentsReactToFeedItemV2)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local ReactionType = MomentsTypes.Enums.ReactionType

local v = {}

local function createReactionsStore(options)
	local v2 = options or {}
	local v3

	if v2.momentsReactionsStore == nil then
		v3 = MomentsGetMomentsReactionsStore(false)
	else
		v3 = v2.momentsReactionsStore
	end

	local debounce2 = v2.debounce or debounce

	local signal, v4 = createSignal({})
	local v5 = {}
	local v6 = {}
	local v7 = {}
	local v8 = {}

	local v9 = {}
	local v10 = {}

	local count = 0

	local function getReactions(p: string, p2) -- 4 equivalent calls inferred from this helper
		return signal(p2 or false)[p] or v
	end

	local function updateReaction(data)
		local action = data.action
		local reaction = data.reaction
		local momentId = data.momentId

		local v11 = signal(false)
		local joined = v11[momentId] or {}
		local userReaction = joined.userReaction

		if action == ReactionAction.Unreact and userReaction then
			joined = Cryo.Dictionary.join(joined, {
				[userReaction] = math.max((joined[userReaction] or 0) - 1, 0),
				userReaction = Cryo.None
			})
		end

		if action == ReactionAction.Switch and userReaction and reaction ~= nil then
			joined = Cryo.Dictionary.join(joined, {
				[userReaction] = math.max((joined[userReaction] or 0) - 1, 0),
				[reaction] = math.max((joined[reaction] or 0) + 1, 1),
				userReaction = reaction
			})
		end

		if action == ReactionAction.React and not userReaction and reaction ~= nil then
			joined = Cryo.Dictionary.join(joined, {
				[reaction] = math.max((joined[reaction] or 0) + 1, 1),
				userReaction = reaction
			})
		end

		v4((Cryo.Dictionary.union(v11, { [momentId] = joined })))
	end

	local function postReactToFeedItemV2(data)
		local v11 = v3.getEmojis == nil and {} or v3.getEmojis(false)
		local reactToFeedItemV2 = v3.reactToFeedItemV2
		assert(reactToFeedItemV2 ~= nil, "expected reactToFeedItemV2 when FFlagMomentsReactToFeedItemV2 is on")
		return reactToFeedItemV2({
			feedItemId = data.feedItemId,
			reactionType = data.reactionType,
			emoteId = MomentsResolveEmoteId.resolveEmoteIdForReaction(v11, data.reactionType),
			feedSessionId = data.feedSessionId
		})
	end

	local function postReactionRequest(p) -- 1 equivalent call inferred from this helper
		if FFlagMomentsReactToFeedItemV2 then
			return postReactToFeedItemV2(p)
		end

		return v3.reactToFeedItem(p)
	end

	local function flushSync(entityId: string, feedItemId: string, entityType: string, feedSessionId: string?)
		local v11 = v9[entityId]
		local reactionType

		if v11 ~= nil then
			reactionType = v11.reaction
		end

		local userReaction = (signal(false)[entityId] or v).userReaction

		if userReaction == reactionType then
			return
		end

		if userReaction ~= nil then
			reactionType = userReaction
		end

		v9[entityId] = { reaction = userReaction }

		local v12 = postReactionRequest({ -- inferred equivalent call
			feedItemId = feedItemId,
			entityType = entityType,
			entityId = entityId,
			reactionType = reactionType,
			feedSessionId = feedSessionId
		})

		if type(v12) == "table" and v12.catch ~= nil then
			v12:catch(function() end)
		end
	end

	local function seedSyncBaseline(entityId: string) -- 2 equivalent calls inferred from this helper
		if v9[entityId] == nil then
			v9[entityId] = {
				reaction = (signal(false)[entityId] or v).userReaction
			}
		end
	end

	local function scheduleSync(data) -- 2 equivalent calls inferred from this helper
		local entityId = data.entityId
		local v11 = v10[entityId]

		if v11 == nil then
			local v12 = count
			v11 = debounce2(function(feedItemId: string, entityType: string, feedSessionId: string?)
				if v12 ~= count then
					return
				end

				flushSync(entityId, feedItemId, entityType, feedSessionId)
			end, 0.5)
			v10[entityId] = v11
		end

		v11(data.feedItemId, data.entityType, data.feedSessionId)
	end

	return {
		getReactionsByMomentId = signal,
		getReactions = getReactions,
		getReactionsForMoment = function(p: string)
			if v5[p] == nil then
				v5[p] = createComputed(function(p2)
					return getReactions(p, p2) -- inferred equivalent call
				end)
			end

			return v5[p]
		end,
		getUserReactionForMoment = function(p: string)
			if v6[p] == nil then
				v6[p] = createComputed(function(p2)
					return getReactions(p, p2).userReaction -- inferred equivalent call
				end)
			end

			return v6[p]
		end,
		getTotalReactionCountForMoment = function(p: string)
			if v7[p] == nil then
				v7[p] = createComputed(function(p2)
					local reactions = getReactions(p, p2) -- inferred equivalent call
					local total = 0

					for _, v11 in ReactionType do
						total += reactions[v11] or 0
					end

					return total
				end)
			end

			return v7[p]
		end,
		getIndividualReactionCountsForMoment = function(p: string)
			if v8[p] == nil then
				v8[p] = createComputed(function(p2)
					local reactions = getReactions(p, p2) -- inferred equivalent call
					local result = {}

					for _, reaction2 in ReactionType do
						local reaction = reactions[reaction2]

						if reaction ~= nil and reaction > 0 then
							table.insert(result, { reaction = reaction2, count = reaction })
						end
					end

					table.sort(result, function(a, b): boolean
						if a.count == b.count then
							return a.reaction < b.reaction
						end

						return a.count > b.count
					end)

					return result
				end)
			end

			return v8[p]
		end,
		setBatchReactionCounts = function(items)
			local v11 = signal(false)
			local clone = table.clone(v11)

			for k, item in items do
				local v12 = v11[k]

				if v12 == nil or v12.userReaction == nil or item.userReaction ~= nil then
					clone[k] = item
				else
					local clone2 = table.clone(item)
					local userReaction = v12.userReaction
					clone2.userReaction = userReaction
					clone2[userReaction] = math.max(item[userReaction] or 0, v12[userReaction] or 0)
					clone[k] = clone2
				end
			end

			v4(clone)
		end,
		setReactions = function(p: string, options2)
			v4((Cryo.Dictionary.union(signal(false), {
				[p] = options2 or {}
			})))
		end,
		clear = function()
			count += 1
			table.clear(v9)
			table.clear(v10)
			v4({})
			table.clear(v5)
			table.clear(v6)
			table.clear(v7)
			table.clear(v8)
		end,
		updateReaction = updateReaction,
		reactToFeedItem = function(data): nil
			local entityId = data.entityId
			local userReaction = (signal(false)[entityId] or v).userReaction
			seedSyncBaseline(data.entityId) -- inferred equivalent call
			local action

			if userReaction == nil or userReaction == data.reactionType then
				action = ReactionAction.React
			else
				action = ReactionAction.Switch
			end

			updateReaction({
				action = action,
				momentId = data.entityId,
				reaction = data.reactionType
			})
			scheduleSync(data) -- inferred equivalent call
			return nil
		end,
		removeFeedItemReaction = function(data): nil
			seedSyncBaseline(data.entityId) -- inferred equivalent call
			updateReaction({
				action = ReactionAction.Unreact,
				momentId = data.entityId,
				reaction = data.reactionType
			})
			scheduleSync(data) -- inferred equivalent call
			return nil
		end
	}
end

return createReactionsStore
