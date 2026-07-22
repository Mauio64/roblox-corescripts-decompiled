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
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local mergeListsWithoutDuplicates = require(DataHydration.DataHydrationUtils).mergeListsWithoutDuplicates
local FFlagTCShareLinkReceiverUI = require(DataHydrationParent.SharedFlags).FFlagTCShareLinkReceiverUI
local FFlagConnectionManagementChips = require(DataHydrationParent.SharedFlags).FFlagConnectionManagementChips
local FFlagAddFriendsPageTrustedFriendRequestSection = require(DataHydrationParent.SharedFlags).FFlagAddFriendsPageTrustedFriendRequestSection
local FIntTrustedFriendRequestsPageSize = require(DataHydrationParent.SharedFlags).FIntTrustedFriendRequestsPageSize
local FIntInitialTrustedFriendRequestsPageSize = require(DataHydrationParent.SharedFlags).FIntInitialTrustedFriendRequestsPageSize
local v17 = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)
game:DefineFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec", 0)

local function createTrustedConnectionsStore() -- line: 78
	-- upvalues: v17 (copy), createDataCache (copy), FFlagConnectionManagementChips (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), getLocalPlayerUserId (copy), mergeListsWithoutDuplicates (copy), Cryo (copy), createDataResolver (copy), Requests (copy), createTrustedConnectionEventListener (copy), TrustedConnectionStatus (copy), Promise (copy), FIntTrustedFriendRequestsPageSize (copy), FIntInitialTrustedFriendRequestsPageSize (copy), FFlagTCShareLinkReceiverUI (copy)
	local v19 = not (v17 > 0) and 1e999 or v17
	local v20 = createDataCache(v19)
	local v21 = createDataCache(v19)
	local v22 = if not FFlagConnectionManagementChips then nil else createDataCache(v19)
	local v23 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataCache(v19)
	local v24 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataCache(v19)
	local u25 = false
	local v26 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s1: string) -- line: 95
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
	local v27 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s2: string) -- line: 121
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
		fetchFn = function(s3: string) -- line: 153
			-- upvalues: Requests (copy), Cryo (copy)
			return Requests.GetUserTrustedConnections(s3):andThen(function(p1) -- line: 154
				-- upvalues: Cryo (copy)
				local v88 = p1.PageItems or {}

				return Cryo.List.map(v88, function(p2) -- line: 156
					return {
						id = tostring(p2.id)
					}
				end)
			end)
		end
	})
	local v29 = createTrustedConnectionEventListener(function(s4: string, p3) -- line: 167
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
	local v30 = createDataResolver({
		cache = v21,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t1: {[any]: any}) -- line: 195
			-- upvalues: Cryo (copy), Requests (copy)
			local v57 = Cryo.Dictionary.keys(t1)

			return Requests.MultiGetUsersAreTrustedConnections(v57):andThen(function(p4) -- line: 197
				-- upvalues: Cryo (copy), v57 (copy)
				local v90 = Cryo.List.foldLeft(p4, function(p5, p6) -- line: 198
					p5[tostring(p6)] = true

					return p5
				end, {})

				return Cryo.List.foldLeft(v57, function(p7, p8) -- line: 203
					-- upvalues: v90 (copy)
					p7[tostring(p8)] = v90[p8] or false

					return p7
				end, {})
			end)
		end
	})
	local v31 = createDataResolver({
		cache = v20,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t2: {[any]: any}) -- line: 214
			-- upvalues: Cryo (copy), Requests (copy), Promise (copy)
			local v59 = Cryo.Dictionary.keys(t2)
			local v60 = Cryo.List.foldLeft(v59, function(p9, p10) -- line: 216
				-- upvalues: Requests (copy)
				table.insert(p9, Requests.GetUserTrustedConnectionStatus(p10):andThen(function(p11) -- line: 220
					-- upvalues: p10 (copy)
					return {
						[p10] = p11
					}
				end))

				return p9
			end, {})

			return Promise.all(v60):andThen(function(p12) -- line: 227
				-- upvalues: Cryo (copy)
				return Cryo.Dictionary.join(table.unpack(p12))
			end)
		end
	})
	local v32 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v23,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
		fetchFn = function(_: string, p13) -- line: 239
			-- upvalues: u25 (ref), FIntTrustedFriendRequestsPageSize (copy), FIntInitialTrustedFriendRequestsPageSize (copy), Requests (copy), Cryo (copy), mergeListsWithoutDuplicates (copy)
			local v63 = if not u25 then p13.data(false) else nil

			u25 = false

			local v64 = if not v63 then nil else v63.nextPageCursor
			local v65 = if not v63 then FIntInitialTrustedFriendRequestsPageSize else FIntTrustedFriendRequestsPageSize

			return Requests.GetTrustedFriendRequests(v64, v65):andThen(function(p14) -- line: 248
				-- upvalues: Cryo (copy), v63 (copy), mergeListsWithoutDuplicates (copy)
				local v95 = if not p14 then nil else p14.data
				local v96 = Cryo.List.map(v95 or {}, function(p15) -- line: 250
					return (tostring(p15.senderId))
				end)
				local v97 = if not v63 then nil else v63.senderIds
				local v98 = if not p14 then nil else p14.nextPageCursor

				return {
					senderIds = mergeListsWithoutDuplicates(v97, v96),
					nextPageCursor = v98,
					hasMore = v98 ~= nil
				}
			end)
		end
	})
	local v33 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v24,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
		fetchFn = function(_: string) -- line: 273
			-- upvalues: Requests (copy)
			return Requests.GetTrustedFriendRequestsCount():andThen(function(p16) -- line: 274
				if p16 then
					return p16.count
				end

				return 0
			end)
		end
	})
	local v34 = if not FFlagConnectionManagementChips then nil else function() -- line: 290
		-- upvalues: getLocalPlayerUserId (copy), v28 (copy)
		local v69 = getLocalPlayerUserId()

		return v28.getAndFetchItem((tostring(v69)))
	end
	local v35 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 297
		-- upvalues: getLocalPlayerUserId (copy), v32 (copy)
		local v70 = getLocalPlayerUserId()

		return v32.getAndFetchItem((tostring(v70)))
	end
	local v36 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 304
		-- upvalues: getLocalPlayerUserId (copy), v33 (copy)
		local v71 = getLocalPlayerUserId()

		return v33.getAndFetchItem((tostring(v71)))
	end
	local v37 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 311
		-- upvalues: getLocalPlayerUserId (copy), v23 (copy), v32 (copy)
		local str = tostring(getLocalPlayerUserId())
		local v73 = v23.getItem(str).data(false)

		if v73 and not v73.hasMore then
			return
		end

		v32.fetchItem(str)
	end
	local v38 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 322
		-- upvalues: u25 (ref), getLocalPlayerUserId (copy), v32 (copy)
		u25 = true

		local str = tostring(getLocalPlayerUserId())

		v32.fetchItem(str)
	end
	local v39 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 331
		-- upvalues: getLocalPlayerUserId (copy), v33 (copy)
		local str = tostring(getLocalPlayerUserId())

		v33.fetchItem(str)
	end
	local v40 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s7: string) -- line: 374
		-- upvalues: v27 (copy)
		v27(s7)
	end
	local v41 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 380
		-- upvalues: Requests (copy), getLocalPlayerUserId (copy), v23 (copy), v24 (copy)
		return Requests.PostUserIgnoreAllTrustedFriendRequests():andThen(function() -- line: 381
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
		getStatus = function(s8: string) -- line: 281
			-- upvalues: v31 (copy)
			return v31.getAndFetchItem(s8)
		end,
		getIsTrustedConnection = function(s9: string) -- line: 285
			-- upvalues: v30 (copy)
			return v30.getAndFetchItem(s9)
		end,
		getUserTrustedConnections = if not FFlagConnectionManagementChips then nil else v34,
		getTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v35,
		getTrustedFriendRequestsCount = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v36,
		loadMoreTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v37,
		refetchTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v38,
		refetchTrustedFriendRequestsCount = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v39,
		sendTrustedConnectionRequest = function(s10: string, s11: string?) -- line: 337
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy)
			return Requests.PostUserSendTrustedConnectionRequest(s10, s11):andThen(function() -- line: 338
				-- upvalues: v20 (copy), s10 (copy), TrustedConnectionStatus (copy)
				v20.updateItems({
					[s10] = TrustedConnectionStatus.RequestSent
				})
			end)
		end,
		acceptTrustedConnectionRequest = function(s12: string) -- line: 345
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy), v21 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v27 (copy)
			return Requests.PostUserAcceptTrustedConnectionRequest(s12):andThen(function() -- line: 346
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
		ignoreTrustedConnectionRequest = function(s13: string) -- line: 361
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v27 (copy)
			return Requests.PostUserIgnoreTrustedConnectionRequest(s13):andThen(function() -- line: 362
				-- upvalues: v20 (copy), s13 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v27 (copy)
				v20.updateItems({
					[s13] = TrustedConnectionStatus.RequestIgnored
				})

				if FFlagAddFriendsPageTrustedFriendRequestSection then
					v27(s13)
				end
			end)
		end,
		ignoreNonFriendTrustedFriendRequest = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v40,
		ignoreAllTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v41,
		removeTrustedConnectionRequest = function(s14: string) -- line: 393
			-- upvalues: Requests (copy), v20 (copy), TrustedConnectionStatus (copy), v21 (copy)
			return Requests.PostUserRemoveTrustedConnection(s14):andThen(function() -- line: 394
				-- upvalues: v20 (copy), s14 (copy), TrustedConnectionStatus (copy), v21 (copy)
				v20.updateItems({
					[s14] = TrustedConnectionStatus.RequestReceived
				})
				v21.updateItems({
					[s14] = false
				})
			end)
		end,
		createTrustedFriendLink = function(s15: string) -- line: 405
			-- upvalues: Requests (copy)
			return Requests.PostUserCreateTrustedFriendLink(s15)
		end,
		validateTrustedFriendLink = if not FFlagTCShareLinkReceiverUI then nil else function(s16: string, t3: {[any]: any}) -- line: 409
			-- upvalues: Requests (copy)
			return Requests.PostUserValidateTrustedFriendLink(s16, t3)
		end,
		addTrustedFriendFromLink = if not FFlagTCShareLinkReceiverUI then nil else function(s17: string, t4: {[any]: any}) -- line: 413
			-- upvalues: Requests (copy)
			return Requests.PostUserAddTrustedFriendFromLink(s17, t4)
		end,
		clear = function() -- line: 417
			-- upvalues: v20 (copy), v21 (copy), v30 (copy), v31 (copy), FFlagConnectionManagementChips (copy), v22 (copy), v28 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v23 (copy), v32 (copy), v24 (copy), v33 (copy)
			v20.clear()
			v21.clear()
			v30.clear()
			v31.clear()

			if FFlagConnectionManagementChips then
				v22.clear()
				v28.clear()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v23.clear()
				v32.clear()
				v24.clear()
				v33.clear()
			end
		end,
		dispose = function() -- line: 436
			-- upvalues: v20 (copy), v21 (copy), v30 (copy), v31 (copy), v29 (copy), FFlagConnectionManagementChips (copy), v22 (copy), v28 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v23 (copy), v32 (copy), v24 (copy), v33 (copy)
			v20.dispose()
			v21.dispose()
			v30.dispose()
			v31.dispose()
			v29()

			if FFlagConnectionManagementChips then
				v22.dispose()
				v28.dispose()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v23.dispose()
				v32.dispose()
				v24.dispose()
				v33.dispose()
			end
		end
	}
end

return createTrustedConnectionsStore
