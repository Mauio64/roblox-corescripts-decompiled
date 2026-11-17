local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local Promise = require(parent.Promise)
local Cryo = require(parent.Cryo)

local Requests = require(DataHydration.TrustedConnections.Requests)
local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)

local createTrustedConnectionEventListener = require(DataHydration.TrustedConnections.createTrustedConnectionEventListener)
local createFriendshipEventListener = require(DataHydration.TrustedConnections.createFriendshipEventListener)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local DataHydrationUtils2 = require(DataHydration.DataHydrationUtils)
local mergeListsWithoutDuplicates = DataHydrationUtils2.mergeListsWithoutDuplicates
local SharedFlags = require(parent.SharedFlags)
local FFlagConnectionManagementChips = SharedFlags.FFlagConnectionManagementChips

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddFriendsPageTrustedFriendRequestSection = SharedFlags2.FFlagAddFriendsPageTrustedFriendRequestSection

local SharedFlags3 = require(parent.SharedFlags)
local FFlagAddFriendsPageHighlightUnseenTrustedRequests = SharedFlags3.FFlagAddFriendsPageHighlightUnseenTrustedRequests

local SharedFlags4 = require(parent.SharedFlags)
local FIntTrustedFriendRequestsPageSize = SharedFlags4.FIntTrustedFriendRequestsPageSize
local SharedFlags5 = require(parent.SharedFlags)
local FFlagProfileTFCardUseQrScanContext = SharedFlags5.FFlagProfileTFCardUseQrScanContext
local SharedFlags6 = require(parent.SharedFlags)
local FFlagTrustedFriendCandidatesSection = SharedFlags6.FFlagTrustedFriendCandidatesSection

local defineFastInt = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)

game:DefineFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec", 0)

local defineFastInt2 = game:DefineFastInt("TrustedFriendCandidatesPageSize", 20)

local defineFastInt3 = game:DefineFastInt("TrustedFriendCandidatesMaxReadsPerFetch", 5)

local v = {
	None = TrustedConnectionStatus.Friends,
	RequestSent = TrustedConnectionStatus.RequestSent,
	RequestReceived = TrustedConnectionStatus.RequestReceived
}

local function fn() -- 3 equivalent calls inferred from this helper
	return game:GetFastInt("TrustedConnectionsStoreProcessDelaySec")
end

local function fn2() -- 2 equivalent calls inferred from this helper
	return game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec")
end

local function createTrustedConnectionsStore()
	local v2 = not (defineFastInt > 0) and 1e999 or defineFastInt
	local dataCache = createDataCache(v2)
	local dataCache2 = createDataCache(v2)
	local cache

	if FFlagConnectionManagementChips then
		cache = createDataCache(v2)
	else
		cache = nil
	end

	local cache2

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		cache2 = createDataCache(v2)
	else
		cache2 = nil
	end

	local cache3

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		cache3 = createDataCache(v2)
	else
		cache3 = nil
	end

	local flag = false
	local cache4

	if FFlagTrustedFriendCandidatesSection then
		cache4 = createDataCache(v2)
	else
		cache4 = nil
	end

	local v3

	if FFlagTrustedFriendCandidatesSection then
		v3 = false
	else
		v3 = nil
	end

	local fn3 = FFlagAddFriendsPageTrustedFriendRequestSection and function(id: string)
		local v4 = tostring(getLocalPlayerUserId())
		local data = cache2.getItem(v4).data(false)

		if not data then
			return
		end

		if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
			local requests = data.requests

			if not requests then
				return
			end

			local requests2 = mergeListsWithoutDuplicates({
				{ id = id, isUnseen = true }
			}, requests, "id")

			if #requests2 == #requests then
				return
			end

			cache2.replaceItem(v4, {
				senderIds = nil,
				requests = requests2,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		else
			local senderIds = mergeListsWithoutDuplicates(data.senderIds, { id })

			if #senderIds == #data.senderIds then
				return
			end

			cache2.replaceItem(v4, {
				senderIds = senderIds,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = cache3.getItem(v4).data(false)

		if data2 then
			cache3.replaceItem(v4, (math.max(data2 + 1, 0)))
		end
	end or nil

	local fn4 = FFlagAddFriendsPageTrustedFriendRequestSection and function(p: string)
		local v4 = tostring(getLocalPlayerUserId())
		local data = cache2.getItem(v4).data(false)

		if not data then
			return
		end

		if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
			local requests = data.requests

			if not requests then
				return
			end

			local filtered = Cryo.List.filter(requests, function(p2): boolean
				return p2.id ~= p
			end)

			if #filtered == #requests then
				return
			end

			cache2.replaceItem(v4, {
				senderIds = nil,
				requests = filtered,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		else
			local senderIds = Cryo.List.removeValue(data.senderIds, p)

			if #senderIds == #data.senderIds then
				return
			end

			cache2.replaceItem(v4, {
				senderIds = senderIds,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = cache3.getItem(v4).data(false)

		if data2 then
			cache3.replaceItem(v4, (math.max(data2 - 1, 0)))
		end
	end or nil

	local fn5 = FFlagTrustedFriendCandidatesSection and function(p: string)
		local v4 = tostring(getLocalPlayerUserId())
		local data = cache4.getItem(v4).data(false)

		if not data then
			return
		end

		local filtered = Cryo.List.filter(data.candidates, function(p2): boolean
			return p2.id ~= p
		end)

		if #filtered == #data.candidates then
			return
		end

		cache4.replaceItem(v4, {
			candidates = filtered,
			nextPageCursor = data.nextPageCursor,
			hasMore = data.hasMore
		})
	end or nil
	local v4

	if FFlagConnectionManagementChips then
		v4 = createDataResolver({
			cache = cache,
			supportsMultiGet = false,
			queueProcessDelaySec = fn(), -- inferred equivalent call
			replaceItems = true,
			fetchFn = function(p: string)
				return Requests.GetUserTrustedConnections(p):andThen(function(p2)
					local pageItems = p2.PageItems or {}
					return Cryo.List.map(pageItems, function(p3)
						return { id = tostring(p3.id) }
					end)
				end)
			end
		})
	else
		v4 = nil
	end

	local trustedConnectionEventListener = createTrustedConnectionEventListener(function(p: string, p2)
		dataCache.updateItems({ [p] = p2 })

		dataCache2.updateItems({
			[p] = p2 == TrustedConnectionStatus.TrustedFriends
		})

		if FFlagAddFriendsPageTrustedFriendRequestSection and p2 == TrustedConnectionStatus.RequestReceived then
			fn3(p)
		end

		if FFlagTrustedFriendCandidatesSection and p2 == TrustedConnectionStatus.TrustedFriends then
			fn5(p)
		end

		local v5 = FFlagConnectionManagementChips and getLocalPlayerUserId()

		if v5 then
			v4.fetchItem((tostring(v5)))
		end
	end)
	local v5

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		v5 = createFriendshipEventListener(function(p: string, p2)
			dataCache.updateItems({ [p] = p2 })

			dataCache2.updateItems({
				[p] = p2 == TrustedConnectionStatus.TrustedFriends
			})

			if p2 == TrustedConnectionStatus.NotFriends then
				fn4(p)

				if FFlagTrustedFriendCandidatesSection then
					fn5(p)
				end
			end
		end)
	else
		v5 = nil
	end

	local dataResolver = createDataResolver({
		cache = dataCache2,
		queueProcessDelaySec = fn(), -- inferred equivalent call
		fetchFn = function(p)
			local keys = Cryo.Dictionary.keys(p)
			return Requests.MultiGetUsersAreTrustedConnections(keys):andThen(function(p2)
				local foldLeft = Cryo.List.foldLeft(p2, function(p3, p4)
					p3[tostring(p4)] = true
					return p3
				end, {})

				return Cryo.List.foldLeft(keys, function(p3, p4)
					p3[tostring(p4)] = foldLeft[p4] or false
					return p3
				end, {})
			end)
		end
	})

	local dataResolver2 = createDataResolver({
		cache = dataCache,
		queueProcessDelaySec = fn(), -- inferred equivalent call
		fetchFn = function(p)
			local keys = Cryo.Dictionary.keys(p)
			local foldLeft = Cryo.List.foldLeft(keys, function(list, p2)
				table.insert(list, Requests.GetUserTrustedConnectionStatus(p2):andThen(function(p3)
					return { [p2] = p3 }
				end))

				return list
			end, {})

			return Promise.all(foldLeft):andThen(function(list)
				return Cryo.Dictionary.join(table.unpack(list))
			end)
		end
	})
	local v6

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		v6 = createDataResolver({
			cache = cache2,
			supportsMultiGet = false,
			replaceItems = true,
			queueProcessDelaySec = fn2(), -- inferred equivalent call
			fetchFn = function(_: string, p)
				local v7

				if flag then
					v7 = nil
				else
					v7 = p.data(false)
				end

				flag = false
				local v8

				if v7 then
					v8 = v7.nextPageCursor
				end

				return Requests.GetTrustedFriendRequests(v8, FIntTrustedFriendRequestsPageSize):andThen(function(p2)
					if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
						local v9

						if p2 then
							v9 = p2.data
						end

						local mapped = Cryo.List.map(v9 or {}, function(p3)
							return { id = tostring(p3.senderId), isUnseen = p3.isUnseen }
						end)
						local requests

						if v7 then
							requests = v7.requests
						end

						local nextPageCursor

						if p2 then
							nextPageCursor = p2.nextPageCursor
						end

						return {
							senderIds = nil,
							requests = mergeListsWithoutDuplicates(requests, mapped, "id"),
							nextPageCursor = nextPageCursor,
							hasMore = nextPageCursor ~= nil
						}
					else
						local v9

						if p2 then
							v9 = p2.data
						end

						local mapped = Cryo.List.map(v9 or {}, function(p3)
							return (tostring(p3.senderId))
						end)
						local senderIds

						if v7 then
							senderIds = v7.senderIds
						end

						local nextPageCursor

						if p2 then
							nextPageCursor = p2.nextPageCursor
						end

						return {
							senderIds = mergeListsWithoutDuplicates(senderIds, mapped),
							nextPageCursor = nextPageCursor,
							hasMore = nextPageCursor ~= nil
						}
					end
				end)
			end
		})
	else
		v6 = nil
	end

	local v7

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		v7 = createDataResolver({
			cache = cache3,
			supportsMultiGet = false,
			replaceItems = true,
			queueProcessDelaySec = fn2(), -- inferred equivalent call
			fetchFn = function(_: string)
				return Requests.GetTrustedFriendRequestsCount():andThen(function(p)
					return if p then p.count else 0
				end)
			end
		})
	else
		v7 = nil
	end

	local function fetchTrustedFriendCandidatesPage(nextPageCursor: string?, p: number)
		return Requests.GetTrustedFriendCandidates(nextPageCursor, defineFastInt2):andThen(function(p2)
			local v8 = not (p2 and p2.data) and {} or p2.data
			local nextPageCursor2

			if p2 then
				nextPageCursor2 = p2.nextPageCursor
			end

			local candidates = {}
			local statuses = {}

			for _, v9 in v8 do
				local userId = tostring(v9.userId)
				table.insert(candidates, { id = userId })
				statuses[userId] = v[v9.state]
			end

			if #candidates == 0 and nextPageCursor2 ~= nil and p > 1 then
				return fetchTrustedFriendCandidatesPage(nextPageCursor2, p - 1)
			end

			return {
				candidates = candidates,
				statuses = statuses,
				nextPageCursor = nextPageCursor2
			}
		end)
	end

	local function applyTrustedFriendCandidatesPage(data, p)
		dataCache.updateItems(data.statuses)
		local v8

		if p then
			v8 = p.candidates
		end

		return {
			candidates = mergeListsWithoutDuplicates(v8, data.candidates, "id"),
			nextPageCursor = data.nextPageCursor,
			hasMore = data.nextPageCursor ~= nil
		}
	end

	local v8

	if FFlagTrustedFriendCandidatesSection then
		v8 = createDataResolver({
			cache = cache4,
			supportsMultiGet = false,
			replaceItems = true,
			fetchFn = function(_: string, p)
				local v9 = v3
				v3 = false
				local v10

				if not v9 then
					v10 = p.data(false)
				end

				local nextPageCursor

				if v10 then
					nextPageCursor = v10.nextPageCursor
				end

				local v11 = defineFastInt3
				return Requests.GetTrustedFriendCandidates(nextPageCursor, defineFastInt2):andThen(function(p2)
					local v12 = not (p2 and p2.data) and {} or p2.data
					local nextPageCursor2

					if p2 then
						nextPageCursor2 = p2.nextPageCursor
					end

					local candidates = {}
					local statuses = {}

					for _, v13 in v12 do
						local userId = tostring(v13.userId)
						table.insert(candidates, { id = userId })
						statuses[userId] = v[v13.state]
					end

					if #candidates == 0 and nextPageCursor2 ~= nil and v11 > 1 then
						return fetchTrustedFriendCandidatesPage(nextPageCursor2, v11 - 1)
					end

					return {
						candidates = candidates,
						statuses = statuses,
						nextPageCursor = nextPageCursor2
					}
				end):andThen(function(p2)
					local v12

					if not v9 then
						v12 = p.data(false)
					end

					return applyTrustedFriendCandidatesPage(p2, v12)
				end)
			end
		})
	else
		v8 = nil
	end

	local fn6 = FFlagConnectionManagementChips and function()
		local localPlayerUserId = getLocalPlayerUserId()
		return v4.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn7 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v9 = tostring(getLocalPlayerUserId())
		v7.fetchItem(v9)
	end or nil

	local fn8 = FFlagAddFriendsPageTrustedFriendRequestSection and function(p)
		if FFlagAddFriendsPageHighlightUnseenTrustedRequests and p and p.forceFetch then
			fn7()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v7.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn9 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v9 = tostring(getLocalPlayerUserId())
		local data = cache2.getItem(v9).data(false)

		if data and not data.hasMore then
			return
		end

		v6.fetchItem(v9)
	end or nil

	local fn10 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		flag = true

		local v9 = tostring(getLocalPlayerUserId())
		v6.fetchItem(v9)
	end or nil

	local fn11 = FFlagAddFriendsPageTrustedFriendRequestSection and function(p)
		if FFlagAddFriendsPageHighlightUnseenTrustedRequests and p and p.forceFetch then
			fn10()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v6.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn12 = FFlagTrustedFriendCandidatesSection and function()
		v3 = true

		local v9 = tostring(getLocalPlayerUserId())

		v8.refetchItem(v9)
	end or nil

	local fn13 = FFlagTrustedFriendCandidatesSection and function(p)
		if p and p.forceFetch then
			fn12()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v8.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn14 = FFlagTrustedFriendCandidatesSection and function()
		local v9 = tostring(getLocalPlayerUserId())
		local data = cache4.getItem(v9).data(false)

		if data and not data.hasMore then
			return
		end

		v8.fetchItem(v9)
	end or nil

	local fn15 = FFlagTrustedFriendCandidatesSection and function(p: string)
		return dataResolver2.refetchItem(p)
	end or nil

	local function fn16(p: string, p2: string?)
		return Requests.PostUserSendTrustedConnectionRequest(p, p2):andThen(function(p3)
			if FFlagProfileTFCardUseQrScanContext and p3 and p3.responseBody and p3.responseBody.success == false then
				return Promise.reject("Trusted connection request was not sent")
			end

			dataCache.updateItems({ [p] = TrustedConnectionStatus.RequestSent })

			return nil
		end)
	end

	local function fn17(p: string)
		return Requests.PostUserAcceptTrustedConnectionRequest(p):andThen(function()
			dataCache.updateItems({ [p] = TrustedConnectionStatus.TrustedFriends })

			dataCache2.updateItems({ [p] = true })

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				fn4(p)
			end

			if FFlagTrustedFriendCandidatesSection then
				fn5(p)
			end
		end)
	end

	local function fn18(p: string)
		return Requests.PostUserIgnoreTrustedConnectionRequest(p):andThen(function()
			dataCache.updateItems({ [p] = TrustedConnectionStatus.RequestIgnored })

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				fn4(p)
			end
		end)
	end

	local fn19 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		return Requests.PostUserIgnoreAllTrustedFriendRequests():andThen(function()
			local v9 = tostring(getLocalPlayerUserId())

			if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
				cache2.replaceItem(v9, {
					senderIds = nil,
					requests = {},
					nextPageCursor = nil,
					hasMore = false
				})
			else
				cache2.replaceItem(v9, { senderIds = {}, nextPageCursor = nil, hasMore = false })
			end

			cache3.replaceItem(v9, 0)

			if FFlagTrustedFriendCandidatesSection then
				dataResolver2.clear()
			end
		end)
	end or nil

	local function fn20(p: string)
		return Requests.PostUserRemoveTrustedConnection(p):andThen(function()
			dataCache.updateItems({ [p] = TrustedConnectionStatus.RequestReceived })

			dataCache2.updateItems({ [p] = false })
		end)
	end

	local function fn21(p: string)
		return Requests.PostUserCreateTrustedFriendLink(p)
	end

	local function fn22(p: string, p2)
		return Requests.PostUserValidateTrustedFriendLink(p, p2)
	end

	local function fn23(p: string, p2)
		return Requests.PostUserAddTrustedFriendFromLink(p, p2)
	end

	if not FFlagConnectionManagementChips then
		fn6 = nil
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn11 = nil
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn8 = nil
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn9 = nil
	end

	local refetchTrustedFriendRequests

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		refetchTrustedFriendRequests = fn10
	end

	local refetchTrustedFriendRequestsCount

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		refetchTrustedFriendRequestsCount = fn7
	end

	if not FFlagTrustedFriendCandidatesSection then
		fn13 = nil
	end

	if not FFlagTrustedFriendCandidatesSection then
		fn14 = nil
	end

	local refetchTrustedFriendCandidates

	if FFlagTrustedFriendCandidatesSection then
		refetchTrustedFriendCandidates = fn12
	end

	if not FFlagTrustedFriendCandidatesSection then
		fn15 = nil
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn19 = nil
	end

	return {
		getStatus = function(p: string)
			return dataResolver2.getAndFetchItem(p)
		end,
		getIsTrustedConnection = function(p: string)
			return dataResolver.getAndFetchItem(p)
		end,
		getUserTrustedConnections = fn6,
		getTrustedFriendRequests = fn11,
		getTrustedFriendRequestsCount = fn8,
		loadMoreTrustedFriendRequests = fn9,
		refetchTrustedFriendRequests = refetchTrustedFriendRequests,
		refetchTrustedFriendRequestsCount = refetchTrustedFriendRequestsCount,
		getTrustedFriendCandidates = fn13,
		loadMoreTrustedFriendCandidates = fn14,
		refetchTrustedFriendCandidates = refetchTrustedFriendCandidates,
		refetchStatus = fn15,
		sendTrustedConnectionRequest = fn16,
		acceptTrustedConnectionRequest = fn17,
		ignoreTrustedConnectionRequest = fn18,
		ignoreAllTrustedFriendRequests = fn19,
		removeTrustedConnectionRequest = fn20,
		createTrustedFriendLink = fn21,
		validateTrustedFriendLink = fn22,
		addTrustedFriendFromLink = fn23,
		clear = function()
			dataCache.clear()
			dataCache2.clear()
			dataResolver.clear()
			dataResolver2.clear()

			if FFlagConnectionManagementChips then
				cache.clear()
				v4.clear()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				cache2.clear()
				v6.clear()
				cache3.clear()
				v7.clear()
			end

			if FFlagTrustedFriendCandidatesSection then
				cache4.clear()
				v8.clear()
			end
		end,
		dispose = function()
			dataCache.dispose()
			dataCache2.dispose()
			dataResolver.dispose()
			dataResolver2.dispose()
			trustedConnectionEventListener()

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v5()
			end

			if FFlagConnectionManagementChips then
				cache.dispose()
				v4.dispose()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				cache2.dispose()
				v6.dispose()
				cache3.dispose()
				v7.dispose()
			end

			if FFlagTrustedFriendCandidatesSection then
				cache4.dispose()
				v8.dispose()
			end
		end
	}
end

return createTrustedConnectionsStore
