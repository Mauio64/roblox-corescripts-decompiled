local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
require(parent.MomentsTypes)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)
local getEmojiSets = require(script.Parent.Requests.getEmojiSets)
local decodeEmojiSets = require(script.Parent.Util.decodeEmojiSets)
local resolveMomentsEmojiCatalog = require(script.Parent.Util.resolveMomentsEmojiCatalog)
local validateMomentsEmojiCatalog = require(script.Parent.Util.validateMomentsEmojiCatalog)

local function shouldRefreshCachedEmojiSets(p): boolean
	return p == nil
end

local function createMomentsEmojiSetsStore(options)
	local v = options or {}
	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_: string, _)
			return HttpClient.asPromise(getEmojiSets(v.network)):andThen(function(p)
				if validateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(p) then
					return p
				end

				return Promise.reject("Moments emoji-api returned an invalid or empty catalog")
			end)
		end
	})

	return {
		getAndFetchEmojiSets = function()
			return dataResolver.getAndFetchItem("emoji-sets", shouldRefreshCachedEmojiSets)
		end,
		getEmojis = function(p)
			local data = dataResolver.getCachedItem("emoji-sets").data(p)
			return resolveMomentsEmojiCatalog.resolveMomentsEmojiCatalog(data).emojis
		end,
		getCachedEmojiCatalog = function(p)
			local cachedItem = dataResolver.getCachedItem("emoji-sets")
			local data = cachedItem.data(p)

			if validateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(data) then
				return {
					emojis = decodeEmojiSets.flattenEmojis(data),
					source = "cache",
					status = cachedItem.status(p)
				}
			end

			return { emojis = {}, source = "unavailable", status = cachedItem.status(p) }
		end,
		dispose = function()
			dataResolver.dispose()
		end
	}
end

return createMomentsEmojiSetsStore
