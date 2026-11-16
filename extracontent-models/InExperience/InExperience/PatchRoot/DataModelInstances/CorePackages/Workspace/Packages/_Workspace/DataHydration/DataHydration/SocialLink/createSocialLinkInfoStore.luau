local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.SocialLinkInfoStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local function createSocialLinkInfoStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	return {
		getSocialLinkInfo = dataResolver.getCachedItem,
		getSocialLinkInfos = dataResolver.getCachedItems,
		updateSocialLinkInfo = dataCache.updateItem,
		updateSocialLinkInfos = dataCache.updateItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createSocialLinkInfoStore
