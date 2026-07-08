local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
local DataStatus = require(DataHydration.DataHydrationTypes).DataStatus
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local Cryo = require(DataHydrationParent.Cryo)
local Signals = require(DataHydrationParent.Signals)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local LocalUserIdStore = require(DataHydrationParent.UserLib).Stores.LocalUserIdStore
local FFlagSduiRequestFriendshipAction = SharedFlags.FFlagSduiRequestFriendshipAction
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local Requests = require(DataHydration.Friends.Requests)
local FindFriendsSort = require(DataHydration.Friends.Enums.FindFriendsSort)
local mapFriendshipStatusToEnum = require(DataHydration.Friends.mapFriendshipStatusToEnum)
local PresenceStore = require(DataHydration.Presence.PresenceStore)
local normalizePresenceRawData = require(DataHydration.Presence.normalizePresenceRawData)
local PresenceType = require(DataHydration.Presence.Enums.PresenceType)

require(DataHydration.Presence.createPresenceStore)
game:DefineFastInt("FriendsStoreProcessDelaySec", 1)

local function getFIntFriendsStoreProcessDelaySec() -- line: 114
	return game:GetFastInt("FriendsStoreProcessDelaySec")
end

local v20 = game:DefineFastInt("OnlineFriendsCacheTtlSec", 0)
local v21 = game:DefineFastInt("IsFriendsWithCacheTtlSec", 0)
local v22 = game:DefineFastInt("AllFriendsCacheTtlSec", 0)
local v23 = game:DefineFastInt("FriendshipStatusCacheTtlSec", 0)

local function getCacheTTL(p1) -- line: 123
	if p1 and p1 > 0 then
		return p1
	end

	return 1e999
end

local v25 = game:DefineFastInt("FriendsPageSize", 50)
local v26 = game:DefineFastInt("InitialFriendsPageSize", 20)

local function normalizeId(p2) -- line: 130
	if not p2 then
		return nil
	end

	return (tostring(p2))
end
local function normalizeStoredOnlineFriendRow(p3) -- line: 138
	if not p3 or (type(p3) ~= "table" or p3.id == nil) then
		return nil
	end

	return {
		id = tostring(p3.id),
		sortScore = tonumber(p3.sortScore) or 0
	}
end
local function normalizePresenceFromOnlineFriendsRow(p4) -- line: 150
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
local function normalizeFindFriendsNextCursor(s1: string?) -- line: 172
	if s1 == nil or s1 == "" then
		return nil
	end

	return s1
end
local function normalizeFindFriendsPageResponse(p5) -- line: 179
	local t2 = {}

	for _, v46 in if not p5 or not p5.PageItems then {} else p5.PageItems do
		local id = v46.id
		local v48 = if id then tostring(id) else nil

		if v48 then
			table.insert(t2, {
				id = v48
			})
		end
	end

	local v49 = if not p5 then nil else p5.NextCursor
	local v50 = if v49 ~= nil and v49 ~= "" then v49 else nil
	local v51 = if not p5 or p5.HasMore == nil then v50 ~= nil else p5.HasMore

	return {
		friends = t2,
		nextCursor = v50,
		hasMore = v51
	}
end
local function mergeListsWithoutDuplicates(t3: {[any]: any}?, t4: {[any]: any}?, s2: string?) -- line: 202
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

	local v55 = Cryo.List.toSet(Cryo.List.map(t3, function(p6) -- line: 210
		-- upvalues: s2 (copy)
		if s2 then
			return p6[s2]
		end

		return p6
	end))
	local v56 = Cryo.List.filter(t4, function(p7) -- line: 215
		-- upvalues: s2 (copy), v55 (copy)
		return not v55[if not s2 then p7 else p7[s2]]
	end)

	return Cryo.List.join(table.clone(t3), v56)
end
local function mergeAllFriendsPage(t5: {[any]: any}?, t6: {[any]: any}, s3: string?) -- line: 223
	-- upvalues: mergeListsWithoutDuplicates (copy)
	if t5 then
		local nextCursor = t5.nextCursor

		if ((if nextCursor ~= nil and nextCursor ~= "" then nextCursor else nil)) ~= if s3 ~= nil and s3 ~= "" then s3 else nil then
			return t5
		end

		return {
			friends = mergeListsWithoutDuplicates(t5.friends, t6.friends, "id"),
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
local function resolveLocalUserId(p8) -- line: 253
	-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy)
	local v62 = LocalUserIdStore.getCurrentUserId(p8)

	if v62 ~= "" then
		return v62
	end

	local v63 = getLocalPlayerUserId()

	if v63 then
		return (tostring(v63))
	end

	return ""
end
local function createFriendsStore() -- line: 262
	-- upvalues: PresenceStore (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), getLocalPlayerUserId (copy), createDataCache (copy), v20 (copy), v21 (copy), v22 (copy), FFlagSduiRequestFriendshipAction (copy), v23 (copy), LocalUserIdStore (copy), mergeListsWithoutDuplicates (copy), normalizePresenceRawData (copy), PresenceType (copy), normalizeStoredOnlineFriendRow (copy), normalizePresenceFromOnlineFriendsRow (copy), createDataResolver (copy), Requests (copy), mapFriendshipStatusToEnum (copy), Cryo (copy), v25 (copy), v26 (copy), FindFriendsSort (copy), normalizeFindFriendsPageResponse (copy), mergeAllFriendsPage (copy), Signals (copy), DataStatus (copy)
	local v64 = PresenceStore.get()
	local v65 = if not FFlagFriendSortedByPresenceSignalsImplementation then tostring(getLocalPlayerUserId()) else nil
	local v66 = createDataCache
	local v67 = v20
	local v68 = v66((not v67 or not (v67 > 0)) and 1e999 or v67)
	local v69 = createDataCache
	local v70 = v21
	local v71 = v69((not v70 or not (v70 > 0)) and 1e999 or v70)
	local v72 = createDataCache
	local v73 = v22
	local v74 = v72((not v73 or not (v73 > 0)) and 1e999 or v73)
	local u75 = false
	local v78

	if FFlagSduiRequestFriendshipAction then
		local v76 = createDataCache
		local v77 = v23

		v78 = v76((not v77 or not (v77 > 0)) and 1e999 or v77)
	else
		v78 = nil
	end

	local v79 = v78
	local t7 = {}

	local function appendUserToAllFriends(s4: string) -- line: 305
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v65 (copy), v74 (copy), mergeListsWithoutDuplicates (copy)
		local v97

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v97 = LocalUserIdStore.getCurrentUserId(false)

			if v97 ~= "" then
			else
				local v98 = getLocalPlayerUserId()

				v97 = not v98 and "" or tostring(v98)
			end
		else
			v97 = v65
		end

		local v99 = v74.getItem(v97).data(false)

		if v99 then
			local v100 = mergeListsWithoutDuplicates(v99.friends, {{
				id = s4
			}}, "id")

			if #v100 == #v99.friends then
				return
			end

			v74.replaceItem(v97, {
				friends = v100,
				nextCursor = v99.nextCursor,
				hasMore = v99.hasMore
			})
		end
	end
	local function UpdateIsFriendsWith(s5: string, b1: boolean) -- line: 323
		-- upvalues: v71 (copy), appendUserToAllFriends (copy), v64 (copy)
		v71.replaceItem(s5, b1)

		if b1 then
			appendUserToAllFriends(s5)
		end

		if not b1 then
			v64.UpdateUserPresence(s5, nil, {
				isUpdatedRealtime = false
			})
		end
	end
	local function updateOnlineFriendDependecies(p9, p10) -- line: 338
		-- upvalues: v64 (copy), v71 (copy), appendUserToAllFriends (copy)
		v64.UpdateUserPresence(p9, p10, {
			isUpdatedRealtime = true
		})
		v71.replaceItem(p9, true)
		appendUserToAllFriends(p9)
	end
	local function updateOfflineFriendDependencies(p11) -- line: 345
		-- upvalues: v64 (copy), normalizePresenceRawData (copy), PresenceType (copy), v71 (copy), appendUserToAllFriends (copy)
		local v106 = v64.GetPresenceByUserId(p11, {
			skipFetch = true
		}).data(false)

		v64.UpdateUserPresence(p11, v106 or normalizePresenceRawData({
			userPresenceType = PresenceType.Offline
		}), {
			isUpdatedRealtime = true
		})
		v71.replaceItem(p11, true)
		appendUserToAllFriends(p11)
	end
	local function applyGetOnlineFriendsResponseBody(p12) -- line: 359
		-- upvalues: normalizeStoredOnlineFriendRow (copy), normalizePresenceFromOnlineFriendsRow (copy), v64 (copy), v71 (copy), appendUserToAllFriends (copy)
		local t8 = {}

		for _, v110 in p12 and p12.data or {} do
			local id = v110.id
			local v112 = if id then tostring(id) else nil
			local v113 = normalizeStoredOnlineFriendRow(v110)
			local v114 = normalizePresenceFromOnlineFriendsRow(v110)

			if v112 then
				t8[v112] = v113
				v64.UpdateUserPresence(v112, v114, {
					isUpdatedRealtime = true
				})
				v71.replaceItem(v112, true)
				appendUserToAllFriends(v112)
			end
		end

		return t8
	end

	local v86 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v68,
		fetchFn = function(s6: string, p13) -- line: 382
			-- upvalues: Requests (copy), v64 (copy), normalizePresenceRawData (copy), PresenceType (copy), applyGetOnlineFriendsResponseBody (copy)
			local v117 = p13.data(false) or {}

			return Requests.GetOnlineFriends(s6):andThen(function(p14) -- line: 386
				-- upvalues: v117 (copy), v64 (copy), normalizePresenceRawData (copy), PresenceType (copy), applyGetOnlineFriendsResponseBody (copy)
				for _, v192 in v117 do
					local v193 = v192 and v192.id
					local v194 = if v193 then tostring(v193) else nil

					if v194 then
						v64.UpdateUserPresence(v194, normalizePresenceRawData({
							userPresenceType = PresenceType.Offline
						}), {
							isUpdatedRealtime = true
						})
					end
				end

				return (applyGetOnlineFriendsResponseBody(p14))
			end):catch(function(p15) -- line: 403
				error(p15)
			end)
		end
	})

	local function fetchFriendshipStatuses(t9: {[any]: any}) -- line: 412
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v65 (copy), Requests (copy), mapFriendshipStatusToEnum (copy)
		local v119

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v119 = LocalUserIdStore.getCurrentUserId(false)

			if v119 ~= "" then
			else
				local v120 = getLocalPlayerUserId()

				v119 = not v120 and "" or tostring(v120)
			end
		else
			v119 = v65
		end

		return Requests.MultiGetFriendshipStatuses(v119, t9):andThen(function(p16) -- line: 417
			-- upvalues: mapFriendshipStatusToEnum (copy)
			local t10 = {}

			for _, v199 in p16 and p16.data or {} do
				local id = v199.id
				local v201 = if id then tostring(id) else nil

				if v201 then
					t10[v201] = mapFriendshipStatusToEnum(v199.status)
				end
			end

			return t10
		end)
	end

	local v88 = createDataResolver({
		cache = v71,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(t11: {[any]: any}) -- line: 436
			-- upvalues: Cryo (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v65 (copy), Requests (copy), mapFriendshipStatusToEnum (copy), FFlagSduiRequestFriendshipAction (copy), v79 (copy)
			local v122 = Cryo.Dictionary.keys(t11)
			local v123

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v123 = LocalUserIdStore.getCurrentUserId(false)

				if v123 ~= "" then
				else
					local v124 = getLocalPlayerUserId()

					v123 = not v124 and "" or tostring(v124)
				end
			else
				v123 = v65
			end

			return Requests.MultiGetFriendshipStatuses(v123, v122):andThen(function(p17) -- line: 417
				-- upvalues: mapFriendshipStatusToEnum (copy)
				local t12 = {}

				for _, v205 in p17 and p17.data or {} do
					local id = v205.id
					local v207 = if id then tostring(id) else nil

					if v207 then
						t12[v207] = mapFriendshipStatusToEnum(v205.status)
					end
				end

				return t12
			end):andThen(function(t13: {[any]: any}) -- line: 438
				-- upvalues: FFlagSduiRequestFriendshipAction (copy), v79 (copy)
				if FFlagSduiRequestFriendshipAction then
					v79.replaceItems(t13)
				end

				local t14 = {}

				for v210, v211 in t13 do
					t14[v210] = v211 == Enum.FriendStatus.Friend
				end

				return t14
			end)
		end
	})
	local v89 = if not FFlagSduiRequestFriendshipAction then nil else createDataResolver({
		cache = v79,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(t15: {[any]: any}) -- line: 459
			-- upvalues: Cryo (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v65 (copy), Requests (copy), mapFriendshipStatusToEnum (copy), v71 (copy)
			local v126 = Cryo.Dictionary.keys(t15)
			local v127

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v127 = LocalUserIdStore.getCurrentUserId(false)

				if v127 ~= "" then
				else
					local v128 = getLocalPlayerUserId()

					v127 = not v128 and "" or tostring(v128)
				end
			else
				v127 = v65
			end

			return Requests.MultiGetFriendshipStatuses(v127, v126):andThen(function(p18) -- line: 417
				-- upvalues: mapFriendshipStatusToEnum (copy)
				local t16 = {}

				for _, v215 in p18 and p18.data or {} do
					local id = v215.id
					local v217 = if id then tostring(id) else nil

					if v217 then
						t16[v217] = mapFriendshipStatusToEnum(v215.status)
					end
				end

				return t16
			end):andThen(function(t17: {[any]: any}) -- line: 461
				-- upvalues: v71 (copy)
				local t18 = {}

				for v220, v221 in t17 do
					t18[v220] = v221 == Enum.FriendStatus.Friend
				end

				v71.replaceItems(t18)

				return t17
			end)
		end
	})
	local v90 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v74,
		fetchFn = function(p19, p20) -- line: 480
			-- upvalues: u75 (ref), v25 (copy), v26 (copy), Requests (copy), FindFriendsSort (copy), normalizeFindFriendsPageResponse (copy), updateOfflineFriendDependencies (copy), mergeAllFriendsPage (copy)
			local v131 = if not u75 then p20.data(false) else nil

			u75 = false

			local v132 = if not v131 then nil else v131.nextCursor
			local v133 = if not v131 then v26 else v25

			return Requests.GetFindFriendsPage(p19, {
				limit = v133,
				cursor = v132,
				sort = FindFriendsSort.FriendshipScore
			}):andThen(function(p21) -- line: 492
				-- upvalues: normalizeFindFriendsPageResponse (copy), updateOfflineFriendDependencies (copy), mergeAllFriendsPage (copy), v131 (copy), v132 (copy)
				local v223 = normalizeFindFriendsPageResponse(p21)

				for _, v225 in v223.friends do
					updateOfflineFriendDependencies(v225.id)
				end

				return (mergeAllFriendsPage(v131, v223, v132))
			end):catch(function(p22) -- line: 500
				error(p22)
			end)
		end
	})
	local v91 = Signals.createComputed(function(p23) -- line: 518
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v86 (copy), v64 (copy), v88 (copy), PresenceType (copy)
		local v135 = LocalUserIdStore.getCurrentUserId(p23)

		if v135 ~= "" then
		else
			local v136 = getLocalPlayerUserId()

			v135 = not v136 and "" or tostring(v136)
		end

		local v137 = v86.getAndFetchItem(v135).data(p23)

		if v137 == nil then
			return nil
		end

		local t19 = {}

		for _, v in pairs(v137) do
			if v then
				local v141 = v64.GetPresenceByUserId(v.id, {
					skipFetch = true
				}).data(p23)

				if v88.getCachedItem(v.id).data(p23) and v141 and v141.userPresenceType and v141.userPresenceType ~= PresenceType.Offline then
					table.insert(t19, {
						id = v.id,
						sortScore = v.sortScore,
						presence = v141
					})
				end
			end
		end

		return t19
	end)
	local v92 = Signals.createComputed(function(p24) -- line: 584
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v90 (copy), Cryo (copy), v88 (copy)
		local v148 = LocalUserIdStore.getCurrentUserId(p24)

		if v148 ~= "" then
		else
			local v149 = getLocalPlayerUserId()

			v148 = not v149 and "" or tostring(v149)
		end

		local v150 = v90.getAndFetchItem(v148).data(p24)

		if v150 == nil then
			return nil
		end

		local v151 = v150.friends or {}

		return {
			friends = Cryo.List.filter(v151, function(p25) -- line: 595
				-- upvalues: v88 (copy), p24 (copy)
				return v88.getCachedItem(p25.id).data(p24)
			end),
			hasMore = v150.hasMore,
			nextCursor = v150.nextCursor
		}
	end)
	local v93 = Signals.createComputed(function(p26) -- line: 606
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v90 (copy)
		local v153 = LocalUserIdStore.getCurrentUserId(p26)

		if v153 ~= "" then
		else
			local v154 = getLocalPlayerUserId()

			v153 = not v154 and "" or tostring(v154)
		end

		return v90.getCachedItem(v153).status(p26)
	end)

	return {
		GetOnlineFriends = function() -- line: 552
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v86 (copy), v91 (copy)
			local v142 = LocalUserIdStore.getCurrentUserId(false)

			if v142 ~= "" then
			else
				local v143 = getLocalPlayerUserId()

				v142 = not v143 and "" or tostring(v143)
			end

			v86.getAndFetchItem(v142)

			return v91
		end,
		GetOnlineFriendsByUniverseId = function(s7: string) -- line: 559
			-- upvalues: t7 (copy), Signals (copy), v91 (copy)
			local v145 = t7[s7]

			if v145 then
				return v145
			end

			local v146 = Signals.createComputed(function(p27) -- line: 565
				-- upvalues: v91 (copy), s7 (copy)
				local v228 = v91(p27)

				if not v228 then
					return {}
				end

				local t20 = {}

				for _, v231 in v228 do
					if v231.presence and v231.presence.universeId == s7 then
						table.insert(t20, v231)
					end
				end

				return t20
			end)

			t7[s7] = v146

			return v146
		end,
		GetAllFriends = function() -- line: 611
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v90 (copy), v92 (copy)
			local v155 = LocalUserIdStore.getCurrentUserId(false)

			if v155 ~= "" then
			else
				local v156 = getLocalPlayerUserId()

				v155 = not v156 and "" or tostring(v156)
			end

			v90.getAndFetchItem(v155)

			return v92
		end,
		GetAllFriendsStatus = function() -- line: 618
			-- upvalues: v93 (copy)
			return v93
		end,
		FetchMoreFriends = function() -- line: 622
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v90 (copy), DataStatus (copy)
			local v157 = LocalUserIdStore.getCurrentUserId(false)

			if v157 ~= "" then
			else
				local v158 = getLocalPlayerUserId()

				v157 = not v158 and "" or tostring(v158)
			end

			local v159 = v90.getCachedItem(v157)
			local v160 = v159.data(false)

			if v160 == nil or not v160.hasMore or v160.nextCursor == nil then
				return
			end

			if v159.status(false) == DataStatus.NotReady then
				return
			end

			if v90.isRequestInQueueOrInFlight(v157) then
				return
			end

			v90.fetchItem(v157)
		end,
		RefetchAllFriends = function() -- line: 642
			-- upvalues: u75 (ref), v90 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			u75 = true

			local fetchItem = v90.fetchItem
			local v162 = LocalUserIdStore.getCurrentUserId(false)

			if v162 ~= "" then
			else
				local v163 = getLocalPlayerUserId()

				v162 = not v163 and "" or tostring(v163)
			end

			fetchItem(v162)
		end,
		GetIsFriendWith = function(s8: string) -- line: 648
			-- upvalues: v88 (copy)
			return v88.getAndFetchItem(s8)
		end,
		UpdateIsFriendsWith = UpdateIsFriendsWith,
		GetFriendshipStatus = function(s9: string) -- line: 655
			-- upvalues: FFlagSduiRequestFriendshipAction (copy), v89 (copy)
			if not FFlagSduiRequestFriendshipAction or s9 == "" then
				return nil
			end

			return v89.getAndFetchItem(s9)
		end,
		UpdateFriendshipStatus = function(s10: string, p28) -- line: 664
			-- upvalues: FFlagSduiRequestFriendshipAction (copy), v79 (copy), UpdateIsFriendsWith (copy)
			if not FFlagSduiRequestFriendshipAction then
				return
			end

			v79.replaceItem(s10, p28)
			UpdateIsFriendsWith(s10, p28 == Enum.FriendStatus.Friend)
		end,
		RequestFriendship = function(s11: string, s12: string?) -- line: 676
			-- upvalues: Requests (copy), FFlagSduiRequestFriendshipAction (copy), v79 (copy), UpdateIsFriendsWith (copy)
			return Requests.RequestFriendshipFromUserId(s11, s12):andThen(function() -- line: 678
				-- upvalues: s11 (copy), FFlagSduiRequestFriendshipAction (copy), v79 (copy), UpdateIsFriendsWith (copy)
				local v233 = s11
				local FriendRequestSent = Enum.FriendStatus.FriendRequestSent

				if not FFlagSduiRequestFriendshipAction then
					return
				end

				v79.replaceItem(v233, FriendRequestSent)
				UpdateIsFriendsWith(v233, FriendRequestSent == Enum.FriendStatus.Friend)
			end):catch(function(p29) -- line: 681
				-- upvalues: s11 (copy), FFlagSduiRequestFriendshipAction (copy), v79 (copy), UpdateIsFriendsWith (copy)
				if ((if type(p29) ~= "table" then nil else p29.firstErrorCode)) == 5 then
					local v236 = s11
					local Friend = Enum.FriendStatus.Friend

					if not FFlagSduiRequestFriendshipAction then
						return
					end

					v79.replaceItem(v236, Friend)
					UpdateIsFriendsWith(v236, Friend == Enum.FriendStatus.Friend)

					return
				end

				error(p29)
			end)
		end,
		RefetchOnlineFriends = function() -- line: 697
			-- upvalues: v86 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			local fetchItem = v86.fetchItem
			local v171 = LocalUserIdStore.getCurrentUserId(false)

			if v171 ~= "" then
			else
				local v172 = getLocalPlayerUserId()

				v171 = not v172 and "" or tostring(v172)
			end

			fetchItem(v171)
		end,
		clear = function() -- line: 745
			-- upvalues: v86 (copy), v88 (copy), v90 (copy), FFlagSduiRequestFriendshipAction (copy), v89 (copy), t7 (copy)
			v86.clear()
			v88.clear()
			v90.clear()

			if FFlagSduiRequestFriendshipAction then
				v89.clear()
			end

			table.clear(t7)
		end,
		dispose = function() -- line: 755
			-- upvalues: v86 (copy), v88 (copy), v90 (copy), FFlagSduiRequestFriendshipAction (copy), v89 (copy), t7 (copy)
			v86.dispose()
			v88.dispose()
			v90.dispose()

			if FFlagSduiRequestFriendshipAction then
				v89.dispose()
			end

			table.clear(t7)
		end,
		_fetchOnlineFriendsAsync = function() -- line: 703
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), Requests (copy), applyGetOnlineFriendsResponseBody (copy), v68 (copy)
			local v173 = LocalUserIdStore.getCurrentUserId(false)

			if v173 ~= "" then
			else
				local v174 = getLocalPlayerUserId()

				v173 = not v174 and "" or tostring(v174)
			end

			local v175 = v173

			return Requests.GetOnlineFriends(v175):andThen(function(p30) -- line: 706
				-- upvalues: applyGetOnlineFriendsResponseBody (copy), v68 (copy), v175 (copy)
				local v239 = applyGetOnlineFriendsResponseBody(p30)

				v68.replaceItems({
					[v175] = v239
				})

				return p30 or {
					data = nil
				}
			end):catch(function(p31) -- line: 711
				error(p31)
			end)
		end,
		_updateFriendsPresences = function(t21: {[any]: any}?, t22: {[any]: any}?, _: string?) -- line: 716
			-- upvalues: normalizeStoredOnlineFriendRow (copy), normalizePresenceRawData (copy), v64 (copy), v71 (copy), appendUserToAllFriends (copy), v68 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			if not t21 then
				return
			end

			local v179 = t22 or {}
			local t23 = {}

			for _, v in pairs(t21) do
				local userId = v.userId
				local v184 = if userId then tostring(userId) else nil

				if v184 then
					local v185 = normalizeStoredOnlineFriendRow({
						id = v184,
						sortScore = v179[v184]
					})
					local v186 = normalizePresenceRawData(v)

					t23[v184] = v185
					v64.UpdateUserPresence(v184, v186, {
						isUpdatedRealtime = true
					})
					v71.replaceItem(v184, true)
					appendUserToAllFriends(v184)
				end
			end

			local updateItem = v68.updateItem
			local v188 = LocalUserIdStore.getCurrentUserId(false)

			if v188 ~= "" then
			else
				local v189 = getLocalPlayerUserId()

				v188 = not v189 and "" or tostring(v189)
			end

			updateItem(v188, t23)
		end
	}
end

return createFriendsStore
