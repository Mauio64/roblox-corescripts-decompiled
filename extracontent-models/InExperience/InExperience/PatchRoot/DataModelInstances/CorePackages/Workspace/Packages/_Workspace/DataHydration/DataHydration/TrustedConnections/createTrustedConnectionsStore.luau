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
local v16 = game:DefineFastInt("TrustedConnectionsStoreDataTtlSec", 0)

game:DefineFastInt("TrustedConnectionsStoreProcessDelaySec", 1)
game:DefineFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec", 0)

local function createTrustedConnectionsStore() -- line: 77
	-- upvalues: v16 (copy), createDataCache (copy), FFlagConnectionManagementChips (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), getLocalPlayerUserId (copy), mergeListsWithoutDuplicates (copy), Cryo (copy), createDataResolver (copy), Requests (copy), createTrustedConnectionEventListener (copy), TrustedConnectionStatus (copy), Promise (copy), FIntTrustedFriendRequestsPageSize (copy), FFlagTCShareLinkReceiverUI (copy)
	local v18 = not (v16 > 0) and 1e999 or v16
	local v19 = createDataCache(v18)
	local v20 = createDataCache(v18)
	local v21 = if not FFlagConnectionManagementChips then nil else createDataCache(v18)
	local v22 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataCache(v18)
	local v23 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataCache(v18)
	local u24 = false
	local v25 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s1: string) -- line: 94
		-- upvalues: getLocalPlayerUserId (copy), v22 (copy), mergeListsWithoutDuplicates (copy), v23 (copy)
		local str = tostring(getLocalPlayerUserId())
		local v43 = v22.getItem(str).data(false)

		if not v43 then
			return
		end

		local v44 = mergeListsWithoutDuplicates(v43.senderIds, { s1 })

		if #v44 == #v43.senderIds then
			return
		end

		v22.replaceItem(str, {
			senderIds = v44,
			nextPageCursor = v43.nextPageCursor,
			hasMore = v43.hasMore
		})

		local v45 = v23.getItem(str).data(false)

		if v45 then
			v23.replaceItem(str, (math.max(v45 + 1, 0)))
		end
	end
	local v26 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s2: string) -- line: 120
		-- upvalues: getLocalPlayerUserId (copy), v22 (copy), Cryo (copy), v23 (copy)
		local str = tostring(getLocalPlayerUserId())
		local v48 = v22.getItem(str).data(false)

		if not v48 then
			return
		end

		local v49 = Cryo.List.removeValue(v48.senderIds, s2)

		if #v49 == #v48.senderIds then
			return
		end

		v22.replaceItem(str, {
			senderIds = v49,
			nextPageCursor = v48.nextPageCursor,
			hasMore = v48.hasMore
		})

		local v50 = v23.getItem(str).data(false)

		if v50 then
			v23.replaceItem(str, (math.max(v50 - 1, 0)))
		end
	end
	local v27 = if not FFlagConnectionManagementChips then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v21,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(s3: string) -- line: 152
			-- upvalues: Requests (copy), Cryo (copy)
			return Requests.GetUserTrustedConnections(s3):andThen(function(p1) -- line: 153
				-- upvalues: Cryo (copy)
				local v86 = p1.PageItems or {}

				return Cryo.List.map(v86, function(p2) -- line: 155
					return {
						id = tostring(p2.id)
					}
				end)
			end)
		end
	})
	local v28 = createTrustedConnectionEventListener(function(s4: string, p3) -- line: 166
		-- upvalues: v19 (copy), v20 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v25 (copy), FFlagConnectionManagementChips (copy), getLocalPlayerUserId (copy), v27 (copy)
		v19.updateItems({
			[s4] = p3
		})
		v20.updateItems({
			[s4] = p3 == TrustedConnectionStatus.TrustedFriends
		})

		if FFlagAddFriendsPageTrustedFriendRequestSection and p3 == TrustedConnectionStatus.RequestReceived then
			v25(s4)
		end

		if FFlagConnectionManagementChips then
			local v54 = getLocalPlayerUserId()

			if v54 then
				v27.fetchItem((tostring(v54)))
			end
		end
	end)
	local v29 = createDataResolver({
		cache = v20,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t1: {[any]: any}) -- line: 194
			-- upvalues: Cryo (copy), Requests (copy)
			local v56 = Cryo.Dictionary.keys(t1)

			return Requests.MultiGetUsersAreTrustedConnections(v56):andThen(function(p4) -- line: 196
				-- upvalues: Cryo (copy), v56 (copy)
				local v88 = Cryo.List.foldLeft(p4, function(p5, p6) -- line: 197
					p5[tostring(p6)] = true

					return p5
				end, {})

				return Cryo.List.foldLeft(v56, function(p7, p8) -- line: 202
					-- upvalues: v88 (copy)
					p7[tostring(p8)] = v88[p8] or false

					return p7
				end, {})
			end)
		end
	})
	local v30 = createDataResolver({
		cache = v19,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreProcessDelaySec"),
		fetchFn = function(t2: {[any]: any}) -- line: 213
			-- upvalues: Cryo (copy), Requests (copy), Promise (copy)
			local v58 = Cryo.Dictionary.keys(t2)
			local v59 = Cryo.List.foldLeft(v58, function(p9, p10) -- line: 215
				-- upvalues: Requests (copy)
				table.insert(p9, Requests.GetUserTrustedConnectionStatus(p10):andThen(function(p11) -- line: 219
					-- upvalues: p10 (copy)
					return {
						[p10] = p11
					}
				end))

				return p9
			end, {})

			return Promise.all(v59):andThen(function(p12) -- line: 226
				-- upvalues: Cryo (copy)
				return Cryo.Dictionary.join(table.unpack(p12))
			end)
		end
	})
	local v31 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v22,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
		fetchFn = function(_: string, p13) -- line: 238
			-- upvalues: u24 (ref), Requests (copy), FIntTrustedFriendRequestsPageSize (copy), Cryo (copy), mergeListsWithoutDuplicates (copy)
			local v62 = if not u24 then p13.data(false) else nil

			u24 = false

			local v63 = if not v62 then nil else v62.nextPageCursor

			return Requests.GetTrustedFriendRequests(v63, FIntTrustedFriendRequestsPageSize):andThen(function(p14) -- line: 245
				-- upvalues: Cryo (copy), v62 (copy), mergeListsWithoutDuplicates (copy)
				local v93 = if not p14 then nil else p14.data
				local v94 = Cryo.List.map(v93 or {}, function(p15) -- line: 247
					return (tostring(p15.senderId))
				end)
				local v95 = if not v62 then nil else v62.senderIds
				local v96 = if not p14 then nil else p14.nextPageCursor

				return {
					senderIds = mergeListsWithoutDuplicates(v95, v94),
					nextPageCursor = v96,
					hasMore = v96 ~= nil
				}
			end)
		end
	})
	local v32 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v23,
		queueProcessDelaySec = game:GetFastInt("TrustedConnectionsStoreIncomingRequestsProcessDelaySec"),
		fetchFn = function(_: string) -- line: 270
			-- upvalues: Requests (copy)
			return Requests.GetTrustedFriendRequestsCount():andThen(function(p16) -- line: 271
				if p16 then
					return p16.count
				end

				return 0
			end)
		end
	})
	local v33 = if not FFlagConnectionManagementChips then nil else function() -- line: 287
		-- upvalues: getLocalPlayerUserId (copy), v27 (copy)
		local v67 = getLocalPlayerUserId()

		return v27.getAndFetchItem((tostring(v67)))
	end
	local v34 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 294
		-- upvalues: getLocalPlayerUserId (copy), v31 (copy)
		local v68 = getLocalPlayerUserId()

		return v31.getAndFetchItem((tostring(v68)))
	end
	local v35 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 301
		-- upvalues: getLocalPlayerUserId (copy), v32 (copy)
		local v69 = getLocalPlayerUserId()

		return v32.getAndFetchItem((tostring(v69)))
	end
	local v36 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 308
		-- upvalues: getLocalPlayerUserId (copy), v22 (copy), v31 (copy)
		local str = tostring(getLocalPlayerUserId())
		local v71 = v22.getItem(str).data(false)

		if v71 and not v71.hasMore then
			return
		end

		v31.fetchItem(str)
	end
	local v37 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 319
		-- upvalues: u24 (ref), getLocalPlayerUserId (copy), v31 (copy)
		u24 = true

		local str = tostring(getLocalPlayerUserId())

		v31.fetchItem(str)
	end
	local v38 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 328
		-- upvalues: getLocalPlayerUserId (copy), v32 (copy)
		local str = tostring(getLocalPlayerUserId())

		v32.fetchItem(str)
	end
	local v39 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function(s7: string) -- line: 371
		-- upvalues: v26 (copy)
		v26(s7)
	end
	local v40 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else function() -- line: 377
		-- upvalues: Requests (copy), getLocalPlayerUserId (copy), v22 (copy), v23 (copy)
		return Requests.PostUserIgnoreAllTrustedFriendRequests():andThen(function() -- line: 378
			-- upvalues: getLocalPlayerUserId (copy), v22 (copy), v23 (copy)
			local str = tostring(getLocalPlayerUserId())

			v22.replaceItem(str, {
				nextPageCursor = nil,
				hasMore = false,
				senderIds = {}
			})
			v23.replaceItem(str, 0)
		end)
	end

	return {
		getStatus = function(s8: string) -- line: 278
			-- upvalues: v30 (copy)
			return v30.getAndFetchItem(s8)
		end,
		getIsTrustedConnection = function(s9: string) -- line: 282
			-- upvalues: v29 (copy)
			return v29.getAndFetchItem(s9)
		end,
		getUserTrustedConnections = if not FFlagConnectionManagementChips then nil else v33,
		getTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v34,
		getTrustedFriendRequestsCount = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v35,
		loadMoreTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v36,
		refetchTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v37,
		refetchTrustedFriendRequestsCount = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v38,
		sendTrustedConnectionRequest = function(s10: string, s11: string?) -- line: 334
			-- upvalues: Requests (copy), v19 (copy), TrustedConnectionStatus (copy)
			return Requests.PostUserSendTrustedConnectionRequest(s10, s11):andThen(function() -- line: 335
				-- upvalues: v19 (copy), s10 (copy), TrustedConnectionStatus (copy)
				v19.updateItems({
					[s10] = TrustedConnectionStatus.RequestSent
				})
			end)
		end,
		acceptTrustedConnectionRequest = function(s12: string) -- line: 342
			-- upvalues: Requests (copy), v19 (copy), TrustedConnectionStatus (copy), v20 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v26 (copy)
			return Requests.PostUserAcceptTrustedConnectionRequest(s12):andThen(function() -- line: 343
				-- upvalues: v19 (copy), s12 (copy), TrustedConnectionStatus (copy), v20 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v26 (copy)
				v19.updateItems({
					[s12] = TrustedConnectionStatus.TrustedFriends
				})
				v20.updateItems({
					[s12] = true
				})

				if FFlagAddFriendsPageTrustedFriendRequestSection then
					v26(s12)
				end
			end)
		end,
		ignoreTrustedConnectionRequest = function(s13: string) -- line: 358
			-- upvalues: Requests (copy), v19 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v26 (copy)
			return Requests.PostUserIgnoreTrustedConnectionRequest(s13):andThen(function() -- line: 359
				-- upvalues: v19 (copy), s13 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v26 (copy)
				v19.updateItems({
					[s13] = TrustedConnectionStatus.RequestIgnored
				})

				if FFlagAddFriendsPageTrustedFriendRequestSection then
					v26(s13)
				end
			end)
		end,
		ignoreNonFriendTrustedFriendRequest = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v39,
		ignoreAllTrustedFriendRequests = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else v40,
		removeTrustedConnectionRequest = function(s14: string) -- line: 390
			-- upvalues: Requests (copy), v19 (copy), TrustedConnectionStatus (copy), v20 (copy)
			return Requests.PostUserRemoveTrustedConnection(s14):andThen(function() -- line: 391
				-- upvalues: v19 (copy), s14 (copy), TrustedConnectionStatus (copy), v20 (copy)
				v19.updateItems({
					[s14] = TrustedConnectionStatus.RequestReceived
				})
				v20.updateItems({
					[s14] = false
				})
			end)
		end,
		createTrustedFriendLink = function(s15: string) -- line: 402
			-- upvalues: Requests (copy)
			return Requests.PostUserCreateTrustedFriendLink(s15)
		end,
		validateTrustedFriendLink = if not FFlagTCShareLinkReceiverUI then nil else function(s16: string, t3: {[any]: any}) -- line: 406
			-- upvalues: Requests (copy)
			return Requests.PostUserValidateTrustedFriendLink(s16, t3)
		end,
		addTrustedFriendFromLink = if not FFlagTCShareLinkReceiverUI then nil else function(s17: string, t4: {[any]: any}) -- line: 410
			-- upvalues: Requests (copy)
			return Requests.PostUserAddTrustedFriendFromLink(s17, t4)
		end,
		clear = function() -- line: 414
			-- upvalues: v19 (copy), v20 (copy), v29 (copy), v30 (copy), FFlagConnectionManagementChips (copy), v21 (copy), v27 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v22 (copy), v31 (copy), v23 (copy), v32 (copy)
			v19.clear()
			v20.clear()
			v29.clear()
			v30.clear()

			if FFlagConnectionManagementChips then
				v21.clear()
				v27.clear()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v22.clear()
				v31.clear()
				v23.clear()
				v32.clear()
			end
		end,
		dispose = function() -- line: 433
			-- upvalues: v19 (copy), v20 (copy), v29 (copy), v30 (copy), v28 (copy), FFlagConnectionManagementChips (copy), v21 (copy), v27 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), v22 (copy), v31 (copy), v23 (copy), v32 (copy)
			v19.dispose()
			v20.dispose()
			v29.dispose()
			v30.dispose()
			v28()

			if FFlagConnectionManagementChips then
				v21.dispose()
				v27.dispose()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection then
				v22.dispose()
				v31.dispose()
				v23.dispose()
				v32.dispose()
			end
		end
	}
end

return createTrustedConnectionsStore
