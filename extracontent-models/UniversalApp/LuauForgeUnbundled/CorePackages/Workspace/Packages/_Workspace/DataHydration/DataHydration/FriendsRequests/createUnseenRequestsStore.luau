local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LocalUserIdStore").LocalUserIdStore
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/Requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/FriendsRequestsStoreTypes")

local function resolveLocalUserId(p2)
	local currentUserId = localUserIdStore.getCurrentUserId(p2)

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
	local v5 = createDataCache()

	local v6 = createDataResolver({
		cache = v5,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2)
			return Requests.GetNewFriendRequestsCount():andThen(function(p3)
				if p3 and p3.count then
					return p3.count
				end

				return 0
			end)
		end
	})

	return {
		getUnseenRequestCount = function(p2)
			local v7 = localUserIdStore.getCurrentUserId(false)

			if v7 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v7 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			if p2 and p2.skipFetch then
				return v6.getCachedItem(v7)
			end

			return v6.getAndFetchItem(v7)
		end,
		refetchUnseenRequestCount = function()
			local fetchItem = v6.fetchItem
			local v7 = localUserIdStore.getCurrentUserId(false)

			if v7 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v7 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			fetchItem(v7)
		end,
		clearUnseenRequest = function()
			return Requests.ClearNewFriendRequests():andThen(function()
				local replaceItem = v5.replaceItem
				local v7 = localUserIdStore.getCurrentUserId(false)

				if v7 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v7 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end

				replaceItem(v7, 0)
			end)
		end,
		clearUnseenRequestCount = function()
			local replaceItem = v5.replaceItem
			local v7 = localUserIdStore.getCurrentUserId(false)

			if v7 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v7 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			replaceItem(v7, 0)
		end,
		clear = function()
			v6.clear()
		end,
		dispose = function()
			v6.dispose()
		end
	}
end

return createUnseenRequestsStore
