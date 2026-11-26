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
local fFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagConnectionManagementChips

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagAddFriendsPageTrustedFriendRequestSection

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagAddFriendsPageHighlightUnseenTrustedRequests

local fIntTrustedFriendRequestsPageSize = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FIntTrustedFriendRequestsPageSize
local fFlagProfileTFCardUseQrScanContext = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagProfileTFCardUseQrScanContext
local fFlagTrustedFriendCandidatesSection = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagTrustedFriendCandidatesSection

local defineFastInt = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)

game:DefineFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec", 0)

local defineFastInt2 = game:DefineFastInt("TrustedFriendCandidatesPageSize", 20)

local defineFastInt3 = game:DefineFastInt("TrustedFriendCandidatesMaxReadsPerFetch", 5)

local v5 = {
	None = TrustedConnectionStatus.Friends,
	RequestSent = TrustedConnectionStatus.RequestSent,
	RequestReceived = TrustedConnectionStatus.RequestReceived
}

local function createTrustedConnectionsStore()
	local v6 = not (defineFastInt > 0) and 1e999 or defineFastInt
	local v7 = createDataCache(v6)
	local v8 = createDataCache(v6)

	local v9 = if fFlagConnectionManagementChips then createDataCache(v6) else nil

	local v10 = if fFlagAddFriendsPageTrustedFriendRequestSection then createDataCache(v6) else nil

	local v11 = if fFlagAddFriendsPageTrustedFriendRequestSection then createDataCache(v6) else nil

	local flag = false

	local v12 = if fFlagTrustedFriendCandidatesSection then createDataCache(v6) else nil
	local v13 = if fFlagTrustedFriendCandidatesSection then false else nil
	local fn = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		local v14 = tostring(getLocalPlayerUserId())
		local data = v10.getItem(v14).data(false)

		if not data then
			return
		end

		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			local requests = data.requests

			if not requests then
				return
			end

			local v15 = mergeListsWithoutDuplicates({
				{ id = p2, isUnseen = true }
			}, requests, "id")

			if #v15 == #requests then
				return
			end

			v10.replaceItem(v14, {
				senderIds = nil,
				requests = v15,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		else
			local v15 = mergeListsWithoutDuplicates(data.senderIds, { p2 })

			if #v15 == #data.senderIds then
				return
			end

			v10.replaceItem(v14, {
				senderIds = v15,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = v11.getItem(v14).data(false)

		if data2 then
			v11.replaceItem(v14, (math.max(data2 + 1, 0)))
		end
	end or nil

	local fn2 = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		local v14 = tostring(getLocalPlayerUserId())
		local data = v10.getItem(v14).data(false)

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

			v10.replaceItem(v14, {
				senderIds = nil,
				requests = filtered,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		else
			local v15 = Cryo.List.removeValue(data.senderIds, p2)

			if #v15 == #data.senderIds then
				return
			end

			v10.replaceItem(v14, {
				senderIds = v15,
				nextPageCursor = data.nextPageCursor,
				hasMore = data.hasMore
			})
		end

		local data2 = v11.getItem(v14).data(false)

		if data2 then
			v11.replaceItem(v14, (math.max(data2 - 1, 0)))
		end
	end or nil

	local fn3 = fFlagTrustedFriendCandidatesSection and function(p2)
		local v14 = tostring(getLocalPlayerUserId())
		local data = v12.getItem(v14).data(false)

		if not data then
			return
		end

		local filtered = Cryo.List.filter(data.candidates, function(p3): boolean
			return p3.id ~= p2
		end)

		if #filtered == #data.candidates then
			return
		end

		v12.replaceItem(v14, {
			candidates = filtered,
			nextPageCursor = data.nextPageCursor,
			hasMore = data.hasMore
		})
	end or nil
	local v14

	if fFlagConnectionManagementChips then
		v14 = createDataResolver({
			cache = v9,
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
		v14 = nil
	end

	local v15 = createTrustedConnectionEventListener(function(p2, p3)
		v7.updateItems({ [p2] = p3 })

		v8.updateItems({
			[p2] = p3 == TrustedConnectionStatus.TrustedFriends
		})

		if fFlagAddFriendsPageTrustedFriendRequestSection and p3 == TrustedConnectionStatus.RequestReceived then
			fn(p2)
		end

		if fFlagTrustedFriendCandidatesSection and p3 == TrustedConnectionStatus.TrustedFriends then
			fn3(p2)
		end

		local v16 = fFlagConnectionManagementChips and getLocalPlayerUserId()

		if v16 then
			v14.fetchItem((tostring(v16)))
		end
	end)
	local v16

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v16 = createFriendshipEventListener(function(p2, p3)
			v7.updateItems({ [p2] = p3 })

			v8.updateItems({
				[p2] = p3 == TrustedConnectionStatus.TrustedFriends
			})

			if p3 == TrustedConnectionStatus.NotFriends then
				fn2(p2)

				if fFlagTrustedFriendCandidatesSection then
					fn3(p2)
				end
			end
		end)
	else
		v16 = nil
	end

	local v17 = createDataResolver({
		cache = v8,
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
	local v18 = createDataResolver({
		cache = v7,
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
	local v19

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v19 = createDataResolver({
			cache = v10,
			supportsMultiGet = false,
			replaceItems = true,
			queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
			fetchFn = function(p2, p3)
				local v20 = if not flag then p3.data(false) else nil
				flag = false

				local v21 = if v20 then v20.nextPageCursor else nil

				return Requests.GetTrustedFriendRequests(v21, fIntTrustedFriendRequestsPageSize):andThen(function(p4)
					if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
						local v22 = if p4 then p4.data else nil
						local mapped = Cryo.List.map(v22 or {}, function(p5)
							return {
								id = tostring(p5.senderId),
								isUnseen = p5.isUnseen
							}
						end)

						local requests = if v20 then v20.requests else nil
						local nextPageCursor = if p4 then p4.nextPageCursor else nil
						return {
							senderIds = nil,
							requests = mergeListsWithoutDuplicates(requests, mapped, "id"),
							nextPageCursor = nextPageCursor,
							hasMore = nextPageCursor ~= nil
						}
					else
						local v22 = if p4 then p4.data else nil
						local mapped = Cryo.List.map(v22 or {}, function(p5)
							return (tostring(p5.senderId))
						end)

						local senderIds = if v20 then v20.senderIds else nil
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
		v19 = nil
	end

	local v20

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v20 = createDataResolver({
			cache = v11,
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
		v20 = nil
	end

	local function fetchTrustedFriendCandidatesPage(nextPageCursor, p2)
		return Requests.GetTrustedFriendCandidates(nextPageCursor, defineFastInt2):andThen(function(p3)
			local v21 = not (p3 and p3.data) and {} or p3.data
			local nextPageCursor2 = if p3 then p3.nextPageCursor else nil
			local v22 = {}
			local v23 = {}

			for k, v24 in v21 do
				local userId = tostring(v24.userId)
				table.insert(v22, { id = userId })
				v23[userId] = v5[v24.state]
			end

			if #v22 == 0 and nextPageCursor2 ~= nil and p2 > 1 then
				return fetchTrustedFriendCandidatesPage(nextPageCursor2, p2 - 1)
			end

			return {
				candidates = v22,
				statuses = v23,
				nextPageCursor = nextPageCursor2
			}
		end)
	end

	local function applyTrustedFriendCandidatesPage(data, p2)
		v7.updateItems(data.statuses)

		local v23 = if p2 then p2.candidates else nil
		return {
			candidates = mergeListsWithoutDuplicates(v23, data.candidates, "id"),
			nextPageCursor = data.nextPageCursor,
			hasMore = data.nextPageCursor ~= nil
		}
	end

	local v21

	if fFlagTrustedFriendCandidatesSection then
		v21 = createDataResolver({
			cache = v12,
			supportsMultiGet = false,
			replaceItems = true,
			fetchFn = function(p2, p3)
				local v22 = v13
				v13 = false

				local v23 = if not v22 then p3.data(false) else nil
				local nextPageCursor = if v23 then v23.nextPageCursor else nil

				local v24 = defineFastInt3
				return Requests.GetTrustedFriendCandidates(nextPageCursor, defineFastInt2):andThen(function(p4)
					local v25 = not (p4 and p4.data) and {} or p4.data
					local nextPageCursor2 = if p4 then p4.nextPageCursor else nil
					local v26 = {}
					local v27 = {}

					for k, v28 in v25 do
						local userId = tostring(v28.userId)
						table.insert(v26, { id = userId })
						v27[userId] = v5[v28.state]
					end

					if #v26 == 0 and nextPageCursor2 ~= nil and v24 > 1 then
						return fetchTrustedFriendCandidatesPage(nextPageCursor2, v24 - 1)
					end

					return {
						candidates = v26,
						statuses = v27,
						nextPageCursor = nextPageCursor2
					}
				end):andThen(function(p4)
					local v25 = if not v22 then p3.data(false) else nil
					return applyTrustedFriendCandidatesPage(p4, v25)
				end)
			end
		})
	else
		v21 = nil
	end

	local function getStatus(p2)
		return v18.getAndFetchItem(p2)
	end

	local function getIsTrustedConnection(p2)
		return v17.getAndFetchItem(p2)
	end

	local fn4 = fFlagConnectionManagementChips and function()
		local localPlayerUserId = getLocalPlayerUserId()
		return v14.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn5 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v22 = tostring(getLocalPlayerUserId())
		v20.fetchItem(v22)
	end or nil

	local fn6 = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests and p2 and p2.forceFetch then
			fn5()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v20.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn7 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		local v22 = tostring(getLocalPlayerUserId())
		local data = v10.getItem(v22).data(false)

		if data and not data.hasMore then
			return
		end

		v19.fetchItem(v22)
	end or nil

	local fn8 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		flag = true

		local v22 = tostring(getLocalPlayerUserId())
		v19.fetchItem(v22)
	end or nil

	local fn9 = fFlagAddFriendsPageTrustedFriendRequestSection and function(p2)
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests and p2 and p2.forceFetch then
			fn8()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v19.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn10 = fFlagTrustedFriendCandidatesSection and function()
		v13 = true

		local v22 = tostring(getLocalPlayerUserId())

		v21.refetchItem(v22)
	end or nil

	local fn11 = fFlagTrustedFriendCandidatesSection and function(p2)
		if p2 and p2.forceFetch then
			fn10()
		end

		local localPlayerUserId = getLocalPlayerUserId()
		return v21.getAndFetchItem((tostring(localPlayerUserId)))
	end or nil

	local fn12 = fFlagTrustedFriendCandidatesSection and function()
		local v22 = tostring(getLocalPlayerUserId())
		local data = v12.getItem(v22).data(false)

		if data and not data.hasMore then
			return
		end

		v21.fetchItem(v22)
	end or nil

	local fn13 = fFlagTrustedFriendCandidatesSection and function(p2)
		return v18.refetchItem(p2)
	end or nil

	local function fn14(p2, p3)
		return Requests.PostUserSendTrustedConnectionRequest(p2, p3):andThen(function(p4)
			if
				fFlagProfileTFCardUseQrScanContext
				and p4
				and p4.responseBody
				and p4.responseBody.success == false
			then
				return Promise.reject("Trusted connection request was not sent")
			end

			v7.updateItems({ [p2] = TrustedConnectionStatus.RequestSent })

			return nil
		end)
	end

	local function fn15(p2)
		return Requests.PostUserAcceptTrustedConnectionRequest(p2):andThen(function()
			v7.updateItems({ [p2] = TrustedConnectionStatus.TrustedFriends })

			v8.updateItems({ [p2] = true })

			if fFlagAddFriendsPageTrustedFriendRequestSection then
				fn2(p2)
			end

			if fFlagTrustedFriendCandidatesSection then
				fn3(p2)
			end
		end)
	end

	local function fn16(p2)
		return Requests.PostUserIgnoreTrustedConnectionRequest(p2):andThen(function()
			v7.updateItems({ [p2] = TrustedConnectionStatus.RequestIgnored })

			if fFlagAddFriendsPageTrustedFriendRequestSection then
				fn2(p2)
			end
		end)
	end

	local fn17 = fFlagAddFriendsPageTrustedFriendRequestSection and function()
		return Requests.PostUserIgnoreAllTrustedFriendRequests():andThen(function()
			local v22 = tostring(getLocalPlayerUserId())

			if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
				v10.replaceItem(v22, {
					senderIds = nil,
					requests = {},
					nextPageCursor = nil,
					hasMore = false
				})
			else
				v10.replaceItem(v22, {
					senderIds = {},
					nextPageCursor = nil,
					hasMore = false
				})
			end

			v11.replaceItem(v22, 0)

			if fFlagTrustedFriendCandidatesSection then
				v18.clear()
			end
		end)
	end or nil

	local function fn18(p2)
		return Requests.PostUserRemoveTrustedConnection(p2):andThen(function()
			v7.updateItems({ [p2] = TrustedConnectionStatus.RequestReceived })

			v8.updateItems({ [p2] = false })
		end)
	end

	local function fn19(p2)
		return Requests.PostUserCreateTrustedFriendLink(p2)
	end

	local function fn20(p2, p3)
		return Requests.PostUserValidateTrustedFriendLink(p2, p3)
	end

	local function fn21(p2, p3)
		return Requests.PostUserAddTrustedFriendFromLink(p2, p3)
	end

	if not fFlagConnectionManagementChips then
		fn4 = nil
	end

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn9 = nil
	end

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn6 = nil
	end

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn7 = nil
	end

	local trustedConnectionsStore = {
		getStatus = getStatus,
		getIsTrustedConnection = getIsTrustedConnection,
		getUserTrustedConnections = fn4,
		getTrustedFriendRequests = fn9,
		getTrustedFriendRequestsCount = fn6,
		loadMoreTrustedFriendRequests = fn7,
		refetchTrustedFriendRequests = if fFlagAddFriendsPageTrustedFriendRequestSection then fn8 else nil,
		refetchTrustedFriendRequestsCount = if fFlagAddFriendsPageTrustedFriendRequestSection then fn5 else nil,
		getTrustedFriendCandidates = nil,
		loadMoreTrustedFriendCandidates = nil,
		refetchTrustedFriendCandidates = nil,
		refetchStatus = nil,
		sendTrustedConnectionRequest = nil,
		acceptTrustedConnectionRequest = nil,
		ignoreTrustedConnectionRequest = nil,
		ignoreAllTrustedFriendRequests = nil,
		removeTrustedConnectionRequest = nil,
		createTrustedFriendLink = nil,
		validateTrustedFriendLink = nil,
		addTrustedFriendFromLink = nil,
		clear = nil,
		dispose = nil
	}

	if not fFlagTrustedFriendCandidatesSection then
		fn11 = nil
	end

	trustedConnectionsStore.getTrustedFriendCandidates = fn11

	if not fFlagTrustedFriendCandidatesSection then
		fn12 = nil
	end

	trustedConnectionsStore.loadMoreTrustedFriendCandidates = fn12

	trustedConnectionsStore.refetchTrustedFriendCandidates = if fFlagTrustedFriendCandidatesSection then fn10 else nil

	if not fFlagTrustedFriendCandidatesSection then
		fn13 = nil
	end

	trustedConnectionsStore.refetchStatus = fn13

	trustedConnectionsStore.sendTrustedConnectionRequest = fn14
	trustedConnectionsStore.acceptTrustedConnectionRequest = fn15
	trustedConnectionsStore.ignoreTrustedConnectionRequest = fn16

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		fn17 = nil
	end

	trustedConnectionsStore.ignoreAllTrustedFriendRequests = fn17

	trustedConnectionsStore.removeTrustedConnectionRequest = fn18

	trustedConnectionsStore.createTrustedFriendLink = fn19

	trustedConnectionsStore.validateTrustedFriendLink = fn20
	trustedConnectionsStore.addTrustedFriendFromLink = fn21

	function trustedConnectionsStore.clear()
		v7.clear()
		v8.clear()
		v17.clear()
		v18.clear()

		if fFlagConnectionManagementChips then
			v9.clear()
			v14.clear()
		end

		if fFlagAddFriendsPageTrustedFriendRequestSection then
			v10.clear()
			v19.clear()
			v11.clear()
			v20.clear()
		end

		if fFlagTrustedFriendCandidatesSection then
			v12.clear()
			v21.clear()
		end
	end

	function trustedConnectionsStore.dispose()
		v7.dispose()
		v8.dispose()
		v17.dispose()
		v18.dispose()
		v15()

		if fFlagAddFriendsPageTrustedFriendRequestSection then
			v16()
		end

		if fFlagConnectionManagementChips then
			v9.dispose()
			v14.dispose()
		end

		if fFlagAddFriendsPageTrustedFriendRequestSection then
			v10.dispose()
			v19.dispose()
			v11.dispose()
			v20.dispose()
		end

		if fFlagTrustedFriendCandidatesSection then
			v12.dispose()
			v21.dispose()
		end
	end
	return trustedConnectionsStore
end

return createTrustedConnectionsStore
