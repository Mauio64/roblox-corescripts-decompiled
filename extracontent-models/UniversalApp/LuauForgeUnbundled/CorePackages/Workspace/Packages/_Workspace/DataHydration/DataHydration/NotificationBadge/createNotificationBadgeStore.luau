local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/NotificationBadge/NotificationBadgeStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")

local function createNotificationBadgeStore()
	local v5 = createDataCache()

	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	return {
		getNotificationBadge = v6.getCachedItem,
		getNotificationBadges = v6.getCachedItems,
		updateNotificationBadge = v5.updateItem,
		updateNotificationBadges = v5.updateItems,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createNotificationBadgeStore
