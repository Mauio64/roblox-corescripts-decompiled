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

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags.FFlagEnableFriendsStoreChallengeInterceptor
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local FFlagFriendsStoreSortOnlineFriendsByRank = SharedFlags.FFlagFriendsStoreSortOnlineFriendsByRank
local FFlagPresenceRefetchTelemetryEnabled = require(DataHydration.Flags.FFlagPresenceRefetchTelemetryEnabled)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddFriendsPageTrustedFriendRequestSection = SharedFlags2.FFlagAddFriendsPageTrustedFriendRequestSection
local FFlagPresenceLocationType = SharedFlags.FFlagPresenceLocationType
local Requests = require(DataHydration.Friends.Requests)
local FindFriendsSort = require(DataHydration.Friends.Enums.FindFriendsSort)
local mapFriendshipStatusToEnum = require(DataHydration.Friends.mapFriendshipStatusToEnum)

local PresenceStore = require(DataHydration.Presence.PresenceStore)
local normalizePresenceRawData = require(DataHydration.Presence.normalizePresenceRawData)
local PresenceType = require(DataHydration.Presence.Enums.PresenceType)
require(DataHydration.Presence.createPresenceStore)

game:DefineFastInt("FriendsStoreProcessDelaySec", 1)
local function getFIntFriendsStoreProcessDelaySec() -- 2 equivalent calls inferred from this helper
	return game:GetFastInt("FriendsStoreProcessDelaySec")
end

local defineFastInt = game:DefineFastInt("OnlineFriendsCacheTtlSec", 0)
local defineFastInt2 = game:DefineFastInt("IsFriendsWithCacheTtlSec", 0)
local defineFastInt3 = game:DefineFastInt("AllFriendsCacheTtlSec", 0)
local defineFastInt4 = game:DefineFastInt("FriendshipStatusCacheTtlSec", 0)
local defineFastInt5 = game:DefineFastInt("FriendsCountCacheTtlSec", 0)

local function getCacheTTL(p) -- 5 equivalent calls inferred from this helper
	return if p and p > 0 then p else 1e999
end

local defineFastInt6 = game:DefineFastInt("FriendsPageSize", 50)
local defineFastInt7 = game:DefineFastInt("InitialFriendsPageSize", 20)

local function normalizeId(p) -- 7 equivalent calls inferred from this helper
	if p then
		return (tostring(p))
	end

	return nil
end

local function normalizeStoredOnlineFriendRow(p)
	if p and type(p) == "table" and p.id ~= nil then
		return {
			id = tostring(p.id),
			sortScore = tonumber(p.sortScore) or 0
		}
	end

	return nil
end

local function normalizePresenceFromOnlineFriendsRow(p)
	if not p or type(p) ~= "table" or p.id == nil then
		return nil
	end

	local userPresence = p.userPresence

	if not userPresence or type(userPresence) ~= "table" then
		return nil
	end

	local v = {
		userPresenceType = userPresence.UserPresenceType,
		lastLocation = userPresence.lastLocation,
		lastOnline = userPresence.lastOnline,
		gameId = userPresence.gameInstanceId,
		placeId = userPresence.placeId,
		rootPlaceId = userPresence.rootPlaceId,
		universeId = userPresence.universeId,
		locationType = 0
	}
	local locationType

	if FFlagPresenceLocationType then
		locationType = userPresence.UserLocationType
	end

	v.locationType = locationType

	return normalizePresenceRawData(v, p.id)
end

local function normalizeFindFriendsNextCursor(p: string?) -- 3 equivalent calls inferred from this helper
	return if not (p == nil or p == "") then p else nil
end

local function normalizeFindFriendsPageResponse(data)
	local friends = {}

	for _, v in not (data and data.PageItems) and {} or data.PageItems do
		local id = normalizeId(v.id) -- inferred equivalent call

		if id then
			table.insert(friends, { id = id })
		end
	end

	local nextCursor

	if data then
		nextCursor = data.NextCursor
	end

	nextCursor = normalizeFindFriendsNextCursor(nextCursor) -- inferred equivalent call
	local hasMore

	if data and data.HasMore ~= nil then
		hasMore = data.HasMore
	else
		hasMore = nextCursor ~= nil
	end

	return { friends = friends, nextCursor = nextCursor, hasMore = hasMore }
end

local function mergeListsWithoutDuplicates2(friends, list, p: string?)
	if list and #list ~= 0 then
		if not friends or #friends == 0 then
			return list
		end

		local set = Cryo.List.toSet(Cryo.List.map(friends, function(p2)
			if p then
				return p2[p]
			end

			return p2
		end))

		local filtered = Cryo.List.filter(list, function(p2): boolean
			if p then
				p2 = p2[p]
			end

			return not set[p2]
		end)

		return Cryo.List.join(table.clone(friends), filtered)
	end

	return friends or {}
end

local function mergeAllFriendsPage(p, findFriendsPageResponse, nextCursor: string?)
	if not p then
		return {
			friends = findFriendsPageResponse.friends,
			nextCursor = findFriendsPageResponse.nextCursor,
			hasMore = findFriendsPageResponse.hasMore
		}
	end

	local findFriendsNextCursor = normalizeFindFriendsNextCursor(p.nextCursor) -- inferred equivalent call
	nextCursor = normalizeFindFriendsNextCursor(nextCursor) -- inferred equivalent call

	if findFriendsNextCursor ~= nextCursor then
		return p
	end

	local friends

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		friends = mergeListsWithoutDuplicates(p.friends, findFriendsPageResponse.friends, "id")
	else
		friends = mergeListsWithoutDuplicates2(p.friends, findFriendsPageResponse.friends, "id")
	end

	return {
		friends = friends,
		nextCursor = findFriendsPageResponse.nextCursor,
		hasMore = findFriendsPageResponse.hasMore
	}
end

local function resolveLocalUserId(p) -- 14 equivalent calls inferred from this helper
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

local function createFriendsStore()
	local v = PresenceStore.get()
	local v2

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v2 = nil
	else
		v2 = tostring(getLocalPlayerUserId())
	end

	local dataCache = createDataCache(getCacheTTL(defineFastInt)) -- inferred equivalent call
	local dataCache2 = createDataCache(getCacheTTL(defineFastInt2)) -- inferred equivalent call
	local dataCache3 = createDataCache(getCacheTTL(defineFastInt3)) -- inferred equivalent call
	local flag = false

	local dataCache4 = createDataCache(getCacheTTL(defineFastInt4)) -- inferred equivalent call
	local dataCache5 = createDataCache(getCacheTTL(defineFastInt5)) -- inferred equivalent call

	local computeds = {}

	local function appendUserToAllFriends(id: string)
		local v3

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v3 = localUserIdStore.getCurrentUserId(false)

			if v3 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v3 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end
		else
			v3 = v2
		end

		local data = dataCache3.getItem(v3).data(false)

		if data then
			local friends

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				friends = mergeListsWithoutDuplicates(data.friends, {
					{ id = id }
				}, "id")
			else
				friends = mergeListsWithoutDuplicates2(data.friends, {
					{ id = id }
				}, "id")
			end

			if #friends == #data.friends then
				return
			end

			dataCache3.replaceItem(v3, {
				friends = friends,
				nextCursor = data.nextCursor,
				hasMore = data.hasMore
			})
		end
	end

	local function UpdateIsFriendsWith(id: string, flag2: boolean) -- 2 equivalent calls inferred from this helper
		dataCache2.replaceItem(id, flag2)

		if flag2 then
			appendUserToAllFriends(id)
			dataCache4.replaceItem(id, Enum.FriendStatus.Friend)
		end

		if not flag2 then
			v.UpdateUserPresence(id, nil, { isUpdatedRealtime = false })
		end
	end

	local function updateOnlineFriendDependecies(id, p) -- 2 equivalent calls inferred from this helper
		v.UpdateUserPresence(id, p, { isUpdatedRealtime = true })
		UpdateIsFriendsWith(id, true) -- inferred equivalent call
	end

	local function updateOfflineFriendDependencies(id)
		local data = v.GetPresenceByUserId(id, { skipFetch = true }).data(false)
		v.UpdateUserPresence(id, data or normalizePresenceRawData({
			userPresenceType = PresenceType.Offline
		}), {
			isUpdatedRealtime = true
		})
		UpdateIsFriendsWith(id, true) -- inferred equivalent call
	end

	local function applyGetOnlineFriendsResponseBody(p)
		local storedOnlineFriendRowsById = {}

		for _, v3 in p and p.data or {} do
			local id = normalizeId(v3.id) -- inferred equivalent call
			local storedOnlineFriendRow = normalizeStoredOnlineFriendRow(v3)
			local presenceFromOnlineFriendsRow = normalizePresenceFromOnlineFriendsRow(v3)

			if not id then
				continue
			end

			storedOnlineFriendRowsById[id] = storedOnlineFriendRow
			updateOnlineFriendDependecies(id, presenceFromOnlineFriendsRow) -- inferred equivalent call
		end

		return storedOnlineFriendRowsById
	end

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, p2)
			local v3 = p2.data(false) or {}

			return Requests.GetOnlineFriends(p):andThen(function(p3)
				for _, v4 in v3 do
					local id = v4 and v4.id
					local id2 = normalizeId(id) -- inferred equivalent call

					if id2 then
						v.UpdateUserPresence(
							id2,
							normalizePresenceRawData({ userPresenceType = PresenceType.Offline }),
							{ isUpdatedRealtime = true }
						)
					end
				end

				return applyGetOnlineFriendsResponseBody(p3)
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local function fetchFriendshipStatuses(p)
		local v3

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v3 = localUserIdStore.getCurrentUserId(false)

			if v3 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v3 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end
		else
			v3 = v2
		end

		return Requests.MultiGetFriendshipStatuses(v3, p):andThen(function(p2)
			local result = {}

			for _, v4 in p2 and p2.data or {} do
				local id = normalizeId(v4.id) -- inferred equivalent call

				if id then
					result[id] = mapFriendshipStatusToEnum(v4.status)
				end
			end

			return result
		end)
	end

	local dataResolver2 = createDataResolver({
		cache = dataCache2,
		queueProcessDelaySec = getFIntFriendsStoreProcessDelaySec(), -- inferred equivalent call
		fetchFn = function(p)
			local keys = Cryo.Dictionary.keys(p)
			local v3

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v3 = localUserIdStore.getCurrentUserId(false)

				if v3 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v3 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end
			else
				v3 = v2
			end

			return Requests.MultiGetFriendshipStatuses(v3, keys):andThen(function(p2)
				local result = {}

				for _, v4 in p2 and p2.data or {} do
					local id = normalizeId(v4.id) -- inferred equivalent call

					if id then
						result[id] = mapFriendshipStatusToEnum(v4.status)
					end
				end

				return result
			end):andThen(function(items)
				dataCache4.replaceItems(items)
				local result = {}

				for k, item in items do
					result[k] = item == Enum.FriendStatus.Friend
				end

				return result
			end)
		end
	})

	local dataResolver3 = createDataResolver({
		cache = dataCache4,
		queueProcessDelaySec = getFIntFriendsStoreProcessDelaySec(), -- inferred equivalent call
		fetchFn = function(p)
			local keys = Cryo.Dictionary.keys(p)
			local v3

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v3 = localUserIdStore.getCurrentUserId(false)

				if v3 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v3 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end
			else
				v3 = v2
			end

			return Requests.MultiGetFriendshipStatuses(v3, keys):andThen(function(p2)
				local result = {}

				for _, v4 in p2 and p2.data or {} do
					local id = normalizeId(v4.id) -- inferred equivalent call

					if id then
						result[id] = mapFriendshipStatusToEnum(v4.status)
					end
				end

				return result
			end):andThen(function(items)
				local v4 = {}

				for k, item in items do
					v4[k] = item == Enum.FriendStatus.Friend
				end

				dataCache2.replaceItems(v4)
				return items
			end)
		end
	})

	local dataResolver4 = createDataResolver({
		cache = dataCache3,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p, p2)
			local v3

			if flag then
				v3 = nil
			else
				v3 = p2.data(false)
			end

			flag = false
			local nextCursor

			if v3 then
				nextCursor = v3.nextCursor
			else
				nextCursor = nil
			end

			local limit = if v3 then defineFastInt6 else defineFastInt7
			return Requests.GetFindFriendsPage(p, {
				limit = limit,
				cursor = nextCursor,
				sort = FindFriendsSort.FriendshipScore
			}):andThen(function(p3)
				local findFriendsPageResponse = normalizeFindFriendsPageResponse(p3)

				for _, friend in findFriendsPageResponse.friends do
					updateOfflineFriendDependencies(friend.id)
				end

				return mergeAllFriendsPage(v3, findFriendsPageResponse, nextCursor)
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local dataResolver5 = createDataResolver({
		cache = dataCache5,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string)
			return Requests.GetFriendsCountFromUserId(p):andThen(function(p2)
				return if p2 then p2.count else 0
			end)
		end
	})

	local computed = Signals.createComputed(function(p)
		local localUserId = resolveLocalUserId(p) -- inferred equivalent call
		local data = dataResolver.getAndFetchItem(localUserId).data(p)

		if data == nil then
			return nil
		end

		local result = {}

		for _, v3 in pairs(data) do
			if not v3 then
				continue
			end

			local data2 = v.GetPresenceByUserId(v3.id, { skipFetch = true }).data(p)

			if not (dataResolver2.getCachedItem(v3.id).data(p) and data2 and data2.userPresenceType and data2.userPresenceType ~= PresenceType.Offline) then
				continue
			end

			table.insert(result, { id = v3.id, sortScore = v3.sortScore, presence = data2 })
		end

		if FFlagFriendsStoreSortOnlineFriendsByRank then
			table.sort(result, function(a, b): boolean
				return a.sortScore > b.sortScore
			end)
		end

		return result
	end)

	local computed2 = Signals.createComputed(function(p)
		local localUserId = resolveLocalUserId(p) -- inferred equivalent call
		return dataResolver.getCachedItem(localUserId).status(p)
	end)

	local computed3 = Signals.createComputed(function(p)
		local localUserId = resolveLocalUserId(p) -- inferred equivalent call
		local data = dataResolver4.getAndFetchItem(localUserId).data(p)

		if data == nil then
			return nil
		end

		local friends = data.friends or {}

		return {
			friends = Cryo.List.filter(friends, function(p2)
				return dataResolver2.getCachedItem(p2.id).data(p)
			end),
			hasMore = data.hasMore,
			nextCursor = data.nextCursor
		}
	end)

	local computed4 = Signals.createComputed(function(p)
		local localUserId = resolveLocalUserId(p) -- inferred equivalent call
		return dataResolver4.getCachedItem(localUserId).status(p)
	end)

	local function UpdateFriendshipStatus(id: string, p) -- 6 equivalent calls inferred from this helper
		dataCache4.replaceItem(id, p)

		UpdateIsFriendsWith(id, p == Enum.FriendStatus.Friend)
	end

	return {
		GetOnlineFriends = function()
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			dataResolver.getAndFetchItem(localUserId)

			return computed
		end,
		GetOnlineFriendsStatus = function()
			return computed2
		end,
		RefetchOnlineFriends = function()
			dataResolver.fetchItem(resolveLocalUserId(false)) -- inferred equivalent call
		end,
		GetOnlineFriendsByUniverseId = function(p: string)
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			dataResolver.getAndFetchItem(localUserId)

			local v3 = computeds[p]

			if v3 then
				return v3
			end

			local computed3 = Signals.createComputed(function(p2)
				local v4 = computed(p2)

				if not v4 then
					return {}
				end

				local result = {}

				for _, v5 in v4 do
					if v5.presence and v5.presence.universeId == p then
						table.insert(result, v5)
					end
				end

				return result
			end)

			computeds[p] = computed3
			return computed3
		end,
		GetAllFriends = function()
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			dataResolver4.getAndFetchItem(localUserId)

			return computed3
		end,
		GetAllFriendsStatus = function()
			return computed4
		end,
		FetchMoreFriends = function()
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			local cachedItem = dataResolver4.getCachedItem(localUserId)
			local data = cachedItem.data(false)

			if
				data == nil
				or not data.hasMore
				or data.nextCursor == nil
				or cachedItem.status(false) == DataStatus.NotReady
			then
				return
			end

			if dataResolver4.isRequestInQueueOrInFlight(localUserId) then
				return
			end

			dataResolver4.fetchItem(localUserId)
		end,
		RefetchAllFriends = function()
			flag = true

			dataResolver4.fetchItem(resolveLocalUserId(false)) -- inferred equivalent call
		end,
		GetIsFriendWith = function(p: string)
			return dataResolver2.getAndFetchItem(p)
		end,
		UpdateIsFriendsWith = UpdateIsFriendsWith,
		GetFriendsCountByUserId = function(p: string, p2)
			if p2 and p2.skipFetch then
				return dataResolver5.getCachedItem(p)
			end

			return dataResolver5.getAndFetchItem(p)
		end,
		RefreshFriendsCountByUserId = function(p: string)
			dataResolver5.fetchItem(p)
		end,
		clear = function()
			dataResolver.clear()
			dataResolver2.clear()
			dataResolver4.clear()
			dataResolver3.clear()
			dataResolver5.clear()
			table.clear(computeds)
		end,
		dispose = function()
			dataResolver.dispose()
			dataResolver2.dispose()
			dataResolver4.dispose()
			dataResolver3.dispose()
			dataResolver5.dispose()
			table.clear(computeds)
		end,
		_fetchOnlineFriendsAsync = function()
			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			return Requests.GetOnlineFriends(localUserId):andThen(function(p)
				local v3 = applyGetOnlineFriendsResponseBody(p)
				dataCache.replaceItems({ [localUserId] = v3 })
				return p or { data = nil }
			end):catch(function(message)
				error(message)
			end)
		end,
		_getCachedFriendsPresences = function()
			if not FFlagPresenceRefetchTelemetryEnabled then
				return nil
			end

			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			local data = dataResolver.getCachedItem(localUserId).data(false)

			if data == nil then
				return nil
			end

			local result = {}

			for _, v3 in pairs(data) do
				if v3 then
					table.insert(result, {
						id = v3.id,
						presence = v.GetPresenceByUserId(v3.id, { skipFetch = true }).data(false)
					})
				end
			end

			return result
		end,
		_getFetchedFriendIds = function()
			if not FFlagPresenceRefetchTelemetryEnabled then
				return nil
			end

			local localUserId = resolveLocalUserId(false) -- inferred equivalent call
			local data = dataResolver.getCachedItem(localUserId).data(false)
			local data2 = dataResolver4.getCachedItem(localUserId).data(false)

			if data == nil and data2 == nil then
				return nil
			end

			local idSet = {}

			if data2 then
				for _, friend in data2.friends do
					idSet[friend.id] = true
				end
			end

			if data then
				for _, v3 in pairs(data) do
					if v3 then
						idSet[v3.id] = true
					end
				end
			end

			return idSet
		end,
		_updateFriendsPresences = function(items, options, _: string?)
			if not items then
				return
			end

			local v3 = options or {}

			local storedOnlineFriendRowsById = {}

			for _, item in pairs(items) do
				local id = normalizeId(item.userId) -- inferred equivalent call

				if not id then
					continue
				end

				local storedOnlineFriendRow = normalizeStoredOnlineFriendRow({
					id = id,
					sortScore = v3[id]
				})

				local presenceRawData = normalizePresenceRawData(item)
				storedOnlineFriendRowsById[id] = storedOnlineFriendRow
				updateOnlineFriendDependecies(id, presenceRawData) -- inferred equivalent call
			end

			dataCache.updateItem(resolveLocalUserId(false), storedOnlineFriendRowsById) -- inferred equivalent call
		end,
		GetFriendshipStatus = function(p: string, p2)
			if p == "" then
				return nil
			end

			if p2 and p2.skipFetch then
				return dataResolver3.getCachedItem(p)
			end

			return dataResolver3.getAndFetchItem(p)
		end,
		UpdateFriendshipStatus = UpdateFriendshipStatus,
		RefetchFriendshipStatus = function(p: string)
			if p == "" then
				return
			end

			dataResolver3.fetchItem(p)
		end,
		RequestFriendship = function(id: string, p: string?, p2, callback)
			if not FFlagEnableFriendsStoreChallengeInterceptor then
				callback = nil
			end

			local v3

			if p2 and p2.isContact then
				v3 = Requests.RequestFriendshipFromContactId(id, callback)
			else
				v3 = Requests.RequestFriendshipFromUserId(id, p, callback)
			end

			return v3:andThen(function()
				UpdateFriendshipStatus(id, Enum.FriendStatus.FriendRequestSent) -- inferred equivalent call
			end):catch(function(message)
				local v4

				if type(message) == "table" then
					v4 = message.firstErrorCode
				end

				if v4 ~= 5 then
					error(message)
					return
				end

				UpdateFriendshipStatus(id, Enum.FriendStatus.Friend) -- inferred equivalent call
			end)
		end,
		AcceptFriendRequest = function(id: string)
			return Requests.AcceptFriendRequestFromUserId(id):andThen(function()
				UpdateFriendshipStatus(id, Enum.FriendStatus.Friend) -- inferred equivalent call
			end):catch(function(message)
				local v3

				if type(message) == "table" then
					v3 = message.firstErrorCode
				end

				if v3 ~= 5 then
					error(message)
					return
				end

				UpdateFriendshipStatus(id, Enum.FriendStatus.Friend) -- inferred equivalent call
			end)
		end,
		DeclineFriendRequest = function(id: string)
			return Requests.DeclineFriendRequestFromUserId(id):andThen(function()
				UpdateFriendshipStatus(id, Enum.FriendStatus.NotFriend) -- inferred equivalent call
			end)
		end,
		Unfriend = function(id: string)
			return Requests.UnfriendTargetUserId(id):andThen(function()
				UpdateFriendshipStatus(id, Enum.FriendStatus.NotFriend) -- inferred equivalent call
			end)
		end
	}
end

return createFriendsStore
