local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)

require(DataHydrationParent.MomentsTypes)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)

local getEmojiSets = require(script.Parent.Requests.getEmojiSets)
local decodeEmojiSets = require(script.Parent.Util.decodeEmojiSets)
local hardcodedMomentsEmojis = require(script.Parent.Util.hardcodedMomentsEmojis)

local function shouldRefreshCachedEmojiSets(p1) -- line: 24
	return p1 == nil
end
local function createMomentsEmojiSetsStore(p2) -- line: 28
	-- upvalues: createDataCache (copy), createDataResolver (copy), HttpClient (copy), getEmojiSets (copy), shouldRefreshCachedEmojiSets (copy), decodeEmojiSets (copy), hardcodedMomentsEmojis (copy)
	local v13 = p2 or {}
	local v14 = createDataCache()
	local v15 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v14,
		logError = function(p3) -- line: 35
			warn(`[Moments] Failed to fetch emoji sets: { tostring(p3) }`)
		end,
		fetchFn = function(_: string, _) -- line: 38
			-- upvalues: HttpClient (copy), getEmojiSets (copy), v13 (copy)
			return HttpClient.asPromise(getEmojiSets(v13.network))
		end
	})

	return {
		getAndFetchEmojiSets = function() -- line: 46
			-- upvalues: v15 (copy), shouldRefreshCachedEmojiSets (copy)
			return v15.getAndFetchItem("emoji-sets", shouldRefreshCachedEmojiSets)
		end,
		getEmojis = function(p5) -- line: 52
			-- upvalues: v15 (copy), decodeEmojiSets (copy), hardcodedMomentsEmojis (copy)
			local v20 = v15.getCachedItem("emoji-sets").data(p5)
			local v21 = decodeEmojiSets.flattenEmojis(v20)

			if #v21 > 0 then
				return v21
			end

			return hardcodedMomentsEmojis
		end,
		dispose = function() -- line: 61
			-- upvalues: v15 (copy)
			v15.dispose()
		end
	}
end

return createMomentsEmojiSetsStore
