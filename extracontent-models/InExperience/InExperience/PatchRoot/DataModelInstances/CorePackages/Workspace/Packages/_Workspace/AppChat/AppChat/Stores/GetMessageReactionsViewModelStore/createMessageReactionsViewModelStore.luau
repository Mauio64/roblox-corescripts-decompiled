local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.AppChatNetworking)
local Dash = require(parent.Dash)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
require(parent.Reactions)
local Signals = require(parent.Signals)

local GetEmojiSetsStore = require(AppChat.Stores.GetEmojiSetsStore)
local applyPendingReaction = require(script.Parent.applyPendingReaction)
require(script.Parent.Parent.GetMessageReactionsStore.createMessageReactionsStore)

local v = {}
local v2 = {}

local function areReactorsEqual(data, item)
	local v3

	if data.reactions_page then
		v3 = data.reactions_page.reactors
	else
		v3 = v2
	end

	local v4

	if item.reactions_page then
		v4 = item.reactions_page.reactors
	else
		v4 = v2
	end

	if #v3 == #v4 then
		return (Dash.all(v3, function(p, p2: number): boolean
			local v5 = v4[p2]
			return p.user_id == v5.user_id and p.reacted_at == v5.reacted_at
		end))
	end

	return false
end

local function areReactionListsEqual(list, list2)
	if #list == #list2 then
		return (Dash.all(list, function(data, p: number)
			local item = list2[p]
			return data.emote_id == item.emote_id
				and data.count == item.count
				and data.has_user_reacted == item.has_user_reacted
				and areReactorsEqual(data, item)
		end))
	end

	return false
end

local function createMessageReactionsViewModelStore(p)
	local v3 = {}
	local v4 = {}

	return {
		getDisplayReactions = function(p2: string)
			local v5 = v3[p2]

			if v5 ~= nil then
				return v5
			end

			local computed = Signals.createComputed(function(p3)
				local messageReactions = p.getMessageReactions(p2, p3)

				if messageReactions == nil then
					return v
				end

				return applyPendingReaction(messageReactions, (tonumber(localUserIdStore.getCurrentUserId(p3))))
			end, areReactionListsEqual)

			v3[p2] = computed
			return computed
		end,
		getReactionCounts = function(p2: string)
			local v5 = v4[p2]

			if v5 ~= nil then
				return v5
			end

			local v6 = v3[p2]

			if v6 == nil then
				v6 = Signals.createComputed(function(p3)
					local messageReactions = p.getMessageReactions(p2, p3)

					if messageReactions == nil then
						return v
					end

					return applyPendingReaction(messageReactions, (tonumber(localUserIdStore.getCurrentUserId(p3))))
				end, areReactionListsEqual)

				v3[p2] = v6
			end

			local computed = Signals.createComputed(function(p3)
				local emojiSetsStore = GetEmojiSetsStore(p3)
				local result = {}
				local flag = false

				for _, v7 in v6(p3) do
					local reactionType = emojiSetsStore.getReactionType(v7.emote_id, p3)

					if not (reactionType ~= nil and v7.count > 0) then
						continue
					end

					result[reactionType] = (result[reactionType] or 0) + v7.count
					flag = true
				end

				return if flag then result else nil
			end, Dash.shallowEqual)

			v4[p2] = computed
			return computed
		end,
		evictMessages = function(items)
			for _, item in items do
				v3[item] = nil
				v4[item] = nil
			end
		end
	}
end

return createMessageReactionsViewModelStore
