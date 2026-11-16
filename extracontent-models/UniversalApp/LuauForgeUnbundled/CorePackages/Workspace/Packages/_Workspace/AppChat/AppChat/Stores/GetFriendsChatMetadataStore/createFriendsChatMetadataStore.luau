local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LocalUserIdStore").LocalUserIdStore

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("createFriendsChatMetadataStore")

local function resolveLocalUserId(p2)
	return localUserIdStore.getCurrentUserId(p2)
end

local function createFriendsChatMetadataStore()
	local dataCache = DataHydration.createDataCache()
	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(p2)
			return AppChatNetworking.http.GetMetadata():andThen(function(p3)
				return p3.responseBody
			end)
		end,
		logError = function(p2)
			v5:warning(`Failed to fetch Friends Chat metadata: {tostring(p2)}`)
		end
	})

	return {
		getFriendsChatMetadata = function(p2)
			return dataResolver.getAndFetchItem(resolveLocalUserId(p2))
		end,
		getCachedFriendsChatMetadata = function(p2)
			return dataResolver.getCachedItem(resolveLocalUserId(p2))
		end,
		fetchFriendsChatMetadata = function()
			return dataResolver.fetchItem(resolveLocalUserId(false))
		end,
		updateFriendsChatMetadata = function(p2)
			dataCache.replaceItem(localUserIdStore.getCurrentUserId(false), p2)
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createFriendsChatMetadataStore
