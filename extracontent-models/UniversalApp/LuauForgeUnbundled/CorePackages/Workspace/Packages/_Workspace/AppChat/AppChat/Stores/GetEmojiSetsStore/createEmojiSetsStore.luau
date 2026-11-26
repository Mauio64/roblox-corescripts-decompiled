local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local Reactions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Reactions")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("createEmojiSetsStore")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetEmojiSetsStore/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetEmojiSetsStore/decodeEmojiSets")
local emojiSetsFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetEmojiSetsStore/emojiSetsFallback")
local fetchEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetEmojiSetsStore/Requests/fetchEmojiSets")

local function indexEmojis(items)
	local v6 = { reactionTypeByEmoteId = {}, emoteIdByReactionType = {} }

	for k, item in items do
		local reactionTypeFromEmojiName = Reactions.Utils.reactionTypeFromEmojiName(item.name)

		if reactionTypeFromEmojiName == nil then
			continue
		end

		v6.reactionTypeByEmoteId[item.id] = reactionTypeFromEmojiName
		v6.emoteIdByReactionType[reactionTypeFromEmojiName] = item.id
	end

	return v6
end

local v6 = indexEmojis(emojiSetsFallback)

local function createEmojiSetsStore(options)
	local v7 = options or {}
	local dataCache = DataHydration.createDataCache()
	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		logError = function(p2)
			local v8 = if type(p2) == "table" then `{p2.responseCode} {p2.errorMessage}` else tostring(p2)
			v5:warning(`Error resolving emoji sets: {v8}`)
		end,
		fetchFn = function(p2)
			return HttpClient.asPromise(fetchEmojiSets(v7.network)):andThen(function(p3)
				local v8 = indexEmojis(p3)

				for k, v9 in Constants.PICKER_REACTION_ORDER do
					if v8.emoteIdByReactionType[v9] == nil then
						return Promise.reject(`get-emoji-sets has no emote for {v9} in the reaction picker list`)
					end
				end

				return v8
			end)
		end
	})

	local function getEmojiSets(p2)
		return dataResolver.getCachedItem("emoji-sets").data(p2) or v6
	end

	return {
		getAndFetchEmojiSets = function()
			dataResolver.getAndFetchItem("emoji-sets")
		end,
		getReactionType = function(p2, p3)
			return (dataResolver.getCachedItem("emoji-sets").data(p3) or v6).reactionTypeByEmoteId[p2]
		end,
		getEmoteId = function(p2, p3)
			return (dataResolver.getCachedItem("emoji-sets").data(p3) or v6).emoteIdByReactionType[p2]
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createEmojiSetsStore
