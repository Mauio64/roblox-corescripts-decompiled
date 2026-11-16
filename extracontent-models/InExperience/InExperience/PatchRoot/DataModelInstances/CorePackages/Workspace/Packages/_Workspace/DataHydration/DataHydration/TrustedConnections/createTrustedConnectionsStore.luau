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
local FFlagTCShareLinkReceiverUI = SharedFlags.FFlagTCShareLinkReceiverUI
local SharedFlags2 = require(parent.SharedFlags)
local FFlagConnectionManagementChips = SharedFlags2.FFlagConnectionManagementChips

local SharedFlags3 = require(parent.SharedFlags)
local FFlagAddFriendsPageTrustedFriendRequestSection = SharedFlags3.FFlagAddFriendsPageTrustedFriendRequestSection

local SharedFlags4 = require(parent.SharedFlags)
local FFlagAddFriendsPageHighlightUnseenTrustedRequests = SharedFlags4.FFlagAddFriendsPageHighlightUnseenTrustedRequests

local SharedFlags5 = require(parent.SharedFlags)
local FIntTrustedFriendRequestsPageSize = SharedFlags5.FIntTrustedFriendRequestsPageSize
local SharedFlags6 = require(parent.SharedFlags)
local FFlagProfileTFCardUseQrScanContext = SharedFlags6.FFlagProfileTFCardUseQrScanContext

local defineFastInt = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)

game:DefineFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec", 0)

local function fn() -- 3 equivalent calls inferred from this helper
	return game:GetFastInt("TrustedConnectionsStoreProcessDelaySec")
end

local function fn2() -- 2 equivalent calls inferred from this helper
	return game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec")
end

local function createTrustedConnectionsStore()
	local v = not (defineFastInt > 0) and 1e999 or defineFastInt
	local dataCache = createDataCache(v)
	local dataCache2 = createDataCache(v)
	local cache

	if FFlagConnectionManagementChips then
		cache = createDataCache(v)
	else
		cache = nil
	end

	local cache2

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		cache2 = createDataCache(v)
	else
		cache2 = nil
	end

	local cache3

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		cache3 = createDataCache(v)
	else
		cache3 = nil
	end

	local flag = false

	local fn3 = FFlagAddFriendsPageTrustedFriendRequestSection and function(id: string)
		local v2 = tostring(getLocalPlayerUserId())
		local data = cache2.getItem(v2).data(false)

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

			cache2.replaceItem(v2, {
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

			cache2.replaceItem(v2, {
				senderIds = senderIds,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = cache3.getItem(v2).data(false)

		if data2 then
			cache3.replaceItem(v2, (math.max(data2 + 1, 0)))
		end
	end or nil

	local fn4 = FFlagAddFriendsPageTrustedFriendRequestSection and function(p: string)
		local v2 = tostring(getLocalPlayerUserId())
		local data = cache2.getItem(v2).data(false)

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

			cache2.replaceItem(v2, {
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

			cache2.replaceItem(v2, {
				senderIds = senderIds,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = cache3.getItem(v2).data(false)

		if data2 then
			cache3.replaceItem(v2, (math.max(data2 - 1, 0)))
		end
	end or nil
	local v2

	if FFlagConnectionManagementChips then
		v2 = createDataResolver({
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
		v2 = nil
	end

	local trustedConnectionEventListener = createTrustedConnectionEventListener(function(p: string, p2)
		dataCache.updateItems({ [p] = p2 })

		dataCache2.updateItems({
			[p] = p2 == TrustedConnectionStatus.TrustedFriends
		})

		if FFlagAddFriendsPageTrustedFriendRequestSection and p2 == TrustedConnectionStatus.RequestReceived then
			fn3(p)
		end

		local v3 = FFlagConnectionManagementChips and getLocalPlayerUserId()

		if v3 then
			v2.fetchItem((tostring(v3)))
		end
	end)
	local v3

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		v3 = createFriendshipEventListener(function(p: string, p2)
			dataCache.updateItems({ [p] = p2 })

			dataCache2.updateItems({
				[p] = p2 == TrustedConnectionStatus.TrustedFriends
			})

			if p2 == TrustedConnectionStatus.NotFriends then
				fn4(p)
			end
		end)
	else
		v3 = nil
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
	local v4

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		v4 = createDataResolver({
			cache = cache2,
			supportsMultiGet = false,
			replaceItems = true,
			queueProcessDelaySec = fn2(), -- inferred equivalent call
			fetchFn = function(_: string, p)
				local v5

				if flag then
					v5 = nil
				else
					v5 = p.data(false)
				end

				flag = false
				local v6

				if v5 then
					v6 = v5.nextPageCursor
				end

				return Requests.GetTrustedFriendRequests(v6, FIntTrustedFriendRequestsPageSize):andThen(function(p2)
					if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
						local v7

						if p2 then
							v7 = p2.data
						end

						local mapped = Cryo.List.map(v7 or {}, function(p3)
							return { id = tostring(p3.senderId), isUnseen = p3.isUnseen }
						end)
						local requests

						if v5 then
							requests = v5.requests
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
						local v7

						if p2 then
							v7 = p2.data
						end

						local mapped = Cryo.List.map(v7 or {}, function(p3)
							return (tostring(p3.senderId))
						end)
						local senderIds

						if v5 then
							senderIds = v5.senderIds
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
		v4 = nil
	end

	local v5

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		v5 = createDataResolver({
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
		v5 = nil
	end

	local fn5 = FFlagConnectionManagementChips and function()
		local localPlayerUserId = getLocalPlayerUserId()
		return v2.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn6 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v6 = tostring(getLocalPlayerUserId())
		v5.fetchItem(v6)
	end or nil

	local fn7 = FFlagAddFriendsPageTrustedFriendRequestSection and function(p)
		if FFlagAddFriendsPageHighlightUnseenTrustedRequests and p and p.forceFetch then
			fn6()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v5.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn8 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v6 = tostring(getLocalPlayerUserId())
		local data = cache2.getItem(v6).data(false)

		if data and not data.hasMore then
			return
		end

		v4.fetchItem(v6)
	end or nil

	local fn9 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		flag = true

		local v6 = tostring(getLocalPlayerUserId())
		v4.fetchItem(v6)
	end or nil

	local fn10 = FFlagAddFriendsPageTrustedFriendRequestSection and function(p)
		if FFlagAddFriendsPageHighlightUnseenTrustedRequests and p and p.forceFetch then
			fn9()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v4.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local function fn11(p: string, p2: string?)
		return Requests.PostUserSendTrustedConnectionRequest(p, p2):andThen(function(p3)
			if FFlagProfileTFCardUseQrScanContext and p3 and p3.responseBody and p3.responseBody.success == false then
				return Promise.reject("Trusted connection request was not sent")
			end

			dataCache.updateItems({ [p] = TrustedConnectionStatus.RequestSent })

			return nil
		end)
	end

	local function fn12(p: string)
		return Requests.PostUserAcceptTrustedConnectionRequest(p):andThen(function()
			dataCache.updateItems({ [p] = TrustedConnectionStatus.TrustedFriends })

			dataCache2.updateItems({ [p] = true })

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				fn4(p)
			end
		end)
	end

	local function fn13(p: string)
		return Requests.PostUserIgnoreTrustedConnectionRequest(p):andThen(function()
			dataCache.updateItems({ [p] = TrustedConnectionStatus.RequestIgnored })

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				fn4(p)
			end
		end)
	end

	local fn14 = FFlagAddFriendsPageTrustedFriendRequestSection and function()
		return Requests.PostUserIgnoreAllTrustedFriendRequests():andThen(function()
			local v6 = tostring(getLocalPlayerUserId())

			if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
				cache2.replaceItem(v6, {
					senderIds = nil,
					requests = {},
					nextPageCursor = nil,
					hasMore = false
				})
			else
				cache2.replaceItem(v6, { senderIds = {}, nextPageCursor = nil, hasMore = false })
			end

			cache3.replaceItem(v6, 0)
		end)
	end or nil

	local function fn15(p: string)
		return Requests.PostUserRemoveTrustedConnection(p):andThen(function()
			dataCache.updateItems({ [p] = TrustedConnectionStatus.RequestReceived })

			dataCache2.updateItems({ [p] = false })
		end)
	end

	local function fn16(p: string)
		return Requests.PostUserCreateTrustedFriendLink(p)
	end

	local function fn17(p: string, p2)
		return Requests.PostUserValidateTrustedFriendLink(p, p2)
	end

	local function fn18(p: string, p2)
		return Requests.PostUserAddTrustedFriendFromLink(p, p2)
	end

	if not FFlagConnectionManagementChips then
		fn5 = nil
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn10 = nil
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn7 = nil
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn8 = nil
	end

	local refetchTrustedFriendRequests

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		refetchTrustedFriendRequests = fn9
	end

	local refetchTrustedFriendRequestsCount

	if FFlagAddFriendsPageTrustedFriendRequestSection then
		refetchTrustedFriendRequestsCount = fn6
	end

	if not FFlagAddFriendsPageTrustedFriendRequestSection then
		fn14 = nil
	end

	if not FFlagTCShareLinkReceiverUI then
		fn17 = nil
	end

	if not FFlagTCShareLinkReceiverUI then
		fn18 = nil
	end

	return {
		getStatus = function(p: string)
			return dataResolver2.getAndFetchItem(p)
		end,
		getIsTrustedConnection = function(p: string)
			return dataResolver.getAndFetchItem(p)
		end,
		getUserTrustedConnections = fn5,
		getTrustedFriendRequests = fn10,
		getTrustedFriendRequestsCount = fn7,
		loadMoreTrustedFriendRequests = fn8,
		refetchTrustedFriendRequests = refetchTrustedFriendRequests,
		refetchTrustedFriendRequestsCount = refetchTrustedFriendRequestsCount,
		sendTrustedConnectionRequest = fn11,
		acceptTrustedConnectionRequest = fn12,
		ignoreTrustedConnectionRequest = fn13,
		ignoreAllTrustedFriendRequests = fn14,
		removeTrustedConnectionRequest = fn15,
		createTrustedFriendLink = fn16,
		validateTrustedFriendLink = fn17,
		addTrustedFriendFromLink = fn18,
		clear = function()
			dataCache.clear()
			dataCache2.clear()
			dataResolver.clear()
			dataResolver2.clear()

			if FFlagConnectionManagementChips then
				cache.clear()
				v2.clear()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				cache2.clear()
				v4.clear()
				cache3.clear()
				v5.clear()
			end
		end,
		dispose = function()
			dataCache.dispose()
			dataCache2.dispose()
			dataResolver.dispose()
			dataResolver2.dispose()
			trustedConnectionEventListener()

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v3()
			end

			if FFlagConnectionManagementChips then
				cache.dispose()
				v2.dispose()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				cache2.dispose()
				v4.dispose()
				cache3.dispose()
				v5.dispose()
			end
		end
	}
end

return createTrustedConnectionsStore
