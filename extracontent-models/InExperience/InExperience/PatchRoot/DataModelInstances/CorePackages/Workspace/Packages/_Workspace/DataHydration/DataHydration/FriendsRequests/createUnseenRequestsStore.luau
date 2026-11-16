local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
require(parent.Signals)

local Requests = require(script.Parent.Requests)
require(script.Parent.FriendsRequestsStoreTypes)

local function resolveLocalUserId(p) -- 3 equivalent calls inferred from this helper
	local currentUserId = localUserIdStore.getCurrentUserId(p)

	if currentUserId ~= "" then
		return currentUserId
	end

	local localPlayerUserId = getLocalPlayerUserId()

	if localPlayerUserId then
		return (tostring(localPlayerUserId))
	end

	return ""
end

local function createUnseenRequestsStore()
	local dataCache = createDataCache()

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_: string)
			return Requests.GetNewFriendRequestsCount():andThen(function(p)
				return if p and p.count then p.count else 0
			end)
		end
	})

	local function clearUnseenRequestCount() -- 1 equivalent call inferred from this helper
		dataCache.replaceItem(resolveLocalUserId(false), 0) -- inferred equivalent call
	end

	return {
		getUnseenRequestCount = function(p)
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call

			if p and p.skipFetch then
				return dataResolver.getCachedItem(localUserId)
			end

			return dataResolver.getAndFetchItem(localUserId)
		end,
		refetchUnseenRequestCount = function()
			dataResolver.fetchItem(resolveLocalUserId(false)) -- inferred equivalent call
		end,
		clearUnseenRequest = function()
			return Requests.ClearNewFriendRequests():andThen(function()
				clearUnseenRequestCount() -- inferred equivalent call
			end)
		end,
		clearUnseenRequestCount = clearUnseenRequestCount,
		clear = function()
			dataResolver.clear()
		end,
		dispose = function()
			dataResolver.dispose()
		end
	}
end

return createUnseenRequestsStore
