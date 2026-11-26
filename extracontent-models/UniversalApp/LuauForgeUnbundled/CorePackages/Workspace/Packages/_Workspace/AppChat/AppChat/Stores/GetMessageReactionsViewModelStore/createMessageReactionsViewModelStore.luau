require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Dash")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LocalUserIdStore").LocalUserIdStore
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Reactions")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local GetEmojiSetsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetEmojiSetsStore")
local applyPendingReaction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsViewModelStore/applyPendingReaction")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsStore/createMessageReactionsStore")

local v5 = {}
local v6 = {}

local function areReactorsEqual(data, item)
	local v7 = if data.reactions_page then data.reactions_page.reactors else v6
	local v8 = if item.reactions_page then item.reactions_page.reactors else v6
	local v9

	if #v7 == #v8 then
		v9 = Dash.all(v7, function(p2, p3): boolean
			local v10 = v8[p3]
			return p2.user_id == v10.user_id and p2.reacted_at == v10.reacted_at
		end)
	else
		v9 = false
	end

	return v9
end

local function areReactionListsEqual(list, list2)
	local v7

	if #list == #list2 then
		v7 = Dash.all(list, function(data, p2)
			local item = list2[p2]
			return data.emote_id == item.emote_id
				and data.count == item.count
				and data.has_user_reacted == item.has_user_reacted
				and areReactorsEqual(data, item)
		end)
	else
		v7 = false
	end

	return v7
end

local function createMessageReactionsViewModelStore(p2)
	local v7 = {}
	local v8 = {}

	return {
		getDisplayReactions = function(p3)
			local v9 = v7[p3]

			if v9 ~= nil then
				return v9
			end

			local computed = Signals.createComputed(function(p4)
				local messageReactions = p2.getMessageReactions(p3, p4)

				if messageReactions == nil then
					return v5
				end

				return applyPendingReaction(messageReactions, (tonumber(localUserIdStore.getCurrentUserId(p4))))
			end, areReactionListsEqual)

			v7[p3] = computed
			return computed
		end,
		getReactionCounts = function(p3)
			local v9 = v8[p3]

			if v9 ~= nil then
				return v9
			end

			local v10 = v7[p3]

			if v10 == nil then
				v10 = Signals.createComputed(function(p4)
					local messageReactions = p2.getMessageReactions(p3, p4)

					if messageReactions == nil then
						return v5
					end

					return applyPendingReaction(messageReactions, (tonumber(localUserIdStore.getCurrentUserId(p4))))
				end, areReactionListsEqual)

				v7[p3] = v10
			end

			local computed = Signals.createComputed(function(p4)
				local v11 = GetEmojiSetsStore(p4)
				local result = {}
				local flag = false

				for k, v12 in v10(p4) do
					local reactionType = v11.getReactionType(v12.emote_id, p4)

					if not (reactionType ~= nil and v12.count > 0) then
						continue
					end

					result[reactionType] = (result[reactionType] or 0) + v12.count
					flag = true
				end

				if flag then
					return result
				end

				return nil
			end, Dash.shallowEqual)

			v8[p3] = computed
			return computed
		end,
		evictMessages = function(items)
			for k, item in items do
				v7[item] = nil
				v8[item] = nil
			end
		end
	}
end

return createMessageReactionsViewModelStore
