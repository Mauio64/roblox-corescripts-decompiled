local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.NotificationBadgeStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local function createNotificationBadgeStore()
	local dataCache = createDataCache()

	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	return {
		getNotificationBadge = dataResolver.getCachedItem,
		getNotificationBadges = dataResolver.getCachedItems,
		updateNotificationBadge = dataCache.updateItem,
		updateNotificationBadges = dataCache.updateItems,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createNotificationBadgeStore
