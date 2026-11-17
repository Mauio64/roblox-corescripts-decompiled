local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local Reactions = require(parent.Reactions)
require(parent.Signals)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local Constants = require(script.Parent.Constants)
require(script.Parent.decodeEmojiSets)
local emojiSetsFallback = require(script.Parent.emojiSetsFallback)
local fetchEmojiSets = require(script.Parent.Requests.fetchEmojiSets)

local function indexEmojis(items)
	local v2 = { reactionTypeByEmoteId = {}, emoteIdByReactionType = {} }

	for _, item in items do
		local reactionTypeFromEmojiName = Reactions.Utils.reactionTypeFromEmojiName(item.name)

		if reactionTypeFromEmojiName == nil then
			continue
		end

		v2.reactionTypeByEmoteId[item.id] = reactionTypeFromEmojiName
		v2.emoteIdByReactionType[reactionTypeFromEmojiName] = item.id
	end

	return v2
end

local v2 = indexEmojis(emojiSetsFallback)

local function createEmojiSetsStore(options)
	local v3 = options or {}
	local dataCache = DataHydration.createDataCache()
	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		logError = function(p)
			local v4

			if type(p) == "table" then
				v4 = `{p.responseCode} {p.errorMessage}`
			else
				v4 = tostring(p)
			end

			v:warning(`Error resolving emoji sets: {v4}`)
		end,
		fetchFn = function(_: string)
			return HttpClient.asPromise(fetchEmojiSets(v3.network)):andThen(function(p)
				local v4 = indexEmojis(p)

				for _, v5 in Constants.PICKER_REACTION_ORDER do
					if v4.emoteIdByReactionType[v5] == nil then
						return Promise.reject(`get-emoji-sets has no emote for {v5} in the reaction picker list`)
					end
				end

				return v4
			end)
		end
	})

	local function getEmojiSets(p) -- 2 equivalent calls inferred from this helper
		return dataResolver.getCachedItem("emoji-sets").data(p) or v2
	end

	return {
		getAndFetchEmojiSets = function()
			dataResolver.getAndFetchItem("emoji-sets")
		end,
		getReactionType = function(p: string, p2)
			return getEmojiSets(p2).reactionTypeByEmoteId[p] -- inferred equivalent call
		end,
		getEmoteId = function(p, p2)
			return getEmojiSets(p2).emoteIdByReactionType[p] -- inferred equivalent call
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createEmojiSetsStore
