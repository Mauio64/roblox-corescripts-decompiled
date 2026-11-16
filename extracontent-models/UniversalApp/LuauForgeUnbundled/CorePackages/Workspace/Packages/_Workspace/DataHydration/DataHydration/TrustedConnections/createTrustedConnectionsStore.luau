local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")

local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Requests")
local TrustedConnectionStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Enums/TrustedConnectionStatus")

local createTrustedConnectionEventListener = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/createTrustedConnectionEventListener")
local createFriendshipEventListener = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/createFriendshipEventListener")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId
local mergeListsWithoutDuplicates = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").mergeListsWithoutDuplicates
local fFlagTCShareLinkReceiverUI = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagTCShareLinkReceiverUI
local fFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagConnectionManagementChips

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagAddFriendsPageTrustedFriendRequestSection

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagAddFriendsPageHighlightUnseenTrustedRequests

local fIntTrustedFriendRequestsPageSize = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FIntTrustedFriendRequestsPageSize
local fFlagProfileTFCardUseQrScanContext = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagProfileTFCardUseQrScanContext

local defineFastInt = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)

game:DefineFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec", 0)

local function createTrustedConnectionsStore()
	local v5 = not (defineFastInt > 0) and 1e999 or defineFastInt
	local v6 = createDataCache(v5)
	local v7 = createDataCache(v5)

	local v8 = if fFlagConnectionManagementChips then createDataCache(v5) else nil

	local v9 = if fFlagAddFriendsPageTrustedFriendRequestSection then createDataCache(v5) else nil

	local v10 = if fFlagAddFriendsPageTrustedFriendRequestSection then createDataCache(v5) else nil

	local flag = false

	local fn = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		local v11 = tostring(getLocalPlayerUserId())
		local data = v9.getItem(v11).data(false)

		if not data then
			return
		end

		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			local requests = data.requests

			if not requests then
				return
			end

			local v12 = mergeListsWithoutDuplicates({
				{ id = p2, isUnseen = true }
			}, requests, "id")

			if #v12 == #requests then
				return
			end

			v9.replaceItem(v11, {
				senderIds = nil,
				requests = v12,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		else
			local v12 = mergeListsWithoutDuplicates(data.senderIds, { p2 })

			if #v12 == #data.senderIds then
				return
			end

			v9.replaceItem(v11, {
				senderIds = v12,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = v10.getItem(v11).data(false)

		if data2 then
			v10.replaceItem(v11, (math.max(data2 + 1, 0)))
		end
	end or nil

	local fn2 = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		local v11 = tostring(getLocalPlayerUserId())
		local data = v9.getItem(v11).data(false)

		if not data then
			return
		end

		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			local requests = data.requests

			if not requests then
				return
			end

			local filtered = Cryo.List.filter(requests, function(p3): boolean
				return p3.id ~= p2
			end)

			if #filtered == #requests then
				return
			end

			v9.replaceItem(v11, {
				senderIds = nil,
				requests = filtered,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		else
			local v12 = Cryo.List.removeValue(data.senderIds, p2)

			if #v12 == #data.senderIds then
				return
			end

			v9.replaceItem(v11, {
				senderIds = v12,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = v10.getItem(v11).data(false)

		if data2 then
			v10.replaceItem(v11, (math.max(data2 - 1, 0)))
		end
	end or nil
	local v11

	if fFlagConnectionManagementChips then
		v11 = createDataResolver({
			cache = v8,
			supportsMultiGet = false,
			queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
			replaceItems = true,
			fetchFn = function(p2)
				return Requests.GetUserTrustedConnections(p2):andThen(function(p3)
					local pageItems = p3.PageItems or {}
					return Cryo.List.map(pageItems, function(p4)
						return { id = tostring(p4.id) }
					end)
				end)
			end
		})
	else
		v11 = nil
	end

	local v12 = createTrustedConnectionEventListener(function(p2, p3)
		v6.updateItems({ [p2] = p3 })

		v7.updateItems({
			[p2] = p3 == TrustedConnectionStatus.TrustedFriends
		})

		if fFlagAddFriendsPageTrustedFriendRequestSection and p3 == TrustedConnectionStatus.RequestReceived then
			fn(p2)
		end

		local v13 = fFlagConnectionManagementChips and getLocalPlayerUserId()

		if v13 then
			v11.fetchItem((tostring(v13)))
		end
	end)
	local v13

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v13 = createFriendshipEventListener(function(p2, p3)
			v6.updateItems({ [p2] = p3 })

			v7.updateItems({
				[p2] = p3 == TrustedConnectionStatus.TrustedFriends
			})

			if p3 == TrustedConnectionStatus.NotFriends then
				fn2(p2)
			end
		end)
	else
		v13 = nil
	end

	local v14 = createDataResolver({
		cache = v7,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			return Requests.MultiGetUsersAreTrustedConnections(keys):andThen(function(p3)
				local foldLeft = Cryo.List.foldLeft(p3, function(p4, p5)
					p4[tostring(p5)] = true
					return p4
				end, {})

				return Cryo.List.foldLeft(keys, function(p4, p5)
					p4[tostring(p5)] = foldLeft[p5] or false
					return p4
				end, {})
			end)
		end
	})
	local v15 = createDataResolver({
		cache = v6,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			local foldLeft = Cryo.List.foldLeft(keys, function(list, p3)
				table.insert(list, Requests.GetUserTrustedConnectionStatus(p3):andThen(function(p4)
					return { [p3] = p4 }
				end))

				return list
			end, {})

			return Promise.all(foldLeft):andThen(function(list)
				return Cryo.Dictionary.join(table.unpack(list))
			end)
		end
	})
	local v16

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v16 = createDataResolver({
			cache = v9,
			supportsMultiGet = false,
			replaceItems = true,
			queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
			fetchFn = function(p2, p3)
				local v17 = if not flag then p3.data(false) else nil
				flag = false

				local v18 = if v17 then v17.nextPageCursor else nil

				return Requests.GetTrustedFriendRequests(v18, fIntTrustedFriendRequestsPageSize):andThen(function(p4)
					if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
						local v19 = if p4 then p4.data else nil
						local mapped = Cryo.List.map(v19 or {}, function(p5)
							return {
								id = tostring(p5.senderId),
								isUnseen = p5.isUnseen
							}
						end)

						local requests = if v17 then v17.requests else nil
						local nextPageCursor = if p4 then p4.nextPageCursor else nil
						return {
							senderIds = nil,
							requests = mergeListsWithoutDuplicates(requests, mapped, "id"),
							nextPageCursor = nextPageCursor,
							hasMore = nextPageCursor ~= nil
						}
					else
						local v19 = if p4 then p4.data else nil
						local mapped = Cryo.List.map(v19 or {}, function(p5)
							return (tostring(p5.senderId))
						end)

						local senderIds = if v17 then v17.senderIds else nil
						local nextPageCursor = if p4 then p4.nextPageCursor else nil

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
		v16 = nil
	end

	local v17

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v17 = createDataResolver({
			cache = v10,
			supportsMultiGet = false,
			replaceItems = true,
			queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
			fetchFn = function(p2)
				return Requests.GetTrustedFriendRequestsCount():andThen(function(p3)
					if p3 then
						return p3.count
					end

					return 0
				end)
			end
		})
	else
		v17 = nil
	end

	local function getStatus(p2)
		return v15.getAndFetchItem(p2)
	end

	local function getIsTrustedConnection(p2)
		return v14.getAndFetchItem(p2)
	end

	local fn3 = fFlagConnectionManagementChips and function()
		local localPlayerUserId = getLocalPlayerUserId()
		return v11.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn4 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v18 = tostring(getLocalPlayerUserId())
		v17.fetchItem(v18)
	end or nil

	local fn5 = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests and p2 and p2.forceFetch then
			fn4()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v17.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn6 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v18 = tostring(getLocalPlayerUserId())
		local data = v9.getItem(v18).data(false)

		if data and not data.hasMore then
			return
		end

		v16.fetchItem(v18)
	end or nil

	local fn7 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		flag = true

		local v18 = tostring(getLocalPlayerUserId())
		v16.fetchItem(v18)
	end or nil

	local fn8 = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests and p2 and p2.forceFetch then
			fn7()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v16.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local function fn9(p2, p3)
		return Requests.PostUserSendTrustedConnectionRequest(p2, p3):andThen(function(p4)
			if
				fFlagProfileTFCardUseQrScanContext
				and p4
				and p4.responseBody
				and p4.responseBody.success == false
			then
				return Promise.reject("Trusted connection request was not sent")
			end

			v6.updateItems({ [p2] = TrustedConnectionStatus.RequestSent })

			return nil
		end)
	end

	local function fn10(p2)
		return Requests.PostUserAcceptTrustedConnectionRequest(p2):andThen(function()
			v6.updateItems({ [p2] = TrustedConnectionStatus.TrustedFriends })

			v7.updateItems({ [p2] = true })

			if fFlagAddFriendsPageTrustedFriendRequestSection then
				fn2(p2)
			end
		end)
	end

	local function fn11(p2)
		return Requests.PostUserIgnoreTrustedConnectionRequest(p2):andThen(function()
			v6.updateItems({ [p2] = TrustedConnectionStatus.RequestIgnored })

			if fFlagAddFriendsPageTrustedFriendRequestSection then
				fn2(p2)
			end
		end)
	end

	local fn12 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		return Requests.PostUserIgnoreAllTrustedFriendRequests():andThen(function()
			local v18 = tostring(getLocalPlayerUserId())

			if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
				v9.replaceItem(v18, {
					senderIds = nil,
					requests = {},
					nextPageCursor = nil,
					hasMore = false
				})
			else
				v9.replaceItem(v18, {
					senderIds = {},
					nextPageCursor = nil,
					hasMore = false
				})
			end

			v10.replaceItem(v18, 0)
		end)
	end or nil

	local function fn13(p2)
		return Requests.PostUserRemoveTrustedConnection(p2):andThen(function()
			v6.updateItems({ [p2] = TrustedConnectionStatus.RequestReceived })

			v7.updateItems({ [p2] = false })
		end)
	end

	local function fn14(p2)
		return Requests.PostUserCreateTrustedFriendLink(p2)
	end

	local function fn15(p2, p3)
		return Requests.PostUserValidateTrustedFriendLink(p2, p3)
	end

	local function fn16(p2, p3)
		return Requests.PostUserAddTrustedFriendFromLink(p2, p3)
	end

	if not fFlagConnectionManagementChips then
		fn3 = nil
	end

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn8 = nil
	end

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn5 = nil
	end

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn6 = nil
	end

	local trustedConnectionsStore = {
		getStatus = getStatus,
		getIsTrustedConnection = getIsTrustedConnection,
		getUserTrustedConnections = fn3,
		getTrustedFriendRequests = fn8,
		getTrustedFriendRequestsCount = fn5,
		loadMoreTrustedFriendRequests = fn6,
		refetchTrustedFriendRequests = if fFlagAddFriendsPageTrustedFriendRequestSection then fn7 else nil,
		refetchTrustedFriendRequestsCount = if fFlagAddFriendsPageTrustedFriendRequestSection then fn4 else nil,
		sendTrustedConnectionRequest = fn9,
		acceptTrustedConnectionRequest = fn10,
		ignoreTrustedConnectionRequest = fn11,
		ignoreAllTrustedFriendRequests = nil,
		removeTrustedConnectionRequest = nil,
		createTrustedFriendLink = nil,
		validateTrustedFriendLink = nil,
		addTrustedFriendFromLink = nil,
		clear = nil,
		dispose = nil
	}

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn12 = nil
	end

	trustedConnectionsStore.ignoreAllTrustedFriendRequests = fn12

	trustedConnectionsStore.removeTrustedConnectionRequest = fn13

	trustedConnectionsStore.createTrustedFriendLink = fn14

	if not fFlagTCShareLinkReceiverUI then
		fn15 = nil
	end

	trustedConnectionsStore.validateTrustedFriendLink = fn15

	if not fFlagTCShareLinkReceiverUI then
		fn16 = nil
	end

	trustedConnectionsStore.addTrustedFriendFromLink = fn16

	function trustedConnectionsStore.clear()
		v6.clear()
		v7.clear()
		v14.clear()
		v15.clear()

		if fFlagConnectionManagementChips then
			v8.clear()
			v11.clear()
		end

		if fFlagAddFriendsPageTrustedFriendRequestSection then
			v9.clear()
			v16.clear()
			v10.clear()
			v17.clear()
		end
	end

	function trustedConnectionsStore.dispose()
		v6.dispose()
		v7.dispose()
		v14.dispose()
		v15.dispose()
		v12()

		if fFlagAddFriendsPageTrustedFriendRequestSection then
			v13()
		end

		if fFlagConnectionManagementChips then
			v8.dispose()
			v11.dispose()
		end

		if fFlagAddFriendsPageTrustedFriendRequestSection then
			v9.dispose()
			v16.dispose()
			v10.dispose()
			v17.dispose()
		end
	end
	return trustedConnectionsStore
end

return createTrustedConnectionsStore
