local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)
require(script.Parent.SocialLinkInfoStoreTypes)

local createDataResolver = require(DataHydration.createDataResolver)

local function createSocialLinkInfoStore() -- line: 10
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy)
	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		fetchFn = function(_: {[any]: any}) -- line: 14
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})

	return {
		getSocialLinkInfo = v8.getCachedItem,
		getSocialLinkInfos = v8.getCachedItems,
		updateSocialLinkInfo = v7.updateItem,
		updateSocialLinkInfos = v7.updateItems,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createSocialLinkInfoStore
