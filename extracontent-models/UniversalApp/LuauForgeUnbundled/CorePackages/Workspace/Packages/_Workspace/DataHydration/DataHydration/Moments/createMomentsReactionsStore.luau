local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/reactToFeedItem")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/reactToFeedItemV2")
local createMomentsEmojiSetsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsEmojiSetsStore")
local FFlagMomentsEmojiSetsApi = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/FFlagMomentsEmojiSetsApi")
local fFlagMomentsComments = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagMomentsComments

local function createMomentsReactionsStore(options)
	local v5 = options or {}

	local function reactToFeedItem(p2)
		return HttpClient.asPromise(module3(p2, v5.network))
	end

	local function reactToFeedItemV2(p2)
		return HttpClient.asPromise(module4(p2, v5.network)):catch(function(p3)
			warn(`[Moments] Failed to react to feed item (v2): {tostring(p3)}`)
			return Promise.reject(p3)
		end)
	end

	if not (FFlagMomentsEmojiSetsApi or fFlagMomentsComments) then
		return { reactToFeedItem = reactToFeedItem }
	end

	local v6 = createMomentsEmojiSetsStore(v5)
	local v7 = {
		reactToFeedItem = reactToFeedItem,
		getAndFetchEmojiSets = v6.getAndFetchEmojiSets
	}

	if fFlagMomentsComments then
		v7.getCachedEmojiCatalog = v6.getCachedEmojiCatalog
	end

	if FFlagMomentsEmojiSetsApi then
		v7.reactToFeedItemV2 = reactToFeedItemV2

		v7.getEmojis = v6.getEmojis
	end

	return v7
end

return createMomentsReactionsStore
