local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes").DataStatus
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId
local mergeListsWithoutDuplicates = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").mergeListsWithoutDuplicates

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LocalUserIdStore").LocalUserIdStore

local fFlagEnableFriendsStoreChallengeInterceptor = SharedFlags.FFlagEnableFriendsStoreChallengeInterceptor
local fFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local fFlagFriendsStoreSortOnlineFriendsByRank = SharedFlags.FFlagFriendsStoreSortOnlineFriendsByRank
local FFlagPresenceRefetchTelemetryEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagPresenceRefetchTelemetryEnabled")

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagAddFriendsPageTrustedFriendRequestSection
local fFlagPresenceLocationType = SharedFlags.FFlagPresenceLocationType
local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Requests")
local FindFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Enums/FindFriendsSort")
local mapFriendshipStatusToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/mapFriendshipStatusToEnum")

local PresenceStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/PresenceStore")
local normalizePresenceRawData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/normalizePresenceRawData")
local PresenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Enums/PresenceType")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/createPresenceStore")

game:DefineFastInt("FriendsStoreProcessDelaySec", 1)
local function getFIntFriendsStoreProcessDelaySec()
	return game:GetFastInt("FriendsStoreProcessDelaySec")
end

local defineFastInt = game:DefineFastInt("OnlineFriendsCacheTtlSec", 0)
local defineFastInt2 = game:DefineFastInt("IsFriendsWithCacheTtlSec", 0)
local defineFastInt3 = game:DefineFastInt("AllFriendsCacheTtlSec", 0)
local defineFastInt4 = game:DefineFastInt("FriendshipStatusCacheTtlSec", 0)
local defineFastInt5 = game:DefineFastInt("FriendsCountCacheTtlSec", 0)

local function getCacheTTL(p2)
	if p2 and p2 > 0 then
		return p2
	end

	return 1e999
end

local defineFastInt6 = game:DefineFastInt("FriendsPageSize", 50)
local defineFastInt7 = game:DefineFastInt("InitialFriendsPageSize", 20)

local function normalizeId(p2)
	if p2 then
		return (tostring(p2))
	end

	return nil
end

local function normalizeStoredOnlineFriendRow(p2)
	if p2 and type(p2) == "table" and p2.id ~= nil then
		return {
			id = tostring(p2.id),
			sortScore = tonumber(p2.sortScore) or 0
		}
	end

	return nil
end

local function normalizePresenceFromOnlineFriendsRow(p2)
	if not p2 or type(p2) ~= "table" or p2.id == nil then
		return nil
	end

	local userPresence = p2.userPresence

	if not userPresence or type(userPresence) ~= "table" then
		return nil
	end

	local v5 = {
		userPresenceType = userPresence.UserPresenceType,
		lastLocation = userPresence.lastLocation,
		lastOnline = userPresence.lastOnline,
		gameId = userPresence.gameInstanceId,
		placeId = userPresence.placeId,
		rootPlaceId = userPresence.rootPlaceId,
		universeId = userPresence.universeId,
		locationType = 0
	}
	local v6 = if fFlagPresenceLocationType then userPresence.UserLocationType else nil
	v5.locationType = v6

	return normalizePresenceRawData(v5, p2.id)
end

local function normalizeFindFriendsNextCursor(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return p2
end

local function normalizeFindFriendsPageResponse(data)
	local v5 = {}

	for k, v6 in not (data and data.PageItems) and {} or data.PageItems do
		local id = v6.id
		local v7 = if id then tostring(id) else nil

		if v7 then
			table.insert(v5, { id = v7 })
		end
	end

	local nextCursor = if data then data.NextCursor else nil

	if nextCursor == nil or nextCursor == "" then
		nextCursor = nil
	end

	local v6 = if data and data.HasMore ~= nil then data.HasMore else nextCursor ~= nil

	return { friends = v5, nextCursor = nextCursor, hasMore = v6 }
end

local function mergeListsWithoutDuplicates2(friends, list, p2)
	if list and #list ~= 0 then
		if not friends or #friends == 0 then
			return list
		end

		local set = Cryo.List.toSet(Cryo.List.map(friends, function(p3)
			if p2 then
				return p3[p2]
			end

			return p3
		end))

		local filtered = Cryo.List.filter(list, function(p3): boolean
			if p2 then
				p3 = p3[p2]
			end

			return not set[p3]
		end)

		return Cryo.List.join(table.clone(friends), filtered)
	elseif friends then
		return friends
	else
		return {}
	end
end

local function mergeAllFriendsPage(p2, findFriendsPageResponse, nextCursor)
	if not p2 then
		return {
			friends = findFriendsPageResponse.friends,
			nextCursor = findFriendsPageResponse.nextCursor,
			hasMore = findFriendsPageResponse.hasMore
		}
	end

	local nextCursor2 = p2.nextCursor

	if nextCursor2 == nil or nextCursor2 == "" then
		nextCursor2 = nil
	end

	if nextCursor == nil or nextCursor == "" then
		nextCursor = nil
	end

	if nextCursor2 ~= nextCursor then
		return p2
	end

	return {
		friends = if fFlagAddFriendsPageTrustedFriendRequestSection then mergeListsWithoutDuplicates(
			p2.friends,
			findFriendsPageResponse.friends,
			"id"
		) else mergeListsWithoutDuplicates2(p2.friends, findFriendsPageResponse.friends, "id"),
		nextCursor = findFriendsPageResponse.nextCursor,
		hasMore = findFriendsPageResponse.hasMore
	}
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

local function createFriendsStore()
	local v5 = PresenceStore.get()
	local v6

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v6 = nil
	else
		v6 = tostring(getLocalPlayerUserId())
	end

	local v7 = defineFastInt
	local v8 = createDataCache(not (v7 and v7 > 0) and 1e999 or v7)
	local v9 = defineFastInt2
	local v10 = createDataCache(not (v9 and v9 > 0) and 1e999 or v9)
	local v11 = defineFastInt3
	local v12 = createDataCache(not (v11 and v11 > 0) and 1e999 or v11)
	local flag = false

	local v13 = defineFastInt4
	local v14 = createDataCache(not (v13 and v13 > 0) and 1e999 or v13)
	local v15 = defineFastInt5
	local v16 = createDataCache(not (v15 and v15 > 0) and 1e999 or v15)

	local computeds = {}

	local function appendUserToAllFriends(p2)
		local v17

		if fFlagFriendSortedByPresenceSignalsImplementation then
			v17 = localUserIdStore.getCurrentUserId(false)

			if v17 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v17 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end
		else
			v17 = v6
		end

		local data = v12.getItem(v17).data(false)

		if data then
			local v18

			if fFlagAddFriendsPageTrustedFriendRequestSection then
				v18 = mergeListsWithoutDuplicates(data.friends, {
					{ id = p2 }
				}, "id")
			else
				v18 = mergeListsWithoutDuplicates2(data.friends, {
					{ id = p2 }
				}, "id")
			end

			if #v18 == #data.friends then
				return
			end

			v12.replaceItem(v17, {
				friends = v18,
				nextCursor = data.nextCursor,
				hasMore = data.hasMore
			})
		end
	end

	local function UpdateIsFriendsWith(p2, p3)
		v10.replaceItem(p2, p3)

		if p3 then
			appendUserToAllFriends(p2)
			v14.replaceItem(p2, Enum.FriendStatus.Friend)
		end

		if not p3 then
			v5.UpdateUserPresence(p2, nil, { isUpdatedRealtime = false })
		end
	end

	local function updateOnlineFriendDependecies(p2, p3)
		v5.UpdateUserPresence(p2, p3, { isUpdatedRealtime = true })
		v10.replaceItem(p2, true)

		appendUserToAllFriends(p2)
		v14.replaceItem(p2, Enum.FriendStatus.Friend)
	end

	local function updateOfflineFriendDependencies(id)
		local data = v5.GetPresenceByUserId(id, { skipFetch = true }).data(false)
		v5.UpdateUserPresence(id, data or normalizePresenceRawData({
			userPresenceType = PresenceType.Offline
		}), {
			isUpdatedRealtime = true
		})
		v10.replaceItem(id, true)

		appendUserToAllFriends(id)
		v14.replaceItem(id, Enum.FriendStatus.Friend)
	end

	local function applyGetOnlineFriendsResponseBody(p2)
		local storedOnlineFriendRows = {}

		for k, v17 in p2 and p2.data or {} do
			local id = v17.id
			local v18 = if id then tostring(id) else nil

			local storedOnlineFriendRow = normalizeStoredOnlineFriendRow(v17)
			local presenceFromOnlineFriendsRow = normalizePresenceFromOnlineFriendsRow(v17)

			if not v18 then
				continue
			end

			storedOnlineFriendRows[v18] = storedOnlineFriendRow
			v5.UpdateUserPresence(v18, presenceFromOnlineFriendsRow, {
				isUpdatedRealtime = true
			})
			v10.replaceItem(v18, true)

			appendUserToAllFriends(v18)
			v14.replaceItem(v18, Enum.FriendStatus.Friend)
		end

		return storedOnlineFriendRows
	end

	local v17 = createDataResolver({
		cache = v8,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			local v18 = p3.data(false) or {}

			return Requests.GetOnlineFriends(p2):andThen(function(p4)
				for k, v19 in v18 do
					local id = v19 and v19.id
					local v20 = if id then tostring(id) else nil

					if v20 then
						v5.UpdateUserPresence(v20, normalizePresenceRawData({
							userPresenceType = PresenceType.Offline
						}), {
							isUpdatedRealtime = true
						})
					end
				end

				return applyGetOnlineFriendsResponseBody(p4)
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local function fetchFriendshipStatuses(p2)
		local v18

		if fFlagFriendSortedByPresenceSignalsImplementation then
			v18 = localUserIdStore.getCurrentUserId(false)

			if v18 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v18 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end
		else
			v18 = v6
		end

		return Requests.MultiGetFriendshipStatuses(v18, p2):andThen(function(p3)
			local result = {}

			for k, v19 in p3 and p3.data or {} do
				local id = v19.id
				local v20 = if id then tostring(id) else nil

				if v20 then
					result[v20] = mapFriendshipStatusToEnum(v19.status)
				end
			end

			return result
		end)
	end

	local v18 = createDataResolver({
		cache = v10,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			local v19

			if fFlagFriendSortedByPresenceSignalsImplementation then
				v19 = localUserIdStore.getCurrentUserId(false)

				if v19 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v19 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end
			else
				v19 = v6
			end

			return Requests.MultiGetFriendshipStatuses(v19, keys):andThen(function(p3)
				local result = {}

				for k, v20 in p3 and p3.data or {} do
					local id = v20.id
					local v21 = if id then tostring(id) else nil

					if v21 then
						result[v21] = mapFriendshipStatusToEnum(v20.status)
					end
				end

				return result
			end):andThen(function(items)
				v14.replaceItems(items)
				local result = {}

				for k, item in items do
					result[k] = item == Enum.FriendStatus.Friend
				end

				return result
			end)
		end
	})
	local v19 = createDataResolver({
		cache = v14,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			local v20

			if fFlagFriendSortedByPresenceSignalsImplementation then
				v20 = localUserIdStore.getCurrentUserId(false)

				if v20 == "" then
					local localPlayerUserId = getLocalPlayerUserId()
					v20 = not localPlayerUserId and "" or tostring(localPlayerUserId)
				end
			else
				v20 = v6
			end

			return Requests.MultiGetFriendshipStatuses(v20, keys):andThen(function(p3)
				local result = {}

				for k, v21 in p3 and p3.data or {} do
					local id = v21.id
					local v22 = if id then tostring(id) else nil

					if v22 then
						result[v22] = mapFriendshipStatusToEnum(v21.status)
					end
				end

				return result
			end):andThen(function(items)
				local v21 = {}

				for k, item in items do
					v21[k] = item == Enum.FriendStatus.Friend
				end

				v10.replaceItems(v21)
				return items
			end)
		end
	})

	local v20 = createDataResolver({
		cache = v12,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			local v21 = if not flag then p3.data(false) else nil
			flag = false

			local nextCursor = if v21 then v21.nextCursor else nil
			local v22 = if v21 then defineFastInt6 else defineFastInt7
			return Requests.GetFindFriendsPage(p2, {
				limit = v22,
				cursor = nextCursor,
				sort = FindFriendsSort.FriendshipScore
			}):andThen(function(p4)
				local findFriendsPageResponse = normalizeFindFriendsPageResponse(p4)

				for k, friend in findFriendsPageResponse.friends do
					updateOfflineFriendDependencies(friend.id)
				end

				return mergeAllFriendsPage(v21, findFriendsPageResponse, nextCursor)
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local v21 = createDataResolver({
		cache = v16,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2)
			return Requests.GetFriendsCountFromUserId(p2):andThen(function(p3)
				if p3 then
					return p3.count
				end

				return 0
			end)
		end
	})

	local computed = Signals.createComputed(function(p2)
		local v22 = localUserIdStore.getCurrentUserId(p2)

		if v22 == "" then
			local localPlayerUserId = getLocalPlayerUserId()
			v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
		end

		local data = v17.getAndFetchItem(v22).data(p2)

		if data == nil then
			return nil
		end

		local result = {}

		for k, v23 in pairs(data) do
			if not v23 then
				continue
			end

			local data2 = v5.GetPresenceByUserId(v23.id, { skipFetch = true }).data(p2)

			if not (v18.getCachedItem(v23.id).data(p2) and data2 and data2.userPresenceType and data2.userPresenceType ~= PresenceType.Offline) then
				continue
			end

			table.insert(result, {
				id = v23.id,
				sortScore = v23.sortScore,
				presence = data2
			})
		end

		if fFlagFriendsStoreSortOnlineFriendsByRank then
			table.sort(result, function(a, b): boolean
				return a.sortScore > b.sortScore
			end)
		end

		return result
	end)

	local computed2 = Signals.createComputed(function(p2)
		local v22 = localUserIdStore.getCurrentUserId(p2)

		if v22 == "" then
			local localPlayerUserId = getLocalPlayerUserId()
			v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
		end

		return v17.getCachedItem(v22).status(p2)
	end)

	local computed3 = Signals.createComputed(function(p2)
		local v22 = localUserIdStore.getCurrentUserId(p2)

		if v22 == "" then
			local localPlayerUserId = getLocalPlayerUserId()
			v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
		end

		local data = v20.getAndFetchItem(v22).data(p2)

		if data == nil then
			return nil
		end

		local friends = data.friends or {}

		return {
			friends = Cryo.List.filter(friends, function(p3)
				return v18.getCachedItem(p3.id).data(p2)
			end),
			hasMore = data.hasMore,
			nextCursor = data.nextCursor
		}
	end)

	local computed4 = Signals.createComputed(function(p2)
		local v22 = localUserIdStore.getCurrentUserId(p2)

		if v22 == "" then
			local localPlayerUserId = getLocalPlayerUserId()
			v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
		end

		return v20.getCachedItem(v22).status(p2)
	end)
	return {
		GetOnlineFriends = function()
			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			v17.getAndFetchItem(v22)

			return computed
		end,
		GetOnlineFriendsStatus = function()
			return computed2
		end,
		RefetchOnlineFriends = function()
			local fetchItem = v17.fetchItem
			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			fetchItem(v22)
		end,
		GetOnlineFriendsByUniverseId = function(p2)
			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			v17.getAndFetchItem(v22)

			local v23 = computeds[p2]

			if v23 then
				return v23
			end

			local computed3 = Signals.createComputed(function(p3)
				local v24 = computed(p3)

				if not v24 then
					return {}
				end

				local result = {}

				for k, v25 in v24 do
					if v25.presence and v25.presence.universeId == p2 then
						table.insert(result, v25)
					end
				end

				return result
			end)

			computeds[p2] = computed3
			return computed3
		end,
		GetAllFriends = function()
			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			v20.getAndFetchItem(v22)

			return computed3
		end,
		GetAllFriendsStatus = function()
			return computed4
		end,
		FetchMoreFriends = function()
			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			local cachedItem = v20.getCachedItem(v22)
			local data = cachedItem.data(false)

			if
				data == nil
				or not data.hasMore
				or data.nextCursor == nil
				or cachedItem.status(false) == dataStatus.NotReady
			then
				return
			end

			if v20.isRequestInQueueOrInFlight(v22) then
				return
			end

			v20.fetchItem(v22)
		end,
		RefetchAllFriends = function()
			flag = true

			local fetchItem = v20.fetchItem
			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			fetchItem(v22)
		end,
		GetIsFriendWith = function(p2)
			return v18.getAndFetchItem(p2)
		end,
		UpdateIsFriendsWith = UpdateIsFriendsWith,
		GetFriendsCountByUserId = function(p2, p3)
			if p3 and p3.skipFetch then
				return v21.getCachedItem(p2)
			end

			return v21.getAndFetchItem(p2)
		end,
		RefreshFriendsCountByUserId = function(p2)
			v21.fetchItem(p2)
		end,
		clear = function()
			v17.clear()
			v18.clear()
			v20.clear()
			v19.clear()
			v21.clear()
			table.clear(computeds)
		end,
		dispose = function()
			v17.dispose()
			v18.dispose()
			v20.dispose()
			v19.dispose()
			v21.dispose()
			table.clear(computeds)
		end,
		_fetchOnlineFriendsAsync = function()
			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			return Requests.GetOnlineFriends(v22):andThen(function(p2)
				local v23 = applyGetOnlineFriendsResponseBody(p2)
				v8.replaceItems({ [v22] = v23 })
				return p2 or { data = nil }
			end):catch(function(message)
				error(message)
			end)
		end,
		_getCachedFriendsPresences = function()
			if not FFlagPresenceRefetchTelemetryEnabled then
				return nil
			end

			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			local data = v17.getCachedItem(v22).data(false)

			if data == nil then
				return nil
			end

			local result = {}

			for k, v23 in pairs(data) do
				if v23 then
					table.insert(result, {
						id = v23.id,
						presence = v5.GetPresenceByUserId(v23.id, { skipFetch = true }).data(false)
					})
				end
			end

			return result
		end,
		_getFetchedFriendIds = function()
			if not FFlagPresenceRefetchTelemetryEnabled then
				return nil
			end

			local v22 = localUserIdStore.getCurrentUserId(false)

			if v22 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v22 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			local data = v17.getCachedItem(v22).data(false)
			local data2 = v20.getCachedItem(v22).data(false)

			if data == nil and data2 == nil then
				return nil
			end

			local idSet = {}

			if data2 then
				for k, friend in data2.friends do
					idSet[friend.id] = true
				end
			end

			if data then
				for k, v23 in pairs(data) do
					if v23 then
						idSet[v23.id] = true
					end
				end
			end

			return idSet
		end,
		_updateFriendsPresences = function(items, options, p2)
			if not items then
				return
			end

			local v22 = options or {}

			local storedOnlineFriendRows = {}

			for k, item in pairs(items) do
				local userId = item.userId
				local v23 = if userId then tostring(userId) else nil

				if not v23 then
					continue
				end

				local storedOnlineFriendRow = normalizeStoredOnlineFriendRow({
					id = v23,
					sortScore = v22[v23]
				})

				local v24 = normalizePresenceRawData(item)
				storedOnlineFriendRows[v23] = storedOnlineFriendRow
				v5.UpdateUserPresence(v23, v24, { isUpdatedRealtime = true })
				v10.replaceItem(v23, true)

				appendUserToAllFriends(v23)
				v14.replaceItem(v23, Enum.FriendStatus.Friend)
			end

			local updateItem = v8.updateItem
			local v23 = localUserIdStore.getCurrentUserId(false)

			if v23 == "" then
				local localPlayerUserId = getLocalPlayerUserId()
				v23 = not localPlayerUserId and "" or tostring(localPlayerUserId)
			end

			updateItem(v23, storedOnlineFriendRows)
		end,
		GetFriendshipStatus = function(p2, p3)
			if p2 == "" then
				return nil
			end

			if p3 and p3.skipFetch then
				return v19.getCachedItem(p2)
			end

			return v19.getAndFetchItem(p2)
		end,
		UpdateFriendshipStatus = function(p2, p3)
			v14.replaceItem(p2, p3)

			UpdateIsFriendsWith(p2, p3 == Enum.FriendStatus.Friend)
		end,
		RefetchFriendshipStatus = function(p2)
			if p2 == "" then
				return
			end

			v19.fetchItem(p2)
		end,
		RequestFriendship = function(p2, p3, p4, p5)
			if not fFlagEnableFriendsStoreChallengeInterceptor then
				p5 = nil
			end

			local v22

			if p4 and p4.isContact then
				v22 = Requests.RequestFriendshipFromContactId(p2, p5)
			else
				v22 = Requests.RequestFriendshipFromUserId(p2, p3, p5)
			end

			return v22:andThen(function()
				local v23 = p2
				local friendRequestSent = Enum.FriendStatus.FriendRequestSent
				v14.replaceItem(v23, friendRequestSent)

				UpdateIsFriendsWith(v23, friendRequestSent == Enum.FriendStatus.Friend)
			end):catch(function(message)
				local v23 = if type(message) == "table" then message.firstErrorCode else nil

				if v23 ~= 5 then
					error(message)
					return
				end

				local v24 = p2
				local friend = Enum.FriendStatus.Friend
				v14.replaceItem(v24, friend)

				UpdateIsFriendsWith(v24, friend == Enum.FriendStatus.Friend)
			end)
		end,
		AcceptFriendRequest = function(p2)
			return Requests.AcceptFriendRequestFromUserId(p2):andThen(function()
				local v22 = p2
				local friend = Enum.FriendStatus.Friend
				v14.replaceItem(v22, friend)

				UpdateIsFriendsWith(v22, friend == Enum.FriendStatus.Friend)
			end):catch(function(message)
				local v22 = if type(message) == "table" then message.firstErrorCode else nil

				if v22 ~= 5 then
					error(message)
					return
				end

				local v23 = p2
				local friend = Enum.FriendStatus.Friend
				v14.replaceItem(v23, friend)

				UpdateIsFriendsWith(v23, friend == Enum.FriendStatus.Friend)
			end)
		end,
		DeclineFriendRequest = function(p2)
			return Requests.DeclineFriendRequestFromUserId(p2):andThen(function()
				local v22 = p2
				local notFriend = Enum.FriendStatus.NotFriend
				v14.replaceItem(v22, notFriend)

				UpdateIsFriendsWith(v22, notFriend == Enum.FriendStatus.Friend)
			end)
		end,
		Unfriend = function(p2)
			return Requests.UnfriendTargetUserId(p2):andThen(function()
				local v22 = p2
				local notFriend = Enum.FriendStatus.NotFriend
				v14.replaceItem(v22, notFriend)

				UpdateIsFriendsWith(v22, notFriend == Enum.FriendStatus.Friend)
			end)
		end
	}
end

return createFriendsStore
