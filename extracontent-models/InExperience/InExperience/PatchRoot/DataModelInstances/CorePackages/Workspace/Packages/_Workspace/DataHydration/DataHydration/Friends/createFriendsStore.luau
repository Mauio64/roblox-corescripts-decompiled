local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
local DataStatus = require(DataHydration.DataHydrationTypes).DataStatus
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local mergeListsWithoutDuplicates = require(DataHydration.DataHydrationUtils).mergeListsWithoutDuplicates
local Cryo = require(DataHydrationParent.Cryo)
local Signals = require(DataHydrationParent.Signals)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local LocalUserIdStore = require(DataHydrationParent.LocalUserIdStore).LocalUserIdStore
local FFlagSduiRequestFriendshipAction = SharedFlags.FFlagSduiRequestFriendshipAction
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local FFlagAddFriendsPageTrustedFriendRequestSection = require(DataHydrationParent.SharedFlags).FFlagAddFriendsPageTrustedFriendRequestSection
local Requests = require(DataHydration.Friends.Requests)
local FindFriendsSort = require(DataHydration.Friends.Enums.FindFriendsSort)
local mapFriendshipStatusToEnum = require(DataHydration.Friends.mapFriendshipStatusToEnum)
local PresenceStore = require(DataHydration.Presence.PresenceStore)
local normalizePresenceRawData = require(DataHydration.Presence.normalizePresenceRawData)
local PresenceType = require(DataHydration.Presence.Enums.PresenceType)

require(DataHydration.Presence.createPresenceStore)
game:DefineFastInt("FriendsStoreProcessDelaySec", 1)

local function getFIntFriendsStoreProcessDelaySec() -- line: 124
	return game:GetFastInt("FriendsStoreProcessDelaySec")
end

local v22 = game:DefineFastInt("OnlineFriendsCacheTtlSec", 0)
local v23 = game:DefineFastInt("IsFriendsWithCacheTtlSec", 0)
local v24 = game:DefineFastInt("AllFriendsCacheTtlSec", 0)
local v25 = game:DefineFastInt("FriendshipStatusCacheTtlSec", 0)

local function getCacheTTL(p1) -- line: 133
	if p1 and p1 > 0 then
		return p1
	end

	return 1e999
end

local v27 = game:DefineFastInt("FriendsPageSize", 50)
local v28 = game:DefineFastInt("InitialFriendsPageSize", 20)

local function normalizeId(p2) -- line: 140
	if not p2 then
		return nil
	end

	return (tostring(p2))
end
local function normalizeStoredOnlineFriendRow(p3) -- line: 148
	if not p3 or (type(p3) ~= "table" or p3.id == nil) then
		return nil
	end

	return {
		id = tostring(p3.id),
		sortScore = tonumber(p3.sortScore) or 0
	}
end
local function normalizePresenceFromOnlineFriendsRow(p4) -- line: 160
	-- upvalues: normalizePresenceRawData (copy)
	if not p4 or (type(p4) ~= "table" or p4.id == nil) then
		return nil
	end

	local userPresence = p4.userPresence

	if not userPresence or type(userPresence) ~= "table" then
		return nil
	end

	local t1 = {
		userPresenceType = userPresence.UserPresenceType,
		lastLocation = userPresence.lastLocation,
		lastOnline = userPresence.lastOnline,
		gameId = userPresence.gameInstanceId,
		placeId = userPresence.placeId,
		rootPlaceId = userPresence.rootPlaceId,
		universeId = userPresence.universeId
	}

	return normalizePresenceRawData(t1, p4.id)
end
local function normalizeFindFriendsNextCursor(s1: string?) -- line: 182
	if s1 == nil or s1 == "" then
		return nil
	end

	return s1
end
local function normalizeFindFriendsPageResponse(p5) -- line: 189
	local t2 = {}

	for _, v48 in if not p5 or not p5.PageItems then {} else p5.PageItems do
		local id = v48.id
		local v50 = if id then tostring(id) else nil

		if v50 then
			table.insert(t2, {
				id = v50
			})
		end
	end

	local v51 = if not p5 then nil else p5.NextCursor
	local v52 = if v51 ~= nil and v51 ~= "" then v51 else nil
	local v53 = if not p5 or p5.HasMore == nil then v52 ~= nil else p5.HasMore

	return {
		friends = t2,
		nextCursor = v52,
		hasMore = v53
	}
end
local function mergeListsWithoutDuplicates2(t3: {[any]: any}?, t4: {[any]: any}?, s2: string?) -- line: 212
	-- upvalues: Cryo (copy)
	if not t4 or #t4 == 0 then
		if t3 then
			return t3
		end

		return {}
	end

	if not t3 or #t3 == 0 then
		return t4
	end

	local v57 = Cryo.List.toSet(Cryo.List.map(t3, function(p6) -- line: 220
		-- upvalues: s2 (copy)
		if s2 then
			return p6[s2]
		end

		return p6
	end))
	local v58 = Cryo.List.filter(t4, function(p7) -- line: 225
		-- upvalues: s2 (copy), v57 (copy)
		return not v57[if not s2 then p7 else p7[s2]]
	end)

	return Cryo.List.join(table.clone(t3), v58)
end
local function mergeAllFriendsPage(t5: {[any]: any}?, t6: {[any]: any}, s3: string?) -- line: 233
	-- upvalues: FFlagAddFriendsPageTrustedFriendRequestSection (copy), mergeListsWithoutDuplicates (copy), mergeListsWithoutDuplicates2 (copy)
	if t5 then
		local nextCursor = t5.nextCursor

		if ((if nextCursor ~= nil and nextCursor ~= "" then nextCursor else nil)) ~= if s3 ~= nil and s3 ~= "" then s3 else nil then
			return t5
		end

		return {
			friends = if not FFlagAddFriendsPageTrustedFriendRequestSection then mergeListsWithoutDuplicates2(t5.friends, t6.friends, "id") else mergeListsWithoutDuplicates(t5.friends, t6.friends, "id"),
			nextCursor = t6.nextCursor,
			hasMore = t6.hasMore
		}
	end

	return {
		friends = t6.friends,
		nextCursor = t6.nextCursor,
		hasMore = t6.hasMore
	}
end
local function resolveLocalUserId(p8) -- line: 265
	-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy)
	local v64 = LocalUserIdStore.getCurrentUserId(p8)

	if v64 ~= "" then
		return v64
	end

	local v65 = getLocalPlayerUserId()

	if v65 then
		return (tostring(v65))
	end

	return ""
end
local function createFriendsStore() -- line: 274
	-- upvalues: PresenceStore (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), getLocalPlayerUserId (copy), createDataCache (copy), v22 (copy), v23 (copy), v24 (copy), FFlagSduiRequestFriendshipAction (copy), v25 (copy), LocalUserIdStore (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), mergeListsWithoutDuplicates (copy), mergeListsWithoutDuplicates2 (copy), normalizePresenceRawData (copy), PresenceType (copy), normalizeStoredOnlineFriendRow (copy), normalizePresenceFromOnlineFriendsRow (copy), createDataResolver (copy), Requests (copy), mapFriendshipStatusToEnum (copy), Cryo (copy), v27 (copy), v28 (copy), FindFriendsSort (copy), normalizeFindFriendsPageResponse (copy), mergeAllFriendsPage (copy), Signals (copy), DataStatus (copy)
	local v66 = PresenceStore.get()
	local v67 = if not FFlagFriendSortedByPresenceSignalsImplementation then tostring(getLocalPlayerUserId()) else nil
	local v68 = createDataCache
	local v69 = v22
	local v70 = v68((not v69 or not (v69 > 0)) and 1e999 or v69)
	local v71 = createDataCache
	local v72 = v23
	local v73 = v71((not v72 or not (v72 > 0)) and 1e999 or v72)
	local v74 = createDataCache
	local v75 = v24
	local v76 = v74((not v75 or not (v75 > 0)) and 1e999 or v75)
	local u77 = false
	local v80

	if FFlagSduiRequestFriendshipAction then
		local v78 = createDataCache
		local v79 = v25

		v80 = v78((not v79 or not (v79 > 0)) and 1e999 or v79)
	else
		v80 = nil
	end

	local v81 = v80
	local t7 = {}

	local function appendUserToAllFriends(s4: string) -- line: 317
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), v76 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), mergeListsWithoutDuplicates (copy), mergeListsWithoutDuplicates2 (copy)
		local v100

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v100 = LocalUserIdStore.getCurrentUserId(false)

			if v100 ~= "" then
			else
				local v101 = getLocalPlayerUserId()

				v100 = not v101 and "" or tostring(v101)
			end
		else
			v100 = v67
		end

		local v102 = v76.getItem(v100).data(false)

		if v102 then
			local v103 = if not FFlagAddFriendsPageTrustedFriendRequestSection then mergeListsWithoutDuplicates2(v102.friends, {{
				id = s4
			}}, "id") else mergeListsWithoutDuplicates(v102.friends, {{
				id = s4
			}}, "id")

			if #v103 == #v102.friends then
				return
			end

			v76.replaceItem(v100, {
				friends = v103,
				nextCursor = v102.nextCursor,
				hasMore = v102.hasMore
			})
		end
	end
	local function UpdateIsFriendsWith(s5: string, b1: boolean) -- line: 337
		-- upvalues: v73 (copy), appendUserToAllFriends (copy), v66 (copy)
		v73.replaceItem(s5, b1)

		if b1 then
			appendUserToAllFriends(s5)
		end

		if not b1 then
			v66.UpdateUserPresence(s5, nil, {
				isUpdatedRealtime = false
			})
		end
	end
	local function updateOnlineFriendDependecies(p9, p10) -- line: 352
		-- upvalues: v66 (copy), v73 (copy), appendUserToAllFriends (copy)
		v66.UpdateUserPresence(p9, p10, {
			isUpdatedRealtime = true
		})
		v73.replaceItem(p9, true)
		appendUserToAllFriends(p9)
	end
	local function updateOfflineFriendDependencies(p11) -- line: 359
		-- upvalues: v66 (copy), normalizePresenceRawData (copy), PresenceType (copy), v73 (copy), appendUserToAllFriends (copy)
		local v109 = v66.GetPresenceByUserId(p11, {
			skipFetch = true
		}).data(false)

		v66.UpdateUserPresence(p11, v109 or normalizePresenceRawData({
			userPresenceType = PresenceType.Offline
		}), {
			isUpdatedRealtime = true
		})
		v73.replaceItem(p11, true)
		appendUserToAllFriends(p11)
	end
	local function applyGetOnlineFriendsResponseBody(p12) -- line: 373
		-- upvalues: normalizeStoredOnlineFriendRow (copy), normalizePresenceFromOnlineFriendsRow (copy), v66 (copy), v73 (copy), appendUserToAllFriends (copy)
		local t8 = {}

		for _, v113 in p12 and p12.data or {} do
			local id = v113.id
			local v115 = if id then tostring(id) else nil
			local v116 = normalizeStoredOnlineFriendRow(v113)
			local v117 = normalizePresenceFromOnlineFriendsRow(v113)

			if v115 then
				t8[v115] = v116
				v66.UpdateUserPresence(v115, v117, {
					isUpdatedRealtime = true
				})
				v73.replaceItem(v115, true)
				appendUserToAllFriends(v115)
			end
		end

		return t8
	end

	local v88 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v70,
		fetchFn = function(s6: string, p13) -- line: 396
			-- upvalues: Requests (copy), v66 (copy), normalizePresenceRawData (copy), PresenceType (copy), applyGetOnlineFriendsResponseBody (copy)
			local v120 = p13.data(false) or {}

			return Requests.GetOnlineFriends(s6):andThen(function(p14) -- line: 400
				-- upvalues: v120 (copy), v66 (copy), normalizePresenceRawData (copy), PresenceType (copy), applyGetOnlineFriendsResponseBody (copy)
				for _, v200 in v120 do
					local v201 = v200 and v200.id
					local v202 = if v201 then tostring(v201) else nil

					if v202 then
						v66.UpdateUserPresence(v202, normalizePresenceRawData({
							userPresenceType = PresenceType.Offline
						}), {
							isUpdatedRealtime = true
						})
					end
				end

				return (applyGetOnlineFriendsResponseBody(p14))
			end):catch(function(p15) -- line: 417
				error(p15)
			end)
		end
	})

	local function fetchFriendshipStatuses(t9: {[any]: any}) -- line: 426
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), Requests (copy), mapFriendshipStatusToEnum (copy)
		local v122

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v122 = LocalUserIdStore.getCurrentUserId(false)

			if v122 ~= "" then
			else
				local v123 = getLocalPlayerUserId()

				v122 = not v123 and "" or tostring(v123)
			end
		else
			v122 = v67
		end

		return Requests.MultiGetFriendshipStatuses(v122, t9):andThen(function(p16) -- line: 431
			-- upvalues: mapFriendshipStatusToEnum (copy)
			local t10 = {}

			for _, v207 in p16 and p16.data or {} do
				local id = v207.id
				local v209 = if id then tostring(id) else nil

				if v209 then
					t10[v209] = mapFriendshipStatusToEnum(v207.status)
				end
			end

			return t10
		end)
	end

	local v90 = createDataResolver({
		cache = v73,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(t11: {[any]: any}) -- line: 450
			-- upvalues: Cryo (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), Requests (copy), mapFriendshipStatusToEnum (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy)
			local v125 = Cryo.Dictionary.keys(t11)
			local v126

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v126 = LocalUserIdStore.getCurrentUserId(false)

				if v126 ~= "" then
				else
					local v127 = getLocalPlayerUserId()

					v126 = not v127 and "" or tostring(v127)
				end
			else
				v126 = v67
			end

			return Requests.MultiGetFriendshipStatuses(v126, v125):andThen(function(p17) -- line: 431
				-- upvalues: mapFriendshipStatusToEnum (copy)
				local t12 = {}

				for _, v213 in p17 and p17.data or {} do
					local id = v213.id
					local v215 = if id then tostring(id) else nil

					if v215 then
						t12[v215] = mapFriendshipStatusToEnum(v213.status)
					end
				end

				return t12
			end):andThen(function(t13: {[any]: any}) -- line: 452
				-- upvalues: FFlagSduiRequestFriendshipAction (copy), v81 (copy)
				if FFlagSduiRequestFriendshipAction then
					v81.replaceItems(t13)
				end

				local t14 = {}

				for v218, v219 in t13 do
					t14[v218] = v219 == Enum.FriendStatus.Friend
				end

				return t14
			end)
		end
	})
	local v91 = if not FFlagSduiRequestFriendshipAction then nil else createDataResolver({
		cache = v81,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(t15: {[any]: any}) -- line: 473
			-- upvalues: Cryo (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), Requests (copy), mapFriendshipStatusToEnum (copy), v73 (copy)
			local v129 = Cryo.Dictionary.keys(t15)
			local v130

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v130 = LocalUserIdStore.getCurrentUserId(false)

				if v130 ~= "" then
				else
					local v131 = getLocalPlayerUserId()

					v130 = not v131 and "" or tostring(v131)
				end
			else
				v130 = v67
			end

			return Requests.MultiGetFriendshipStatuses(v130, v129):andThen(function(p18) -- line: 431
				-- upvalues: mapFriendshipStatusToEnum (copy)
				local t16 = {}

				for _, v223 in p18 and p18.data or {} do
					local id = v223.id
					local v225 = if id then tostring(id) else nil

					if v225 then
						t16[v225] = mapFriendshipStatusToEnum(v223.status)
					end
				end

				return t16
			end):andThen(function(t17: {[any]: any}) -- line: 475
				-- upvalues: v73 (copy)
				local t18 = {}

				for v228, v229 in t17 do
					t18[v228] = v229 == Enum.FriendStatus.Friend
				end

				v73.replaceItems(t18)

				return t17
			end)
		end
	})
	local v92 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v76,
		fetchFn = function(p19, p20) -- line: 494
			-- upvalues: u77 (ref), v27 (copy), v28 (copy), Requests (copy), FindFriendsSort (copy), normalizeFindFriendsPageResponse (copy), updateOfflineFriendDependencies (copy), mergeAllFriendsPage (copy)
			local v134 = if not u77 then p20.data(false) else nil

			u77 = false

			local v135 = if not v134 then nil else v134.nextCursor
			local v136 = if not v134 then v28 else v27

			return Requests.GetFindFriendsPage(p19, {
				limit = v136,
				cursor = v135,
				sort = FindFriendsSort.FriendshipScore
			}):andThen(function(p21) -- line: 506
				-- upvalues: normalizeFindFriendsPageResponse (copy), updateOfflineFriendDependencies (copy), mergeAllFriendsPage (copy), v134 (copy), v135 (copy)
				local v231 = normalizeFindFriendsPageResponse(p21)

				for _, v233 in v231.friends do
					updateOfflineFriendDependencies(v233.id)
				end

				return (mergeAllFriendsPage(v134, v231, v135))
			end):catch(function(p22) -- line: 514
				error(p22)
			end)
		end
	})
	local v93 = Signals.createComputed(function(p23) -- line: 532
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v88 (copy), v66 (copy), v90 (copy), PresenceType (copy)
		local v138 = LocalUserIdStore.getCurrentUserId(p23)

		if v138 ~= "" then
		else
			local v139 = getLocalPlayerUserId()

			v138 = not v139 and "" or tostring(v139)
		end

		local v140 = v88.getAndFetchItem(v138).data(p23)

		if v140 == nil then
			return nil
		end

		local t19 = {}

		for _, v in pairs(v140) do
			if v then
				local v144 = v66.GetPresenceByUserId(v.id, {
					skipFetch = true
				}).data(p23)

				if v90.getCachedItem(v.id).data(p23) and v144 and v144.userPresenceType and v144.userPresenceType ~= PresenceType.Offline then
					table.insert(t19, {
						id = v.id,
						sortScore = v.sortScore,
						presence = v144
					})
				end
			end
		end

		return t19
	end)
	local v94 = Signals.createComputed(function(p24) -- line: 573
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v88 (copy)
		local v148 = LocalUserIdStore.getCurrentUserId(p24)

		if v148 ~= "" then
		else
			local v149 = getLocalPlayerUserId()

			v148 = not v149 and "" or tostring(v149)
		end

		return v88.getCachedItem(v148).status(p24)
	end)
	local v95 = Signals.createComputed(function(p25) -- line: 607
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy), Cryo (copy), v90 (copy)
		local v154 = LocalUserIdStore.getCurrentUserId(p25)

		if v154 ~= "" then
		else
			local v155 = getLocalPlayerUserId()

			v154 = not v155 and "" or tostring(v155)
		end

		local v156 = v92.getAndFetchItem(v154).data(p25)

		if v156 == nil then
			return nil
		end

		local v157 = v156.friends or {}

		return {
			friends = Cryo.List.filter(v157, function(p26) -- line: 618
				-- upvalues: v90 (copy), p25 (copy)
				return v90.getCachedItem(p26.id).data(p25)
			end),
			hasMore = v156.hasMore,
			nextCursor = v156.nextCursor
		}
	end)
	local v96 = Signals.createComputed(function(p27) -- line: 629
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy)
		local v159 = LocalUserIdStore.getCurrentUserId(p27)

		if v159 ~= "" then
		else
			local v160 = getLocalPlayerUserId()

			v159 = not v160 and "" or tostring(v160)
		end

		return v92.getCachedItem(v159).status(p27)
	end)

	return {
		GetOnlineFriends = function() -- line: 566
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v88 (copy), v93 (copy)
			local v145 = LocalUserIdStore.getCurrentUserId(false)

			if v145 ~= "" then
			else
				local v146 = getLocalPlayerUserId()

				v145 = not v146 and "" or tostring(v146)
			end

			v88.getAndFetchItem(v145)

			return v93
		end,
		GetOnlineFriendsStatus = function() -- line: 578
			-- upvalues: v94 (copy)
			return v94
		end,
		GetOnlineFriendsByUniverseId = function(s7: string) -- line: 582
			-- upvalues: t7 (copy), Signals (copy), v93 (copy)
			local v151 = t7[s7]

			if v151 then
				return v151
			end

			local v152 = Signals.createComputed(function(p28) -- line: 588
				-- upvalues: v93 (copy), s7 (copy)
				local v236 = v93(p28)

				if not v236 then
					return {}
				end

				local t20 = {}

				for _, v239 in v236 do
					if v239.presence and v239.presence.universeId == s7 then
						table.insert(t20, v239)
					end
				end

				return t20
			end)

			t7[s7] = v152

			return v152
		end,
		GetAllFriends = function() -- line: 634
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy), v95 (copy)
			local v161 = LocalUserIdStore.getCurrentUserId(false)

			if v161 ~= "" then
			else
				local v162 = getLocalPlayerUserId()

				v161 = not v162 and "" or tostring(v162)
			end

			v92.getAndFetchItem(v161)

			return v95
		end,
		GetAllFriendsStatus = function() -- line: 641
			-- upvalues: v96 (copy)
			return v96
		end,
		FetchMoreFriends = function() -- line: 645
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy), DataStatus (copy)
			local v163 = LocalUserIdStore.getCurrentUserId(false)

			if v163 ~= "" then
			else
				local v164 = getLocalPlayerUserId()

				v163 = not v164 and "" or tostring(v164)
			end

			local v165 = v92.getCachedItem(v163)
			local v166 = v165.data(false)

			if v166 == nil or not v166.hasMore or v166.nextCursor == nil then
				return
			end

			if v165.status(false) == DataStatus.NotReady then
				return
			end

			if v92.isRequestInQueueOrInFlight(v163) then
				return
			end

			v92.fetchItem(v163)
		end,
		RefetchAllFriends = function() -- line: 665
			-- upvalues: u77 (ref), v92 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			u77 = true

			local fetchItem = v92.fetchItem
			local v168 = LocalUserIdStore.getCurrentUserId(false)

			if v168 ~= "" then
			else
				local v169 = getLocalPlayerUserId()

				v168 = not v169 and "" or tostring(v169)
			end

			fetchItem(v168)
		end,
		GetIsFriendWith = function(s8: string) -- line: 671
			-- upvalues: v90 (copy)
			return v90.getAndFetchItem(s8)
		end,
		UpdateIsFriendsWith = UpdateIsFriendsWith,
		GetFriendshipStatus = function(s9: string) -- line: 678
			-- upvalues: FFlagSduiRequestFriendshipAction (copy), v91 (copy)
			if not FFlagSduiRequestFriendshipAction or s9 == "" then
				return nil
			end

			return v91.getAndFetchItem(s9)
		end,
		UpdateFriendshipStatus = function(s10: string, p29) -- line: 687
			-- upvalues: FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
			if not FFlagSduiRequestFriendshipAction then
				return
			end

			v81.replaceItem(s10, p29)
			UpdateIsFriendsWith(s10, p29 == Enum.FriendStatus.Friend)
		end,
		RequestFriendship = function(s11: string, s12: string?) -- line: 699
			-- upvalues: Requests (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
			return Requests.RequestFriendshipFromUserId(s11, s12):andThen(function() -- line: 701
				-- upvalues: s11 (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
				local v241 = s11
				local FriendRequestSent = Enum.FriendStatus.FriendRequestSent

				if not FFlagSduiRequestFriendshipAction then
					return
				end

				v81.replaceItem(v241, FriendRequestSent)
				UpdateIsFriendsWith(v241, FriendRequestSent == Enum.FriendStatus.Friend)
			end):catch(function(p30) -- line: 704
				-- upvalues: s11 (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
				if ((if type(p30) ~= "table" then nil else p30.firstErrorCode)) == 5 then
					local v244 = s11
					local Friend = Enum.FriendStatus.Friend

					if not FFlagSduiRequestFriendshipAction then
						return
					end

					v81.replaceItem(v244, Friend)
					UpdateIsFriendsWith(v244, Friend == Enum.FriendStatus.Friend)

					return
				end

				error(p30)
			end)
		end,
		AcceptFriendRequest = function(s13: string) -- line: 725
			-- upvalues: Requests (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
			return Requests.AcceptFriendRequestFromUserId(s13):andThen(function() -- line: 727
				-- upvalues: s13 (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
				local v246 = s13
				local Friend = Enum.FriendStatus.Friend

				if not FFlagSduiRequestFriendshipAction then
					return
				end

				v81.replaceItem(v246, Friend)
				UpdateIsFriendsWith(v246, Friend == Enum.FriendStatus.Friend)
			end):catch(function(p31) -- line: 730
				-- upvalues: s13 (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
				if ((if type(p31) ~= "table" then nil else p31.firstErrorCode)) == 5 then
					local v249 = s13
					local Friend = Enum.FriendStatus.Friend

					if not FFlagSduiRequestFriendshipAction then
						return
					end

					v81.replaceItem(v249, Friend)
					UpdateIsFriendsWith(v249, Friend == Enum.FriendStatus.Friend)

					return
				end

				error(p31)
			end)
		end,
		DeclineFriendRequest = function(s14: string) -- line: 748
			-- upvalues: Requests (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
			return Requests.DeclineFriendRequestFromUserId(s14):andThen(function() -- line: 749
				-- upvalues: s14 (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
				local v251 = s14
				local NotFriend = Enum.FriendStatus.NotFriend

				if not FFlagSduiRequestFriendshipAction then
					return
				end

				v81.replaceItem(v251, NotFriend)
				UpdateIsFriendsWith(v251, NotFriend == Enum.FriendStatus.Friend)
			end)
		end,
		RefetchOnlineFriends = function() -- line: 754
			-- upvalues: v88 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			local fetchItem = v88.fetchItem
			local v179 = LocalUserIdStore.getCurrentUserId(false)

			if v179 ~= "" then
			else
				local v180 = getLocalPlayerUserId()

				v179 = not v180 and "" or tostring(v180)
			end

			fetchItem(v179)
		end,
		clear = function() -- line: 802
			-- upvalues: v88 (copy), v90 (copy), v92 (copy), FFlagSduiRequestFriendshipAction (copy), v91 (copy), t7 (copy)
			v88.clear()
			v90.clear()
			v92.clear()

			if FFlagSduiRequestFriendshipAction then
				v91.clear()
			end

			table.clear(t7)
		end,
		dispose = function() -- line: 812
			-- upvalues: v88 (copy), v90 (copy), v92 (copy), FFlagSduiRequestFriendshipAction (copy), v91 (copy), t7 (copy)
			v88.dispose()
			v90.dispose()
			v92.dispose()

			if FFlagSduiRequestFriendshipAction then
				v91.dispose()
			end

			table.clear(t7)
		end,
		_fetchOnlineFriendsAsync = function() -- line: 760
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), Requests (copy), applyGetOnlineFriendsResponseBody (copy), v70 (copy)
			local v181 = LocalUserIdStore.getCurrentUserId(false)

			if v181 ~= "" then
			else
				local v182 = getLocalPlayerUserId()

				v181 = not v182 and "" or tostring(v182)
			end

			local v183 = v181

			return Requests.GetOnlineFriends(v183):andThen(function(p32) -- line: 763
				-- upvalues: applyGetOnlineFriendsResponseBody (copy), v70 (copy), v183 (copy)
				local v254 = applyGetOnlineFriendsResponseBody(p32)

				v70.replaceItems({
					[v183] = v254
				})

				return p32 or {
					data = nil
				}
			end):catch(function(p33) -- line: 768
				error(p33)
			end)
		end,
		_updateFriendsPresences = function(t21: {[any]: any}?, t22: {[any]: any}?, _: string?) -- line: 773
			-- upvalues: normalizeStoredOnlineFriendRow (copy), normalizePresenceRawData (copy), v66 (copy), v73 (copy), appendUserToAllFriends (copy), v70 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			if not t21 then
				return
			end

			local v187 = t22 or {}
			local t23 = {}

			for _, v in pairs(t21) do
				local userId = v.userId
				local v192 = if userId then tostring(userId) else nil

				if v192 then
					local v193 = normalizeStoredOnlineFriendRow({
						id = v192,
						sortScore = v187[v192]
					})
					local v194 = normalizePresenceRawData(v)

					t23[v192] = v193
					v66.UpdateUserPresence(v192, v194, {
						isUpdatedRealtime = true
					})
					v73.replaceItem(v192, true)
					appendUserToAllFriends(v192)
				end
			end

			local updateItem = v70.updateItem
			local v196 = LocalUserIdStore.getCurrentUserId(false)

			if v196 ~= "" then
			else
				local v197 = getLocalPlayerUserId()

				v196 = not v197 and "" or tostring(v197)
			end

			updateItem(v196, t23)
		end
	}
end

return createFriendsStore
