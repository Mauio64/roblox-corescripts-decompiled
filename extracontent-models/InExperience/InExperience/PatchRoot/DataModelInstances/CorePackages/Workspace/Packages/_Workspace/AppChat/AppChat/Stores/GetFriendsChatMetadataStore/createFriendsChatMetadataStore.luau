local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local DataHydration = require(parent.DataHydration)
require(parent.Signals)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function resolveLocalUserId(p) -- 1 equivalent call inferred from this helper
	return localUserIdStore.getCurrentUserId(p)
end

local function createFriendsChatMetadataStore()
	local dataCache = DataHydration.createDataCache()
	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(_: string)
			return AppChatNetworking.http.GetMetadata():andThen(function(p)
				return p.responseBody
			end)
		end,
		logError = function(p)
			v:warning(`Failed to fetch Friends Chat metadata: {tostring(p)}`)
		end
	})

	return {
		getFriendsChatMetadata = function(p)
			return dataResolver.getAndFetchItem(resolveLocalUserId(p))
		end,
		getCachedFriendsChatMetadata = function(p)
			return dataResolver.getCachedItem(resolveLocalUserId(p))
		end,
		fetchFriendsChatMetadata = function()
			return dataResolver.fetchItem(resolveLocalUserId(false))
		end,
		updateFriendsChatMetadata = function(p)
			dataCache.replaceItem(resolveLocalUserId(false), p) -- inferred equivalent call
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createFriendsChatMetadataStore
