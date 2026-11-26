local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local getEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/getEmojiSets")
local decodeEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/decodeEmojiSets")
local resolveMomentsEmojiCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/resolveMomentsEmojiCatalog")
local validateMomentsEmojiCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/validateMomentsEmojiCatalog")

local function shouldRefreshCachedEmojiSets(p2): boolean
	return p2 == nil
end

local function createMomentsEmojiSetsStore(options)
	local v5 = options or {}
	local v7 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return HttpClient.asPromise(getEmojiSets(v5.network)):andThen(function(p4)
				if validateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(p4) then
					return p4
				end

				return Promise.reject("Moments emoji-api returned an invalid or empty catalog")
			end)
		end
	})

	return {
		getAndFetchEmojiSets = function()
			return v7.getAndFetchItem("emoji-sets", shouldRefreshCachedEmojiSets)
		end,
		getEmojis = function(p2)
			local data = v7.getCachedItem("emoji-sets").data(p2)
			return resolveMomentsEmojiCatalog.resolveMomentsEmojiCatalog(data).emojis
		end,
		getCachedEmojiCatalog = function(p2)
			local cachedItem = v7.getCachedItem("emoji-sets")
			local data = cachedItem.data(p2)

			if validateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(data) then
				return {
					emojis = decodeEmojiSets.flattenEmojis(data),
					source = "cache",
					status = cachedItem.status(p2)
				}
			end

			return {
				emojis = {},
				source = "unavailable",
				status = cachedItem.status(p2)
			}
		end,
		dispose = function()
			v7.dispose()
		end
	}
end

return createMomentsEmojiSetsStore
