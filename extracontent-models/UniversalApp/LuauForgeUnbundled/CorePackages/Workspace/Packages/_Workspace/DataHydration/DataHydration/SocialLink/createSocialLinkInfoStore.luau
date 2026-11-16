local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/SocialLink/SocialLinkInfoStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")

local function createSocialLinkInfoStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	return {
		getSocialLinkInfo = v6.getCachedItem,
		getSocialLinkInfos = v6.getCachedItems,
		updateSocialLinkInfo = v5.updateItem,
		updateSocialLinkInfos = v5.updateItems,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createSocialLinkInfoStore
