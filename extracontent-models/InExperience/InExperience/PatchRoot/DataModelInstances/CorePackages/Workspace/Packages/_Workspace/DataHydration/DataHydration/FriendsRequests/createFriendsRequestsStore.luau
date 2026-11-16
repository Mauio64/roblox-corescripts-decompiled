local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
local DataHydrationTypes = require(DataHydration.DataHydrationTypes)
local DataStatus = DataHydrationTypes.DataStatus
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local DataHydrationUtils2 = require(DataHydration.DataHydrationUtils)
local mergeListsWithoutDuplicates = DataHydrationUtils2.mergeListsWithoutDuplicates

require(parent.Signals)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local SharedFlags = require(parent.SharedFlags)
local FFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers

local Requests = require(script.Parent.Requests)
require(script.Parent.FriendsRequestsStoreTypes)
local FriendsStore = require(DataHydration.Friends.FriendsStore)

local defineFastInt = game:DefineFastInt("FriendsRequestsPageSize", 25)

local defineFastInt2 = game:DefineFastInt("FriendsRequestsCacheTtlSec", 0)

local function getCacheTTL(p: number) -- 1 equivalent call inferred from this helper
	return if p > 0 then p else 1e999
end

local function normalizeId(p) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return (tostring(p))
end

local function normalizeCursor(nextPageCursor: string?) -- 1 equivalent call inferred from this helper
	if nextPageCursor == nil or nextPageCursor == "" then
		return nil
	end

	return nextPageCursor
end

local function normalizeFriendRequest(data)
	local id = normalizeId(data.id) -- inferred equivalent call

	if not id then
		return nil
	end

	local friendRequest = data.friendRequest
	local mutualFriendsIds

	if data.mutualFriendsList then
		mutualFriendsIds = {}

		for _, mutualFriend in data.mutualFriendsList do
			table.insert(mutualFriendsIds, (tostring(mutualFriend)))
		end
	end

	local v = {
		id = id,
		isUnseen = data.isUnseen,
		sentAt = 0,
		sourceUniverseId = 0,
		originSourceType = 0,
		contactName = 0,
		mutualFriendsIds = 0
	}
	local sentAt

	if friendRequest and friendRequest.sentAt then
		sentAt = DateTime.fromIsoDate(friendRequest.sentAt)
	end

	v.sentAt = sentAt
	local sourceUniverseId

	if friendRequest then
		sourceUniverseId = friendRequest.sourceUniverseId
	end

	v.sourceUniverseId = sourceUniverseId
	local originSourceType

	if friendRequest then
		originSourceType = friendRequest.originSourceType
	end

	v.originSourceType = originSourceType
	local contactName

	if friendRequest then
		contactName = friendRequest.contactName
	end

	v.contactName = contactName
	v.mutualFriendsIds = mutualFriendsIds
	return v
end

local function normalizeGetFriendRequestsResponse(p)
	local friendRequests = {}

	for _, v in not (p and p.data) and {} or p.data do
		local friendRequest = normalizeFriendRequest(v)

		if friendRequest then
			table.insert(friendRequests, friendRequest)
		end
	end

	local nextPageCursor

	if p then
		nextPageCursor = p.nextPageCursor
	end

	nextPageCursor = normalizeCursor(nextPageCursor) -- inferred equivalent call
	return {
		requests = friendRequests,
		nextPageCursor = nextPageCursor,
		hasMore = nextPageCursor ~= nil
	}
end

local function updateFriendshipStatusesForPage(getFriendRequestsResponse)
	local v = FriendsStore.get()

	for _, request in getFriendRequestsResponse.requests do
		v.UpdateFriendshipStatus(request.id, Enum.FriendStatus.FriendRequestReceived)
	end
end

local function mergeFriendsRequestsPage(p, getFriendRequestsResponse, nextPageCursor)
	if not p then
		return {
			requests = getFriendRequestsResponse.requests,
			nextPageCursor = getFriendRequestsResponse.nextPageCursor,
			hasMore = getFriendRequestsResponse.hasMore
		}
	end

	if p.nextPageCursor == nextPageCursor then
		return {
			requests = mergeListsWithoutDuplicates(p.requests, getFriendRequestsResponse.requests, "id"),
			nextPageCursor = getFriendRequestsResponse.nextPageCursor,
			hasMore = getFriendRequestsResponse.hasMore
		}
	end

	return p
end

local function resolveLocalUserId(p) -- 12 equivalent calls inferred from this helper
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

local function createFriendsRequestsStore()
	local dataCache = createDataCache(getCacheTTL(defineFastInt2)) -- inferred equivalent call
	local dataCache2 = createDataCache()
	local dataCache3 = createDataCache()

	local flag = false
	local v = nil

	local function stageSessionId(p: string?) -- 3 equivalent calls inferred from this helper
		if p == "" then
			p = nil
		end

		v = p
	end

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_, p)
			local v2

			if flag then
				v2 = nil
			else
				v2 = p.data(false)
			end

			flag = false
			local nextPageCursor

			if v2 then
				nextPageCursor = v2.nextPageCursor
			else
				nextPageCursor = nil
			end

			return Requests.GetFriendsRequests(nextPageCursor, defineFastInt, v):andThen(function(p2)
				local getFriendRequestsResponse = normalizeGetFriendRequestsResponse(p2)

				updateFriendshipStatusesForPage(getFriendRequestsResponse)

				return mergeFriendsRequestsPage(v2, getFriendRequestsResponse, nextPageCursor)
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local dataResolver2 = createDataResolver({
		cache = dataCache2,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_)
			return Requests.GetFriendRequestsCount():andThen(function(p)
				return if p and p.count then p.count else 0
			end)
		end
	})

	local dataResolver3 = createDataResolver({
		cache = dataCache3,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_)
			return Requests.GetNewFriendRequestsCount():andThen(function(p)
				return if p and p.count then p.count else 0
			end)
		end
	})

	local function refetchFriendRequests(p: string?) -- 1 equivalent call inferred from this helper
		local localUserId = resolveLocalUserId(false) -- inferred equivalent call

		if dataResolver.isRequestInQueueOrInFlight(localUserId) then
			return
		end

		stageSessionId(p) -- inferred equivalent call
		flag = true
		dataResolver.fetchItem(localUserId)
	end

	local function refetchFriendRequestCount() -- 1 equivalent call inferred from this helper
		dataResolver2.fetchItem(resolveLocalUserId(false)) -- inferred equivalent call
	end

	local function clearNewFriendRequestCount() -- 1 equivalent call inferred from this helper
		dataCache3.replaceItem(resolveLocalUserId(false), 0) -- inferred equivalent call
	end

	return {
		getFriendsRequests = function(data)
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call

			if data and data.skipFetch then
				return dataResolver.getCachedItem(localUserId)
			end

			if data and data.forceFetch then
				local v2

				if data then
					v2 = data.sessionId
				end

				refetchFriendRequests(v2) -- inferred equivalent call
			end

			local v2

			if data then
				v2 = data.sessionId
			end

			stageSessionId(v2) -- inferred equivalent call
			return dataResolver.getAndFetchItem(localUserId)
		end,
		fetchMoreFriendsRequests = function(p: string?)
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			local cachedItem = dataResolver.getCachedItem(localUserId)
			local data = cachedItem.data(false)

			if
				data == nil
				or not data.hasMore
				or data.nextPageCursor == nil
				or cachedItem.status(false) == DataStatus.NotReady
			then
				return
			end

			if dataResolver.isRequestInQueueOrInFlight(localUserId) then
				return
			end

			stageSessionId(p) -- inferred equivalent call
			dataResolver.fetchItem(localUserId)
		end,
		refetchFriendRequests = refetchFriendRequests,
		declineAllFriendRequests = function()
			return Requests.DeclineAllFriendRequests():andThen(function(p)
				local localUserId = resolveLocalUserId(false) -- inferred equivalent call
				dataCache.replaceItem(localUserId, {
					requests = {},
					nextPageCursor = nil,
					hasMore = false
				})

				dataCache2.replaceItem(localUserId, 0)

				return p
			end)
		end,
		removeFriendRequestByUserId = function(p)
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			local data = dataResolver.getCachedItem(localUserId).data(false)

			if data == nil then
				return
			end

			local requests = {}
			local v2 = false

			for _, request in data.requests do
				if request.id == p then
					v2 = true
				else
					table.insert(requests, request)
				end
			end

			if not v2 then
				return
			end

			dataCache.replaceItem(localUserId, {
				requests = requests,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end,
		appendNewUserId = function(p)
			local id = normalizeId(p) -- inferred equivalent call

			if not id then
				return
			end

			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			local data = dataResolver.getCachedItem(localUserId).data(false)

			local v2 = { id = id, isUnseen = true }

			if data == nil then
				if FFlagShowRequestsInCarouselForAllUsers then
					local localUserId2 = resolveLocalUserId(false) -- inferred equivalent call

					if not dataResolver.isRequestInQueueOrInFlight(localUserId2) then
						v = nil

						flag = true
						dataResolver.fetchItem(localUserId2)
					end
				else
					dataCache.replaceItem(localUserId, {
						requests = { v2 },
						nextPageCursor = nil,
						hasMore = false
					})
				end
			else
				local requests = { v2 }

				for _, request in data.requests do
					if request.id ~= id then
						table.insert(requests, request)
					end
				end

				dataCache.replaceItem(localUserId, {
					requests = requests,
					nextPageCursor = data.nextPageCursor,
					hasMore = data.hasMore
				})
			end

			FriendsStore.get().UpdateFriendshipStatus(id, Enum.FriendStatus.FriendRequestReceived)
		end,
		getFriendsRequestCount = function(p)
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call

			if p and p.skipFetch then
				return dataResolver2.getCachedItem(localUserId)
			end

			if p and p.forceFetch then
				refetchFriendRequestCount() -- inferred equivalent call
			end

			return dataResolver2.getAndFetchItem(localUserId)
		end,
		refetchFriendRequestCount = refetchFriendRequestCount,
		getNewFriendsRequestCount = function(p)
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call

			if p and p.skipFetch then
				return dataResolver3.getCachedItem(localUserId)
			end

			return dataResolver3.getAndFetchItem(localUserId)
		end,
		refetchNewFriendRequestCount = function()
			dataResolver3.fetchItem(resolveLocalUserId(false)) -- inferred equivalent call
		end,
		clearNewFriendRequest = function()
			return Requests.ClearNewFriendRequests():andThen(function()
				clearNewFriendRequestCount() -- inferred equivalent call
			end)
		end,
		clearNewFriendRequestCount = clearNewFriendRequestCount,
		clear = function()
			dataResolver.clear()
			dataResolver2.clear()
			dataResolver3.clear()
		end,
		dispose = function()
			dataResolver.dispose()
			dataResolver2.dispose()
			dataResolver3.dispose()
		end
	}
end

return createFriendsRequestsStore
