local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local DataHydration = require(parent.DataHydration)
require(script.Parent.ContentReactionsStoreTypes)

local function areReactionsEqual(data, data2): boolean -- 1 equivalent call inferred from this helper
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
		if not areReactionsEqual(item, list[k]) then -- inferred equivalent call
			return false
		end
	end

	return true
end

local function isSettledOnServer(serverReactions, reaction): boolean -- 1 equivalent call inferred from this helper
	for _, item in serverReactions do
		if item.emoteId == reaction.emoteId then
			return item.hasUserAppliedReaction == reaction.hasUserAppliedReaction
		end
	end

	return not reaction.hasUserAppliedReaction
end

local function reconcile(p, serverReactions)
	if p == nil then
		return { serverReactions = serverReactions, emotes = {} }
	end

	if areReactionListsEqual(p.serverReactions, serverReactions) then
		return p
	end

	local emotes = {}

	for k, emote in p.emotes do
		if emote.isPending then
			emotes[k] = {
				reaction = emote.reaction,
				restore = nil,
				isPending = true,
				addedAt = emote.addedAt
			}
		end
	end

	return { serverReactions = serverReactions, emotes = emotes }
end

local function resolve(p)
	local emoteIdSet = {}
	local reactions = {}

	for _, reaction in p.serverReactions do
		emoteIdSet[reaction.emoteId] = true
		local emote = p.emotes[reaction.emoteId]

		if emote then
			reaction = emote.reaction
		end

		table.insert(reactions, reaction)
	end

	local emotes = {}

	for k, emote in p.emotes do
		if emoteIdSet[k] or not emote.reaction.hasUserAppliedReaction then
			continue
		end

		table.insert(emotes, emote)
	end

	table.sort(emotes, function(a, b): boolean
		return a.addedAt < b.addedAt
	end)

	for _, v in emotes do
		table.insert(reactions, v.reaction)
	end

	return reactions
end

local function getNextAddedAt(items)
	local maxValue = 1

	for _, item in items do
		maxValue = math.max(maxValue, item.addedAt + 1)
	end

	return maxValue
end

local function applyReaction(p, restore, reaction)
	local emoteId = reaction.emoteId
	local emote = p.emotes[emoteId]
	local clone = table.clone(p.emotes)
	local v = { reaction = reaction, restore = restore, isPending = true, addedAt = 0 }
	local addedAt

	if emote then
		addedAt = emote.addedAt
	else
		addedAt = 1

		for _, emote2 in p.emotes do
			addedAt = math.max(addedAt, emote2.addedAt + 1)
		end
	end

	v.addedAt = addedAt
	clone[emoteId] = v

	return { serverReactions = p.serverReactions, emotes = clone }
end

local function settleReaction(storedReactions, p: string, flag: boolean)
	local emote = storedReactions.emotes[p]

	if emote == nil or not emote.isPending then
		return storedReactions
	end

	local reaction = if flag then emote.reaction else emote.restore

	if flag and emote.restore == nil and isSettledOnServer(storedReactions.serverReactions, emote.reaction) then -- inferred equivalent call
		reaction = nil
	end

	local clone = table.clone(storedReactions.emotes)

	if reaction then
		clone[p] = {
			reaction = reaction,
			restore = nil,
			isPending = false,
			addedAt = emote.addedAt
		}
	else
		clone[p] = nil
	end

	return { serverReactions = storedReactions.serverReactions, emotes = clone }
end

local function createContentReactionsStore()
	local dataCache = DataHydration.createDataCache()

	local function getContentReactions(p: string) -- 1 equivalent call inferred from this helper
		return (dataCache.getItem(p))
	end

	local function getStoredReactions(p: string) -- 5 equivalent calls inferred from this helper
		return getContentReactions(p).data(false) -- inferred equivalent call
	end

	local function settle(p: string, emoteId: string, flag: boolean) -- 2 equivalent calls inferred from this helper
		local storedReactions = getStoredReactions(p) -- inferred equivalent call

		if storedReactions then
			dataCache.replaceItem(p, settleReaction(storedReactions, emoteId, flag))
		end
	end

	return {
		getContentReactions = getContentReactions,
		getReactions = function(p: string, serverReactions)
			local storedReactions = getStoredReactions(p) -- inferred equivalent call

			if storedReactions == nil then
				return serverReactions
			end

			return resolve(reconcile(storedReactions, serverReactions))
		end,
		isReactionPending = function(p: string, p2: string)
			local storedReactions = getStoredReactions(p) -- inferred equivalent call
			local v

			if storedReactions then
				v = storedReactions.emotes[p2]
			end

			return v ~= nil and v.isPending
		end,
		reconcileReactions = function(p: string, serverReactions)
			local storedReactions = getStoredReactions(p) -- inferred equivalent call

			if storedReactions then
				local v = reconcile(storedReactions, serverReactions)

				if v ~= storedReactions then
					dataCache.replaceItem(p, v)
				end
			end
		end,
		updateReaction = function(p: string, serverReactions, restore, reaction, object)
			local emoteId = reaction.emoteId
			dataCache.replaceItem(
				p,
				applyReaction(reconcile(getStoredReactions(p), serverReactions), restore, reaction) -- inferred equivalent call
			)

			object:andThen(function()
				settle(p, emoteId, true) -- inferred equivalent call
			end, function()
				settle(p, emoteId, false) -- inferred equivalent call
			end)
		end,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createContentReactionsStore
