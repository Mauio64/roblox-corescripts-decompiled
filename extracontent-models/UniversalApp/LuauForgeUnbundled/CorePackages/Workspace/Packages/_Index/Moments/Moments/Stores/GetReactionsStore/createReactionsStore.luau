local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Cryo")
local debounce = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Dash").debounce

require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local ReactionAction = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/ReactionAction")
local MomentsGetMomentsReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsReactionsStore")
local MomentsResolveEmoteId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsResolveEmoteId")
local FFlagMomentsReactToFeedItemV2 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsReactToFeedItemV2")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local reactionType = MomentsTypes.Enums.ReactionType

local v5 = {}

local function createReactionsStore(options)
	local v6 = options or {}
	local v7 = if v6.momentsReactionsStore == nil then MomentsGetMomentsReactionsStore(false) else v6.momentsReactionsStore
	local debounce2 = v6.debounce or debounce

	local signal, v8 = createSignal({})
	local v9 = {}
	local v10 = {}
	local v11 = {}
	local v12 = {}

	local v13 = {}
	local v14 = {}

	local count = 0

	local function updateReaction(data)
		local action = data.action
		local reaction = data.reaction
		local momentId = data.momentId

		local v15 = signal(false)
		local joined = v15[momentId] or {}
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

		v8(Cryo.Dictionary.union(v15, { [momentId] = joined }))
	end

	local function postReactToFeedItemV2(data)
		local v15 = v7.getEmojis == nil and {} or v7.getEmojis(false)
		local reactToFeedItemV2 = v7.reactToFeedItemV2
		assert(
			reactToFeedItemV2 ~= nil,
			"expected reactToFeedItemV2 when FFlagMomentsReactToFeedItemV2 is on"
		)
		return reactToFeedItemV2({
			feedItemId = data.feedItemId,
			reactionType = data.reactionType,
			emoteId = MomentsResolveEmoteId.resolveEmoteIdForReaction(v15, data.reactionType),
			feedSessionId = data.feedSessionId
		})
	end

	local function postReactionRequest(p2)
		if FFlagMomentsReactToFeedItemV2 then
			return postReactToFeedItemV2(p2)
		end

		return v7.reactToFeedItem(p2)
	end

	local function flushSync(entityId, p2, p3, p4)
		local v15 = v13[entityId]
		local v16 = if v15 ~= nil then v15.reaction else nil
		local userReaction = (signal(false)[entityId] or v5).userReaction

		if userReaction == v16 then
			return
		end

		if userReaction ~= nil then
			v16 = userReaction
		end

		v13[entityId] = { reaction = userReaction }

		local v17 = {
			feedItemId = p2,
			entityType = p3,
			entityId = entityId,
			reactionType = v16,
			feedSessionId = p4
		}
		local v18 = if FFlagMomentsReactToFeedItemV2 then postReactToFeedItemV2(v17) else v7.reactToFeedItem(v17)

		if type(v18) == "table" and v18.catch ~= nil then
			v18:catch(function() end)
		end
	end

	local function seedSyncBaseline(p2)
		if v13[p2] == nil then
			v13[p2] = {
				reaction = (signal(false)[p2] or v5).userReaction
			}
		end
	end

	local function scheduleSync(data)
		local entityId = data.entityId
		local v15 = v14[entityId]

		if v15 == nil then
			local v16 = count
			v15 = debounce2(function(p2, p3, p4)
				if v16 ~= count then
					return
				end

				flushSync(entityId, p2, p3, p4)
			end, 0.5)
			v14[entityId] = v15
		end

		v15(data.feedItemId, data.entityType, data.feedSessionId)
	end

	return {
		getReactionsByMomentId = signal,
		getReactions = function(p2, p3)
			return signal(p3 or false)[p2] or v5
		end,
		getReactionsForMoment = function(p2)
			if v9[p2] == nil then
				v9[p2] = createComputed(function(p3)
					return signal(p3 or false)[p2] or v5
				end)
			end

			return v9[p2]
		end,
		getUserReactionForMoment = function(p2)
			if v10[p2] == nil then
				v10[p2] = createComputed(function(p3)
					return (signal(p3 or false)[p2] or v5).userReaction
				end)
			end

			return v10[p2]
		end,
		getTotalReactionCountForMoment = function(p2)
			if v11[p2] == nil then
				v11[p2] = createComputed(function(p3)
					local v16 = signal(p3 or false)[p2] or v5
					local total = 0

					for k, v17 in reactionType do
						total += v16[v17] or 0
					end

					return total
				end)
			end

			return v11[p2]
		end,
		getIndividualReactionCountsForMoment = function(p2)
			if v12[p2] == nil then
				v12[p2] = createComputed(function(p3)
					local v16 = signal(p3 or false)[p2] or v5

					local result = {}

					for k, v17 in reactionType do
						local v18 = v16[v17]

						if v18 ~= nil and v18 > 0 then
							table.insert(result, { reaction = v17, count = v18 })
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

			return v12[p2]
		end,
		setBatchReactionCounts = function(items)
			local v15 = signal(false)
			local clone = table.clone(v15)

			for k, item in items do
				local v16 = v15[k]

				if v16 == nil or v16.userReaction == nil or item.userReaction ~= nil then
					clone[k] = item
				else
					local clone2 = table.clone(item)
					local userReaction = v16.userReaction
					clone2.userReaction = userReaction
					clone2[userReaction] = math.max(item[userReaction] or 0, v16[userReaction] or 0)
					clone[k] = clone2
				end
			end

			v8(clone)
		end,
		setReactions = function(p2, options2)
			v8(Cryo.Dictionary.union(signal(false), {
				[p2] = options2 or {}
			}))
		end,
		clear = function()
			count += 1
			table.clear(v13)
			table.clear(v14)
			v8({})
			table.clear(v9)
			table.clear(v10)
			table.clear(v11)
			table.clear(v12)
		end,
		updateReaction = updateReaction,
		reactToFeedItem = function(data): nil
			local entityId = data.entityId
			local userReaction = (signal(false)[entityId] or v5).userReaction
			local entityId2 = data.entityId

			if v13[entityId2] == nil then
				v13[entityId2] = {
					reaction = (signal(false)[entityId2] or v5).userReaction
				}
			end

			local v17 = if userReaction == nil or userReaction == data.reactionType then ReactionAction.React else ReactionAction.Switch
			updateReaction({
				action = v17,
				momentId = data.entityId,
				reaction = data.reactionType
			})
			local entityId3 = data.entityId
			local v18 = v14[entityId3]

			if v18 == nil then
				local v19 = count
				v18 = debounce2(function(p2, p3, p4)
					if v19 ~= count then
						return
					end

					flushSync(entityId3, p2, p3, p4)
				end, 0.5)
				v14[entityId3] = v18
			end

			v18(data.feedItemId, data.entityType, data.feedSessionId)

			return nil
		end,
		removeFeedItemReaction = function(data): nil
			local entityId = data.entityId

			if v13[entityId] == nil then
				v13[entityId] = {
					reaction = (signal(false)[entityId] or v5).userReaction
				}
			end

			updateReaction({
				action = ReactionAction.Unreact,
				momentId = data.entityId,
				reaction = data.reactionType
			})
			local entityId2 = data.entityId
			local v15 = v14[entityId2]

			if v15 == nil then
				local v16 = count
				v15 = debounce2(function(p2, p3, p4)
					if v16 ~= count then
						return
					end

					flushSync(entityId2, p2, p3, p4)
				end, 0.5)
				v14[entityId2] = v15
			end

			v15(data.feedItemId, data.entityType, data.feedSessionId)

			return nil
		end
	}
end

return createReactionsStore
