local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Stores/ContentReactionsStoreTypes")

local function areReactionsEqual(data, data2): boolean
	return data.emoteId == data2.emoteId
		and data.reactionType == data2.reactionType
		and data.reactionCount == data2.reactionCount
		and data.hasUserAppliedReaction == data2.hasUserAppliedReaction
end

local function areReactionListsEqual(serverReactions, list): boolean
	if #serverReactions ~= #list then
		return false
	end

	for k, item in serverReactions do
		local item2 = list[k]
		local v5

		if
			item.emoteId == item2.emoteId
			and item.reactionType == item2.reactionType
			and item.reactionCount == item2.reactionCount
		then
			v5 = item.hasUserAppliedReaction == item2.hasUserAppliedReaction
		else
			v5 = false
		end

		if not v5 then
			return false
		end
	end

	return true
end

local function isSettledOnServer(items, p2): boolean
	for k, item in items do
		if item.emoteId == p2.emoteId then
			return item.hasUserAppliedReaction == p2.hasUserAppliedReaction
		end
	end

	return not p2.hasUserAppliedReaction
end

local function reconcile(p2, p3)
	if p2 == nil then
		return { serverReactions = p3, emotes = {} }
	end

	if areReactionListsEqual(p2.serverReactions, p3) then
		return p2
	end

	local v5 = {}

	for k, emote in p2.emotes do
		if emote.isPending then
			v5[k] = {
				reaction = emote.reaction,
				restore = nil,
				isPending = true,
				addedAt = emote.addedAt
			}
		end
	end

	return { serverReactions = p3, emotes = v5 }
end

local function resolve(p2)
	local emoteIdSet = {}
	local reactions = {}

	for k, reaction in p2.serverReactions do
		emoteIdSet[reaction.emoteId] = true
		local emote = p2.emotes[reaction.emoteId]

		if emote then
			reaction = emote.reaction
		end

		table.insert(reactions, reaction)
	end

	local emotes = {}

	for k, emote in p2.emotes do
		if emoteIdSet[k] or not emote.reaction.hasUserAppliedReaction then
			continue
		end

		table.insert(emotes, emote)
	end

	table.sort(emotes, function(a, b): boolean
		return a.addedAt < b.addedAt
	end)

	for k, v5 in emotes do
		table.insert(reactions, v5.reaction)
	end

	return reactions
end

local function getNextAddedAt(items)
	local maxValue = 1

	for k, item in items do
		maxValue = math.max(maxValue, item.addedAt + 1)
	end

	return maxValue
end

local function applyReaction(p2, p3, p4)
	local emoteId = p4.emoteId
	local emote = p2.emotes[emoteId]
	local clone = table.clone(p2.emotes)
	local v5 = { reaction = p4, restore = p3, isPending = true, addedAt = 0 }
	local v6

	if emote then
		v6 = emote.addedAt
	else
		v6 = 1

		for k, emote2 in p2.emotes do
			v6 = math.max(v6, emote2.addedAt + 1)
		end
	end

	v5.addedAt = v6
	clone[emoteId] = v5

	return { serverReactions = p2.serverReactions, emotes = clone }
end

local function settleReaction(data, p2, p3)
	local emote = data.emotes[p2]

	if emote == nil or not emote.isPending then
		return data
	end

	local v5 = if p3 then emote.reaction else emote.restore

	if p3 and emote.restore == nil then
		local serverReactions = data.serverReactions
		local reaction = emote.reaction
		local flag = true
		local v6

		for k, serverReaction in serverReactions do
			if serverReaction.emoteId == reaction.emoteId then
				v6 = serverReaction.hasUserAppliedReaction == reaction.hasUserAppliedReaction
				flag = false
				break
			end
		end

		if flag then
			v6 = not reaction.hasUserAppliedReaction
		end

		if v6 then
			v5 = nil
		end
	end

	local clone = table.clone(data.emotes)

	if v5 then
		clone[p2] = {
			reaction = v5,
			restore = nil,
			isPending = false,
			addedAt = emote.addedAt
		}
	else
		clone[p2] = nil
	end

	return { serverReactions = data.serverReactions, emotes = clone }
end

local function createContentReactionsStore()
	local dataCache = DataHydration.createDataCache()

	local function getStoredReactions(p2)
		return dataCache.getItem(p2).data(false)
	end

	local function settle(p2, p3, p4)
		local data = dataCache.getItem(p2).data(false)

		if data then
			dataCache.replaceItem(p2, settleReaction(data, p3, p4))
		end
	end

	return {
		getContentReactions = function(p2)
			return (dataCache.getItem(p2))
		end,
		getReactions = function(p2, p3)
			local data = dataCache.getItem(p2).data(false)

			if data == nil then
				return p3
			end

			return resolve(reconcile(data, p3))
		end,
		isReactionPending = function(p2, p3)
			local data = dataCache.getItem(p2).data(false)

			local v5 = if data then data.emotes[p3] else nil
			return v5 ~= nil and v5.isPending
		end,
		reconcileReactions = function(p2, p3)
			local data = dataCache.getItem(p2).data(false)

			if data then
				local v5 = reconcile(data, p3)

				if v5 ~= data then
					dataCache.replaceItem(p2, v5)
				end
			end
		end,
		updateReaction = function(p2, p3, p4, p5, object)
			local emoteId = p5.emoteId
			dataCache.replaceItem(
				p2,
				applyReaction(reconcile(dataCache.getItem(p2).data(false), p3), p4, p5)
			)

			object:andThen(function()
				local v5 = p2
				local v6 = emoteId
				local data = dataCache.getItem(v5).data(false)

				if data then
					dataCache.replaceItem(v5, settleReaction(data, v6, true))
				end
			end, function()
				local v5 = p2
				local v6 = emoteId
				local data = dataCache.getItem(v5).data(false)

				if data then
					dataCache.replaceItem(v5, settleReaction(data, v6, false))
				end
			end)
		end,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createContentReactionsStore
