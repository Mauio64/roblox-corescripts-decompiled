local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes").DataStatus
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId
local mergeListsWithoutDuplicates = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").mergeListsWithoutDuplicates

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LocalUserIdStore").LocalUserIdStore
local fFlagShowRequestsInCarouselForAllUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagShowRequestsInCarouselForAllUsers

local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/Requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/FriendsRequestsStoreTypes")
local FriendsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/FriendsStore")

local defineFastInt = game:DefineFastInt("FriendsRequestsPageSize", 25)

local defineFastInt2 = game:DefineFastInt("FriendsRequestsCacheTtlSec", 0)

local function getCacheTTL(p2)
	if p2 > 0 then
		return p2
	end

	return 1e999
end

local function normalizeId(p2)
	if p2 == nil then
		return nil
	end

	return (tostring(p2))
end

local function normalizeCursor(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return p2
end

local function normalizeFriendRequest(data)
	local id = data.id
	local v5 = if id ~= nil then tostring(id) else nil

	if not v5 then
		return nil
	end

	local friendRequest = data.friendRequest
	local v6

	if data.mutualFriendsList then
		v6 = {}

		for k, mutualFriend in data.mutualFriendsList do
			table.insert(v6, (tostring(mutualFriend)))
		end
	end

	local v7 = {
		id = v5,
		isUnseen = data.isUnseen,
		sentAt = 0,
		sourceUniverseId = 0,
		originSourceType = 0,
		contactName = 0,
		mutualFriendsIds = 0
	}
	local v8 = if friendRequest and friendRequest.sentAt then DateTime.fromIsoDate(friendRequest.sentAt) else nil
	v7.sentAt = v8
	local v9 = if friendRequest then friendRequest.sourceUniverseId else nil
	v7.sourceUniverseId = v9
	local v10 = if friendRequest then friendRequest.originSourceType else nil
	v7.originSourceType = v10
	local v11 = if friendRequest then friendRequest.contactName else nil
	v7.contactName = v11
	v7.mutualFriendsIds = v6
	return v7
end

local function normalizeGetFriendRequestsResponse(p2)
	local friendRequests = {}

	for k, v5 in not (p2 and p2.data) and {} or p2.data do
		local friendRequest = normalizeFriendRequest(v5)

		if friendRequest then
			table.insert(friendRequests, friendRequest)
		end
	end

	local nextPageCursor = if p2 then p2.nextPageCursor else nil

	if nextPageCursor == nil or nextPageCursor == "" then
		nextPageCursor = nil
	end

	return {
		requests = friendRequests,
		nextPageCursor = nextPageCursor,
		hasMore = nextPageCursor ~= nil
	}
end

local function updateFriendshipStatusesForPage(getFriendRequestsResponse)
	local v5 = FriendsStore.get()

	for k, request in getFriendRequestsResponse.requests do
		v5.UpdateFriendshipStatus(request.id, Enum.FriendStatus.FriendRequestReceived)
	end
end

local function mergeFriendsRequestsPage(p2, getFriendRequestsResponse, nextPageCursor)
	if not p2 then
		return {
			requests = getFriendRequestsResponse.requests,
			nextPageCursor = getFriendRequestsResponse.nextPageCursor,
			hasMore = getFriendRequestsResponse.hasMore
		}
	end

	if p2.nextPageCursor == nextPageCursor then
		return {
			requests = mergeListsWithoutDuplicates(p2.requests, getFriendRequestsResponse.requests, "id"),
			nextPageCursor = getFriendRequestsResponse.nextPageCursor,
			hasMore = getFriendRequestsResponse.hasMore
		}
	end

	return p2
end

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

local function createFriendsRequestsStore()
	local v5 = defineFastInt2
	local v6 = createDataCache(not (v5 > 0) and 1e999 or v5)
	local v7 = createDataCache()
	local v8 = createDataCache()

	local flag = false
	local v9 = nil

	local function stageSessionId(p2)
		if p2 == "" then
			p2 = nil
		end

		v9 = p2
	end

	local v10 = createDataResolver({
		cache = v6,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			local v11 = if not flag then p3.data(false) else nil
			flag = false

			local nextPageCursor = if v11 then v11.nextPageCursor else nil

			return Requests.GetFriendsRequests(nextPageCursor, defineFastInt, v9):andThen(function(p4)
				local getFriendRequestsResponse = normalizeGetFriendRequestsResponse(p4)

				updateFriendshipStatusesForPage(getFriendRequestsResponse)

				return mergeFriendsRequestsPage(v11, getFriendRequestsResponse, nextPageCursor)
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local v11 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2)
			return Requests.GetFriendRequestsCount():andThen(function(p3)
				if p3 and p3.count then
					return p3.count
				end

				return 0
			end)
		end
	})

	local v12 = createDataResolver({
		cache = v8,
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
		getFriendsRequests = function(data)
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			if data and data.skipFetch then
				return v10.getCachedItem(v13)
			end

			if data and data.forceFetch then
				local sessionId = if data then data.sessionId else nil
				local v14 = localUserIdStore.getCurrentUserId(false)

				if v14 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v14 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end

				if not v10.isRequestInQueueOrInFlight(v14) then
					if sessionId == "" then
						sessionId = nil
					end

					v9 = sessionId

					flag = true
					v10.fetchItem(v14)
				end
			end

			local sessionId = if data then data.sessionId else nil

			if sessionId == "" then
				sessionId = nil
			end

			v9 = sessionId

			return v10.getAndFetchItem(v13)
		end,
		fetchMoreFriendsRequests = function(p2)
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			local cachedItem = v10.getCachedItem(v13)
			local data = cachedItem.data(false)

			if
				data == nil
				or not data.hasMore
				or data.nextPageCursor == nil
				or cachedItem.status(false) == dataStatus.NotReady
			then
				return
			end

			if v10.isRequestInQueueOrInFlight(v13) then
				return
			end

			if p2 == "" then
				p2 = nil
			end

			v9 = p2

			v10.fetchItem(v13)
		end,
		refetchFriendRequests = function(p2)
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			if v10.isRequestInQueueOrInFlight(v13) then
				return
			end

			if p2 == "" then
				p2 = nil
			end

			v9 = p2

			flag = true
			v10.fetchItem(v13)
		end,
		declineAllFriendRequests = function()
			return Requests.DeclineAllFriendRequests():andThen(function(p2)
				local v13 = localUserIdStore.getCurrentUserId(false)

				if v13 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end

				v6.replaceItem(v13, {
					requests = {},
					nextPageCursor = nil,
					hasMore = false
				})

				v7.replaceItem(v13, 0)

				return p2
			end)
		end,
		removeFriendRequestByUserId = function(p2)
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			local data = v10.getCachedItem(v13).data(false)

			if data == nil then
				return
			end

			local requests = {}
			local v14 = false

			for k, request in data.requests do
				if request.id == p2 then
					v14 = true
				else
					table.insert(requests, request)
				end
			end

			if not v14 then
				return
			end

			v6.replaceItem(v13, {
				requests = requests,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end,
		appendNewUserId = function(p2)
			local v13 = if p2 ~= nil then tostring(p2) else nil

			if not v13 then
				return
			end

			local v14 = localUserIdStore.getCurrentUserId(false)

			if v14 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v14 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			local data = v10.getCachedItem(v14).data(false)

			local v15 = { id = v13, isUnseen = true }

			if data == nil then
				if fFlagShowRequestsInCarouselForAllUsers then
					local v16 = localUserIdStore.getCurrentUserId(false)

					if v16 == "" then
						local localPlayerUserId = getLocalPlayerUserId()
						v16 = not localPlayerUserId and "" or tostring(localPlayerUserId)
					end

					if not v10.isRequestInQueueOrInFlight(v16) then
						v9 = nil

						flag = true
						v10.fetchItem(v16)
					end
				else
					v6.replaceItem(v14, {
						requests = { v15 },
						nextPageCursor = nil,
						hasMore = false
					})
				end
			else
				local requests = { v15 }

				for k, request in data.requests do
					if request.id ~= v13 then
						table.insert(requests, request)
					end
				end

				v6.replaceItem(v14, {
					requests = requests,
					nextPageCursor = data.nextPageCursor,
					hasMore = data.hasMore
				})
			end

			FriendsStore.get().UpdateFriendshipStatus(v13, Enum.FriendStatus.FriendRequestReceived)
		end,
		getFriendsRequestCount = function(p2)
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			if p2 and p2.skipFetch then
				return v11.getCachedItem(v13)
			end

			if p2 and p2.forceFetch then
				local fetchItem = v11.fetchItem
				local v14 = localUserIdStore.getCurrentUserId(false)

				if v14 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v14 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end

				fetchItem(v14)
			end

			return v11.getAndFetchItem(v13)
		end,
		refetchFriendRequestCount = function()
			local fetchItem = v11.fetchItem
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			fetchItem(v13)
		end,
		getNewFriendsRequestCount = function(p2)
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			if p2 and p2.skipFetch then
				return v12.getCachedItem(v13)
			end

			return v12.getAndFetchItem(v13)
		end,
		refetchNewFriendRequestCount = function()
			local fetchItem = v12.fetchItem
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			fetchItem(v13)
		end,
		clearNewFriendRequest = function()
			return Requests.ClearNewFriendRequests():andThen(function()
				local replaceItem = v8.replaceItem
				local v13 = localUserIdStore.getCurrentUserId(false)

				if v13 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end

				replaceItem(v13, 0)
			end)
		end,
		clearNewFriendRequestCount = function()
			local replaceItem = v8.replaceItem
			local v13 = localUserIdStore.getCurrentUserId(false)

			if v13 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v13 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			replaceItem(v13, 0)
		end,
		clear = function()
			v10.clear()
			v11.clear()
			v12.clear()
		end,
		dispose = function()
			v10.dispose()
			v11.dispose()
			v12.dispose()
		end
	}
end

return createFriendsRequestsStore
