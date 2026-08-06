local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local Promise = require(DataHydrationParent.Promise)
local Cryo = require(DataHydrationParent.Cryo)
local Requests = require(DataHydration.TrustedConnections.Requests)
local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)
local createTrustedConnectionEventListener = require(DataHydration.TrustedConnections.createTrustedConnectionEventListener)
local createFriendshipEventListener = require(DataHydration.TrustedConnections.createFriendshipEventListener)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local mergeListsWithoutDuplicates = require(DataHydration.DataHydrationUtils).mergeListsWithoutDuplicates
local FFlagTCShareLinkReceiverUI = require(DataHydrationParent.SharedFlags).FFlagTCShareLinkReceiverUI
local FFlagConnectionManagementChips = require(DataHydrationParent.SharedFlags).FFlagConnectionManagementChips
local FFlagAddFriendsPageTrustedFriendRequestSection = require(DataHydrationParent.SharedFlags).FFlagAddFriendsPageTrustedFriendRequestSection
local FIntTrustedFriendRequestsPageSize = require(DataHydrationParent.SharedFlags).FIntTrustedFriendRequestsPageSize
local v17 = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)
game:DefineFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec", 0)

local function createTrustedConnectionsStore() -- line: 77
	-- upvalues: v17 (copy), createDataCache (copy), FFlagConnectionManagementChips (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), getLocalPlayerUserId (copy), mergeListsWithoutDuplicates (copy), Cryo (copy), createDataResolver (copy), Requests (copy), createTrustedConnectionEventListener (copy), TrustedConnectionStatus (copy), createFriendshipEventListener (copy), Promise (copy), FIntTrustedFriendRequestsPageSize (copy), FFlagTCShareLinkReceiverUI (copy)
	local v19 = not (v17 > 0) and 1e999 or v17
	local v20 = createDataCache(v19)
	local v21 = createDataCache(v19)
	local v22 = if not FFlagConnectionManagementChips then nil else createDataCache(v19)
	local v23 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataCache(v19)
	local v24 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataCache(v19)
	local u25 = false
	local v26 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s1: string) -- line: 94
		-- upvalues: getLocalPlayerUserId (copy), v23 (copy), mergeListsWithoutDuplicates (copy), v24 (copy)
		local str = tostring(getLocalPlayerUserId())
		local v44 = v23.getItem(str).data(false)

		if not v44 then
			return
		end

		local v45 = mergeListsWithoutDuplicates(v44.senderIds, { s1 })

		if #v45 == #v44.senderIds then
			return
		end

		v23.replaceItem(str, {
			senderIds = v45,
			nextPageCursor = v44.nextPageCursor,
			hasMore = v44.hasMore
		})

		local v46 = v24.getItem(str).data(false)

		if v46 then
			v24.replaceItem(str, (math.max(v46 + 1, 0)))
		end
	end
	local v27 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s2: string) -- line: 120
		-- upvalues: getLocalPlayerUserId (copy), v23 (copy), Cryo (copy), v24 (copy)
		local str = tostring(getLocalPlayerUserId())
		local v49 = v23.getItem(str).data(false)

		if not v49 then
			return
		end

		local v50 = Cryo.List.removeValue(v49.senderIds, s2)

		if #v50 == #v49.senderIds then
			return
		end

		v23.replaceItem(str, {
			senderIds = v50,
			nextPageCursor = v49.nextPageCursor,
			hasMore = v49.hasMore
		})

		local v51 = v24.getItem(str).data(false)

		if v51 then
			v24.replaceItem(str, (math.max(v51 - 1, 0)))
		end
	end
	local v28 = if not FFlagConnectionManagementChips then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v22,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(s3: string) -- line: 152
			-- upvalues: Requests (copy), Cryo (copy)
			return Requests.GetUserTrustedConnections(s3):andThen(function(p1) -- line: 153
				-- upvalues: Cryo (copy)
				local v88 = p1.PageItems or {}

				return Cryo.List.map(v88, function(p2) -- line: 155
					return {
						id = tostring(p2.id)
					}
				end)
			end)
		end
	})
	local v29 = createTrustedConnectionEventListener(function(s4: string, p3) -- line: 166
		-- upvalues: v20 (copy), v21 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v26 (copy), FFlagConnectionManagementChips (copy), getLocalPlayerUserId (copy), v28 (copy)
		v20.updateItems({
			[s4] = p3
		})
		v21.updateItems({
			[s4] = p3 == TrustedConnectionStatus.TrustedFriends
		})

		if FFlagAddFriendsPageTrustedFriendRequestSection and p3 == TrustedConnectionStatus.RequestReceived then
			v26(s4)
		end

		if FFlagConnectionManagementChips then
			local v55 = getLocalPlayerUserId()

			if v55 then
				v28.fetchItem((tostring(v55)))
			end
		end
	end)
	local v30 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createFriendshipEventListener(function(s5: string, p4) -- line: 192
		-- upvalues: v20 (copy), v21 (copy), TrustedConnectionStatus (copy), v27 (copy)
		v20.updateItems({
			[s5] = p4
		})
		v21.updateItems({
			[s5] = p4 == TrustedConnectionStatus.TrustedFriends
		})

		if p4 == TrustedConnectionStatus.NotFriends then
			v27(s5)
		end
	end)
	local v31 = createDataResolver({
		cache = v21,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t1: {[any]: any}) -- line: 210
			-- upvalues: Cryo (copy), Requests (copy)
			local v59 = Cryo.Dictionary.keys(t1)

			return Requests.MultiGetUsersAreTrustedConnections(v59):andThen(function(p5) -- line: 212
				-- upvalues: Cryo (copy), v59 (copy)
				local v90 = Cryo.List.foldLeft(p5, function(p6, p7) -- line: 213
					p6[tostring(p7)] = true

					return p6
				end, {})

				return Cryo.List.foldLeft(v59, function(p8, p9) -- line: 218
					-- upvalues: v90 (copy)
					p8[tostring(p9)] = v90[p9] or false

					return p8
				end, {})
			end)
		end
	})
	local v32 = createDataResolver({
		cache = v20,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t2: {[any]: any}) -- line: 229
			-- upvalues: Cryo (copy), Requests (copy), Promise (copy)
			local v61 = Cryo.Dictionary.keys(t2)
			local v62 = Cryo.List.foldLeft(v61, function(p10, p11) -- line: 231
				-- upvalues: Requests (copy)
				table.insert(p10, Requests.GetUserTrustedConnectionStatus(p11):andThen(function(p12) -- line: 235
					-- upvalues: p11 (copy)
					return {
						[p11] = p12
					}
				end))

				return p10
			end, {})

			return Promise.all(v62):andThen(function(p13) -- line: 242
				-- upvalues: Cryo (copy)
				return Cryo.Dictionary.join(table.unpack(p13))
			end)
		end
	})
	local v33 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v23,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
		fetchFn = function(_: string, p14) -- line: 254
			-- upvalues: u25 (ref), Requests (copy), FIntTrustedFriendRequestsPageSize (copy), Cryo (copy), mergeListsWithoutDuplicates (copy)
			local v65 = if not u25 then p14.data(false) else nil

			u25 = false

			local v66 = if not v65 then nil else v65.nextPageCursor

			return Requests.GetTrustedFriendRequests(v66, FIntTrustedFriendRequestsPageSize):andThen(function(p15) -- line: 261
				-- upvalues: Cryo (copy), v65 (copy), mergeListsWithoutDuplicates (copy)
				local v95 = if not p15 then nil else p15.data
				local v96 = Cryo.List.map(v95 or {}, function(p16) -- line: 263
					return (tostring(p16.senderId))
				end)
				local v97 = if not v65 then nil else v65.senderIds
				local v98 = if not p15 then nil else p15.nextPageCursor

				return {
					senderIds = mergeListsWithoutDuplicates(v97, v96),
					nextPageCursor = v98,
					hasMore = v98 ~= nil
				}
			end)
		end
	})
	local v34 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v24,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
		fetchFn = function(_: string) -- line: 286
			-- upvalues: Requests (copy)
			return Requests.GetTrustedFriendRequestsCount():andThen(function(p17) -- line: 287
				if p17 then
					return p17.count
				end

				return 0
			end)
		end
	})
	local v35 = if not FFlagConnectionManagementChips then nil else function() -- line: 303
		-- upvalues: getLocalPlayerUserId (copy), v28 (copy)
		local v70 = getLocalPlayerUserId()

		return v28.getAndFetchItem((tostring(v70)))
	end
	local v36 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 310
		-- upvalues: getLocalPlayerUserId (copy), v33 (copy)
		local v71 = getLocalPlayerUserId()

		return v33.getAndFetchItem((tostring(v71)))
	end
	local v37 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 317
		-- upvalues: getLocalPlayerUserId (copy), v34 (copy)
		local v72 = getLocalPlayerUserId()

		return v34.getAndFetchItem((tostring(v72)))
	end
	local v38 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 324
		-- upvalues: getLocalPlayerUserId (copy), v23 (copy), v33 (copy)
		local str = tostring(getLocalPlayerUserId())
		local v74 = v23.getItem(str).data(false)

		if v74 and not v74.hasMore then
			return
		end

		v33.fetchItem(str)
	end
	local v39 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 335
		-- upvalues: u25 (ref), getLocalPlayerUserId (copy), v33 (copy)
		u25 = true

		local str = tostring(getLocalPlayerUserId())

		v33.fetchItem(str)
	end
	local v40 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 344
		-- upvalues: getLocalPlayerUserId (copy), v34 (copy)
		local str = tostring(getLocalPlayerUserId())

		v34.fetchItem(str)
	end
	local v41 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 387
		-- upvalues: Requests (copy), getLocalPlayerUserId (copy), v23 (copy), v24 (copy)
		return Requests.PostUserIgnoreAllTrustedFriendRequests():andThen(function() -- line: 388
			-- upvalues: getLocalPlayerUserId (copy), v23 (copy), v24 (copy)
			local str = tostring(getLocalPlayerUserId())

			v23.replaceItem(str, {
				nextPageCursor = nil,
				hasMore = false,
				senderIds = {}
			})
			v24.replaceItem(str, 0)
		end)
	end

	return {
		getStatus = function(s8: string) -- line: 294
			-- upvalues: v32 (copy)
			return v32.getAndFetchItem(s8)
		end,
		getIsTrustedConnection = function(s9: string) -- line: 298
			-- upvalues: v31 (copy)
			return v31.getAndFetchItem(s9)
		end,
		getUserTrustedConnections = if not FFlagConnectionManagementChips then nil else v35,
		getTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v36,
		getTrustedFriendRequestsCount = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v37,
		loadMoreTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v38,
		refetchTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v39,
		refetchTrustedFriendRequestsCount = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v40,
		sendTrustedConnectionRequest = function(s10: string, s11: string?) -- line: 350
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy)
			return Requests.PostUserSendTrustedConnectionRequest(s10, s11):andThen(function() -- line: 351
				-- upvalues: v20 (copy), s10 (copy), TrustedConnectionStatus (copy)
				v20.updateItems({
					[s10] = TrustedConnectionStatus.RequestSent
				})
			end)
		end,
		acceptTrustedConnectionRequest = function(s12: string) -- line: 358
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy), v21 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v27 (copy)
			return Requests.PostUserAcceptTrustedConnectionRequest(s12):andThen(function() -- line: 359
				-- upvalues: v20 (copy), s12 (copy), TrustedConnectionStatus (copy), v21 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v27 (copy)
				v20.updateItems({
					[s12] = TrustedConnectionStatus.TrustedFriends
				})
				v21.updateItems({
					[s12] = true
				})

				if FFlagAddFriendsPageTrustedFriendRequestSection then
					v27(s12)
				end
			end)
		end,
		ignoreTrustedConnectionRequest = function(s13: string) -- line: 374
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v27 (copy)
			return Requests.PostUserIgnoreTrustedConnectionRequest(s13):andThen(function() -- line: 375
				-- upvalues: v20 (copy), s13 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v27 (copy)
				v20.updateItems({
					[s13] = TrustedConnectionStatus.RequestIgnored
				})

				if FFlagAddFriendsPageTrustedFriendRequestSection then
					v27(s13)
				end
			end)
		end,
		ignoreAllTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v41,
		removeTrustedConnectionRequest = function(s14: string) -- line: 400
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy), v21 (copy)
			return Requests.PostUserRemoveTrustedConnection(s14):andThen(function() -- line: 401
				-- upvalues: v20 (copy), s14 (copy), TrustedConnectionStatus (copy), v21 (copy)
				v20.updateItems({
					[s14] = TrustedConnectionStatus.RequestReceived
				})
				v21.updateItems({
					[s14] = false
				})
			end)
		end,
		createTrustedFriendLink = function(s15: string) -- line: 412
			-- upvalues: Requests (copy)
			return Requests.PostUserCreateTrustedFriendLink(s15)
		end,
		validateTrustedFriendLink = if not FFlagTCShareLinkReceiverUI then nil else function(s16: string, t3: {[any]: any}) -- line: 416
			-- upvalues: Requests (copy)
			return Requests.PostUserValidateTrustedFriendLink(s16, t3)
		end,
		addTrustedFriendFromLink = if not FFlagTCShareLinkReceiverUI then nil else function(s17: string, t4: {[any]: any}) -- line: 420
			-- upvalues: Requests (copy)
			return Requests.PostUserAddTrustedFriendFromLink(s17, t4)
		end,
		clear = function() -- line: 424
			-- upvalues: v20 (copy), v21 (copy), v31 (copy), v32 (copy), FFlagConnectionManagementChips (copy), v22 (copy), v28 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v23 (copy), v33 (copy), v24 (copy), v34 (copy)
			v20.clear()
			v21.clear()
			v31.clear()
			v32.clear()

			if FFlagConnectionManagementChips then
				v22.clear()
				v28.clear()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v23.clear()
				v33.clear()
				v24.clear()
				v34.clear()
			end
		end,
		dispose = function() -- line: 443
			-- upvalues: v20 (copy), v21 (copy), v31 (copy), v32 (copy), v29 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v30 (copy), FFlagConnectionManagementChips (copy), v22 (copy), v28 (copy), v23 (copy), v33 (copy), v24 (copy), v34 (copy)
			v20.dispose()
			v21.dispose()
			v31.dispose()
			v32.dispose()
			v29()

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v30()
			end

			if FFlagConnectionManagementChips then
				v22.dispose()
				v28.dispose()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v23.dispose()
				v33.dispose()
				v24.dispose()
				v34.dispose()
			end
		end
	}
end

return createTrustedConnectionsStore
