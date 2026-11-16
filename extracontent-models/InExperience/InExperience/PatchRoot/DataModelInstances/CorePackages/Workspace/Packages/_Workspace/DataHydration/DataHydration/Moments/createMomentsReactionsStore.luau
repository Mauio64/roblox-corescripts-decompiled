local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
require(parent.MomentsTypes)
require(script.Parent.MomentsStoreTypes)
local reactToFeedItem = require(script.Parent.Requests.reactToFeedItem)
local reactToFeedItemV2 = require(script.Parent.Requests.reactToFeedItemV2)
local createMomentsEmojiSetsStore = require(script.Parent.createMomentsEmojiSetsStore)
local FFlagMomentsEmojiSetsApi = require(script.Parent.FFlagMomentsEmojiSetsApi)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments

local function createMomentsReactionsStore(options)
	local v = options or {}

	local function reactToFeedItem2(p)
		return HttpClient.asPromise(reactToFeedItem(p, v.network))
	end

	local function reactToFeedItemV2_2(p)
		return HttpClient.asPromise(reactToFeedItemV2(p, v.network)):catch(function(p2)
			warn(`[Moments] Failed to react to feed item (v2): {tostring(p2)}`)
			return Promise.reject(p2)
		end)
	end

	if not (FFlagMomentsEmojiSetsApi or FFlagMomentsComments) then
		return { reactToFeedItem = reactToFeedItem2 }
	end

	local momentsEmojiSetsStore = createMomentsEmojiSetsStore(v)
	local v2 = {
		reactToFeedItem = reactToFeedItem2,
		getAndFetchEmojiSets = momentsEmojiSetsStore.getAndFetchEmojiSets
	}

	if FFlagMomentsComments then
		v2.getCachedEmojiCatalog = momentsEmojiSetsStore.getCachedEmojiCatalog
	end

	if FFlagMomentsEmojiSetsApi then
		v2.reactToFeedItemV2 = reactToFeedItemV2_2

		v2.getEmojis = momentsEmojiSetsStore.getEmojis
	end

	return v2
end

return createMomentsReactionsStore
