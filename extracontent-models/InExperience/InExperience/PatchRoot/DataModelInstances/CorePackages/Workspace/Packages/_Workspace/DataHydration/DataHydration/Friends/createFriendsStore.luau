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
local LocalUserIdStore = require(DataHydrationParent.UserLib).Stores.LocalUserIdStore
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

local function getFIntFriendsStoreProcessDelaySec() -- line: 117
	return game:GetFastInt("FriendsStoreProcessDelaySec")
end

local v22 = game:DefineFastInt("OnlineFriendsCacheTtlSec", 0)
local v23 = game:DefineFastInt("IsFriendsWithCacheTtlSec", 0)
local v24 = game:DefineFastInt("AllFriendsCacheTtlSec", 0)
local v25 = game:DefineFastInt("FriendshipStatusCacheTtlSec", 0)

local function getCacheTTL(p1) -- line: 126
	if p1 and p1 > 0 then
		return p1
	end

	return 1e999
end

local v27 = game:DefineFastInt("FriendsPageSize", 50)
local v28 = game:DefineFastInt("InitialFriendsPageSize", 20)

local function normalizeId(p2) -- line: 133
	if not p2 then
		return nil
	end

	return (tostring(p2))
end
local function normalizeStoredOnlineFriendRow(p3) -- line: 141
	if not p3 or (type(p3) ~= "table" or p3.id == nil) then
		return nil
	end

	return {
		id = tostring(p3.id),
		sortScore = tonumber(p3.sortScore) or 0
	}
end
local function normalizePresenceFromOnlineFriendsRow(p4) -- line: 153
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
local function normalizeFindFriendsNextCursor(s1: string?) -- line: 175
	if s1 == nil or s1 == "" then
		return nil
	end

	return s1
end
local function normalizeFindFriendsPageResponse(p5) -- line: 182
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
local function mergeListsWithoutDuplicates2(t3: {[any]: any}?, t4: {[any]: any}?, s2: string?) -- line: 205
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

	local v57 = Cryo.List.toSet(Cryo.List.map(t3, function(p6) -- line: 213
		-- upvalues: s2 (copy)
		if s2 then
			return p6[s2]
		end

		return p6
	end))
	local v58 = Cryo.List.filter(t4, function(p7) -- line: 218
		-- upvalues: s2 (copy), v57 (copy)
		return not v57[if not s2 then p7 else p7[s2]]
	end)

	return Cryo.List.join(table.clone(t3), v58)
end
local function mergeAllFriendsPage(t5: {[any]: any}?, t6: {[any]: any}, s3: string?) -- line: 226
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
local function resolveLocalUserId(p8) -- line: 258
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
local function createFriendsStore() -- line: 267
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

	local function appendUserToAllFriends(s4: string) -- line: 310
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), v76 (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), mergeListsWithoutDuplicates (copy), mergeListsWithoutDuplicates2 (copy)
		local v99

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v99 = LocalUserIdStore.getCurrentUserId(false)

			if v99 ~= "" then
			else
				local v100 = getLocalPlayerUserId()

				v99 = not v100 and "" or tostring(v100)
			end
		else
			v99 = v67
		end

		local v101 = v76.getItem(v99).data(false)

		if v101 then
			local v102 = if not FFlagAddFriendsPageTrustedFriendRequestSection then mergeListsWithoutDuplicates2(v101.friends, {{
				id = s4
			}}, "id") else mergeListsWithoutDuplicates(v101.friends, {{
				id = s4
			}}, "id")

			if #v102 == #v101.friends then
				return
			end

			v76.replaceItem(v99, {
				friends = v102,
				nextCursor = v101.nextCursor,
				hasMore = v101.hasMore
			})
		end
	end
	local function UpdateIsFriendsWith(s5: string, b1: boolean) -- line: 330
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
	local function updateOnlineFriendDependecies(p9, p10) -- line: 345
		-- upvalues: v66 (copy), v73 (copy), appendUserToAllFriends (copy)
		v66.UpdateUserPresence(p9, p10, {
			isUpdatedRealtime = true
		})
		v73.replaceItem(p9, true)
		appendUserToAllFriends(p9)
	end
	local function updateOfflineFriendDependencies(p11) -- line: 352
		-- upvalues: v66 (copy), normalizePresenceRawData (copy), PresenceType (copy), v73 (copy), appendUserToAllFriends (copy)
		local v108 = v66.GetPresenceByUserId(p11, {
			skipFetch = true
		}).data(false)

		v66.UpdateUserPresence(p11, v108 or normalizePresenceRawData({
			userPresenceType = PresenceType.Offline
		}), {
			isUpdatedRealtime = true
		})
		v73.replaceItem(p11, true)
		appendUserToAllFriends(p11)
	end
	local function applyGetOnlineFriendsResponseBody(p12) -- line: 366
		-- upvalues: normalizeStoredOnlineFriendRow (copy), normalizePresenceFromOnlineFriendsRow (copy), v66 (copy), v73 (copy), appendUserToAllFriends (copy)
		local t8 = {}

		for _, v112 in p12 and p12.data or {} do
			local id = v112.id
			local v114 = if id then tostring(id) else nil
			local v115 = normalizeStoredOnlineFriendRow(v112)
			local v116 = normalizePresenceFromOnlineFriendsRow(v112)

			if v114 then
				t8[v114] = v115
				v66.UpdateUserPresence(v114, v116, {
					isUpdatedRealtime = true
				})
				v73.replaceItem(v114, true)
				appendUserToAllFriends(v114)
			end
		end

		return t8
	end

	local v88 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v70,
		fetchFn = function(s6: string, p13) -- line: 389
			-- upvalues: Requests (copy), v66 (copy), normalizePresenceRawData (copy), PresenceType (copy), applyGetOnlineFriendsResponseBody (copy)
			local v119 = p13.data(false) or {}

			return Requests.GetOnlineFriends(s6):andThen(function(p14) -- line: 393
				-- upvalues: v119 (copy), v66 (copy), normalizePresenceRawData (copy), PresenceType (copy), applyGetOnlineFriendsResponseBody (copy)
				for _, v194 in v119 do
					local v195 = v194 and v194.id
					local v196 = if v195 then tostring(v195) else nil

					if v196 then
						v66.UpdateUserPresence(v196, normalizePresenceRawData({
							userPresenceType = PresenceType.Offline
						}), {
							isUpdatedRealtime = true
						})
					end
				end

				return (applyGetOnlineFriendsResponseBody(p14))
			end):catch(function(p15) -- line: 410
				error(p15)
			end)
		end
	})

	local function fetchFriendshipStatuses(t9: {[any]: any}) -- line: 419
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), Requests (copy), mapFriendshipStatusToEnum (copy)
		local v121

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v121 = LocalUserIdStore.getCurrentUserId(false)

			if v121 ~= "" then
			else
				local v122 = getLocalPlayerUserId()

				v121 = not v122 and "" or tostring(v122)
			end
		else
			v121 = v67
		end

		return Requests.MultiGetFriendshipStatuses(v121, t9):andThen(function(p16) -- line: 424
			-- upvalues: mapFriendshipStatusToEnum (copy)
			local t10 = {}

			for _, v201 in p16 and p16.data or {} do
				local id = v201.id
				local v203 = if id then tostring(id) else nil

				if v203 then
					t10[v203] = mapFriendshipStatusToEnum(v201.status)
				end
			end

			return t10
		end)
	end

	local v90 = createDataResolver({
		cache = v73,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(t11: {[any]: any}) -- line: 443
			-- upvalues: Cryo (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), Requests (copy), mapFriendshipStatusToEnum (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy)
			local v124 = Cryo.Dictionary.keys(t11)
			local v125

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v125 = LocalUserIdStore.getCurrentUserId(false)

				if v125 ~= "" then
				else
					local v126 = getLocalPlayerUserId()

					v125 = not v126 and "" or tostring(v126)
				end
			else
				v125 = v67
			end

			return Requests.MultiGetFriendshipStatuses(v125, v124):andThen(function(p17) -- line: 424
				-- upvalues: mapFriendshipStatusToEnum (copy)
				local t12 = {}

				for _, v207 in p17 and p17.data or {} do
					local id = v207.id
					local v209 = if id then tostring(id) else nil

					if v209 then
						t12[v209] = mapFriendshipStatusToEnum(v207.status)
					end
				end

				return t12
			end):andThen(function(t13: {[any]: any}) -- line: 445
				-- upvalues: FFlagSduiRequestFriendshipAction (copy), v81 (copy)
				if FFlagSduiRequestFriendshipAction then
					v81.replaceItems(t13)
				end

				local t14 = {}

				for v212, v213 in t13 do
					t14[v212] = v213 == Enum.FriendStatus.Friend
				end

				return t14
			end)
		end
	})
	local v91 = if not FFlagSduiRequestFriendshipAction then nil else createDataResolver({
		cache = v81,
		queueProcessDelaySec = game:GetFastInt("FriendsStoreProcessDelaySec"),
		fetchFn = function(t15: {[any]: any}) -- line: 466
			-- upvalues: Cryo (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy), v67 (copy), Requests (copy), mapFriendshipStatusToEnum (copy), v73 (copy)
			local v128 = Cryo.Dictionary.keys(t15)
			local v129

			if FFlagFriendSortedByPresenceSignalsImplementation then
				v129 = LocalUserIdStore.getCurrentUserId(false)

				if v129 ~= "" then
				else
					local v130 = getLocalPlayerUserId()

					v129 = not v130 and "" or tostring(v130)
				end
			else
				v129 = v67
			end

			return Requests.MultiGetFriendshipStatuses(v129, v128):andThen(function(p18) -- line: 424
				-- upvalues: mapFriendshipStatusToEnum (copy)
				local t16 = {}

				for _, v217 in p18 and p18.data or {} do
					local id = v217.id
					local v219 = if id then tostring(id) else nil

					if v219 then
						t16[v219] = mapFriendshipStatusToEnum(v217.status)
					end
				end

				return t16
			end):andThen(function(t17: {[any]: any}) -- line: 468
				-- upvalues: v73 (copy)
				local t18 = {}

				for v222, v223 in t17 do
					t18[v222] = v223 == Enum.FriendStatus.Friend
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
		fetchFn = function(p19, p20) -- line: 487
			-- upvalues: u77 (ref), v27 (copy), v28 (copy), Requests (copy), FindFriendsSort (copy), normalizeFindFriendsPageResponse (copy), updateOfflineFriendDependencies (copy), mergeAllFriendsPage (copy)
			local v133 = if not u77 then p20.data(false) else nil

			u77 = false

			local v134 = if not v133 then nil else v133.nextCursor
			local v135 = if not v133 then v28 else v27

			return Requests.GetFindFriendsPage(p19, {
				limit = v135,
				cursor = v134,
				sort = FindFriendsSort.FriendshipScore
			}):andThen(function(p21) -- line: 499
				-- upvalues: normalizeFindFriendsPageResponse (copy), updateOfflineFriendDependencies (copy), mergeAllFriendsPage (copy), v133 (copy), v134 (copy)
				local v225 = normalizeFindFriendsPageResponse(p21)

				for _, v227 in v225.friends do
					updateOfflineFriendDependencies(v227.id)
				end

				return (mergeAllFriendsPage(v133, v225, v134))
			end):catch(function(p22) -- line: 507
				error(p22)
			end)
		end
	})
	local v93 = Signals.createComputed(function(p23) -- line: 525
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v88 (copy), v66 (copy), v90 (copy), PresenceType (copy)
		local v137 = LocalUserIdStore.getCurrentUserId(p23)

		if v137 ~= "" then
		else
			local v138 = getLocalPlayerUserId()

			v137 = not v138 and "" or tostring(v138)
		end

		local v139 = v88.getAndFetchItem(v137).data(p23)

		if v139 == nil then
			return nil
		end

		local t19 = {}

		for _, v in pairs(v139) do
			if v then
				local v143 = v66.GetPresenceByUserId(v.id, {
					skipFetch = true
				}).data(p23)

				if v90.getCachedItem(v.id).data(p23) and v143 and v143.userPresenceType and v143.userPresenceType ~= PresenceType.Offline then
					table.insert(t19, {
						id = v.id,
						sortScore = v.sortScore,
						presence = v143
					})
				end
			end
		end

		return t19
	end)
	local v94 = Signals.createComputed(function(p24) -- line: 591
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy), Cryo (copy), v90 (copy)
		local v150 = LocalUserIdStore.getCurrentUserId(p24)

		if v150 ~= "" then
		else
			local v151 = getLocalPlayerUserId()

			v150 = not v151 and "" or tostring(v151)
		end

		local v152 = v92.getAndFetchItem(v150).data(p24)

		if v152 == nil then
			return nil
		end

		local v153 = v152.friends or {}

		return {
			friends = Cryo.List.filter(v153, function(p25) -- line: 602
				-- upvalues: v90 (copy), p24 (copy)
				return v90.getCachedItem(p25.id).data(p24)
			end),
			hasMore = v152.hasMore,
			nextCursor = v152.nextCursor
		}
	end)
	local v95 = Signals.createComputed(function(p26) -- line: 613
		-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy)
		local v155 = LocalUserIdStore.getCurrentUserId(p26)

		if v155 ~= "" then
		else
			local v156 = getLocalPlayerUserId()

			v155 = not v156 and "" or tostring(v156)
		end

		return v92.getCachedItem(v155).status(p26)
	end)

	return {
		GetOnlineFriends = function() -- line: 559
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v88 (copy), v93 (copy)
			local v144 = LocalUserIdStore.getCurrentUserId(false)

			if v144 ~= "" then
			else
				local v145 = getLocalPlayerUserId()

				v144 = not v145 and "" or tostring(v145)
			end

			v88.getAndFetchItem(v144)

			return v93
		end,
		GetOnlineFriendsByUniverseId = function(s7: string) -- line: 566
			-- upvalues: t7 (copy), Signals (copy), v93 (copy)
			local v147 = t7[s7]

			if v147 then
				return v147
			end

			local v148 = Signals.createComputed(function(p27) -- line: 572
				-- upvalues: v93 (copy), s7 (copy)
				local v230 = v93(p27)

				if not v230 then
					return {}
				end

				local t20 = {}

				for _, v233 in v230 do
					if v233.presence and v233.presence.universeId == s7 then
						table.insert(t20, v233)
					end
				end

				return t20
			end)

			t7[s7] = v148

			return v148
		end,
		GetAllFriends = function() -- line: 618
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy), v94 (copy)
			local v157 = LocalUserIdStore.getCurrentUserId(false)

			if v157 ~= "" then
			else
				local v158 = getLocalPlayerUserId()

				v157 = not v158 and "" or tostring(v158)
			end

			v92.getAndFetchItem(v157)

			return v94
		end,
		GetAllFriendsStatus = function() -- line: 625
			-- upvalues: v95 (copy)
			return v95
		end,
		FetchMoreFriends = function() -- line: 629
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), v92 (copy), DataStatus (copy)
			local v159 = LocalUserIdStore.getCurrentUserId(false)

			if v159 ~= "" then
			else
				local v160 = getLocalPlayerUserId()

				v159 = not v160 and "" or tostring(v160)
			end

			local v161 = v92.getCachedItem(v159)
			local v162 = v161.data(false)

			if v162 == nil or not v162.hasMore or v162.nextCursor == nil then
				return
			end

			if v161.status(false) == DataStatus.NotReady then
				return
			end

			if v92.isRequestInQueueOrInFlight(v159) then
				return
			end

			v92.fetchItem(v159)
		end,
		RefetchAllFriends = function() -- line: 649
			-- upvalues: u77 (ref), v92 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			u77 = true

			local fetchItem = v92.fetchItem
			local v164 = LocalUserIdStore.getCurrentUserId(false)

			if v164 ~= "" then
			else
				local v165 = getLocalPlayerUserId()

				v164 = not v165 and "" or tostring(v165)
			end

			fetchItem(v164)
		end,
		GetIsFriendWith = function(s8: string) -- line: 655
			-- upvalues: v90 (copy)
			return v90.getAndFetchItem(s8)
		end,
		UpdateIsFriendsWith = UpdateIsFriendsWith,
		GetFriendshipStatus = function(s9: string) -- line: 662
			-- upvalues: FFlagSduiRequestFriendshipAction (copy), v91 (copy)
			if not FFlagSduiRequestFriendshipAction or s9 == "" then
				return nil
			end

			return v91.getAndFetchItem(s9)
		end,
		UpdateFriendshipStatus = function(s10: string, p28) -- line: 671
			-- upvalues: FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
			if not FFlagSduiRequestFriendshipAction then
				return
			end

			v81.replaceItem(s10, p28)
			UpdateIsFriendsWith(s10, p28 == Enum.FriendStatus.Friend)
		end,
		RequestFriendship = function(s11: string, s12: string?) -- line: 683
			-- upvalues: Requests (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
			return Requests.RequestFriendshipFromUserId(s11, s12):andThen(function() -- line: 685
				-- upvalues: s11 (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
				local v235 = s11
				local FriendRequestSent = Enum.FriendStatus.FriendRequestSent

				if not FFlagSduiRequestFriendshipAction then
					return
				end

				v81.replaceItem(v235, FriendRequestSent)
				UpdateIsFriendsWith(v235, FriendRequestSent == Enum.FriendStatus.Friend)
			end):catch(function(p29) -- line: 688
				-- upvalues: s11 (copy), FFlagSduiRequestFriendshipAction (copy), v81 (copy), UpdateIsFriendsWith (copy)
				if ((if type(p29) ~= "table" then nil else p29.firstErrorCode)) == 5 then
					local v238 = s11
					local Friend = Enum.FriendStatus.Friend

					if not FFlagSduiRequestFriendshipAction then
						return
					end

					v81.replaceItem(v238, Friend)
					UpdateIsFriendsWith(v238, Friend == Enum.FriendStatus.Friend)

					return
				end

				error(p29)
			end)
		end,
		RefetchOnlineFriends = function() -- line: 704
			-- upvalues: v88 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			local fetchItem = v88.fetchItem
			local v173 = LocalUserIdStore.getCurrentUserId(false)

			if v173 ~= "" then
			else
				local v174 = getLocalPlayerUserId()

				v173 = not v174 and "" or tostring(v174)
			end

			fetchItem(v173)
		end,
		clear = function() -- line: 752
			-- upvalues: v88 (copy), v90 (copy), v92 (copy), FFlagSduiRequestFriendshipAction (copy), v91 (copy), t7 (copy)
			v88.clear()
			v90.clear()
			v92.clear()

			if FFlagSduiRequestFriendshipAction then
				v91.clear()
			end

			table.clear(t7)
		end,
		dispose = function() -- line: 762
			-- upvalues: v88 (copy), v90 (copy), v92 (copy), FFlagSduiRequestFriendshipAction (copy), v91 (copy), t7 (copy)
			v88.dispose()
			v90.dispose()
			v92.dispose()

			if FFlagSduiRequestFriendshipAction then
				v91.dispose()
			end

			table.clear(t7)
		end,
		_fetchOnlineFriendsAsync = function() -- line: 710
			-- upvalues: LocalUserIdStore (copy), getLocalPlayerUserId (copy), Requests (copy), applyGetOnlineFriendsResponseBody (copy), v70 (copy)
			local v175 = LocalUserIdStore.getCurrentUserId(false)

			if v175 ~= "" then
			else
				local v176 = getLocalPlayerUserId()

				v175 = not v176 and "" or tostring(v176)
			end

			local v177 = v175

			return Requests.GetOnlineFriends(v177):andThen(function(p30) -- line: 713
				-- upvalues: applyGetOnlineFriendsResponseBody (copy), v70 (copy), v177 (copy)
				local v241 = applyGetOnlineFriendsResponseBody(p30)

				v70.replaceItems({
					[v177] = v241
				})

				return p30 or {
					data = nil
				}
			end):catch(function(p31) -- line: 718
				error(p31)
			end)
		end,
		_updateFriendsPresences = function(t21: {[any]: any}?, t22: {[any]: any}?, _: string?) -- line: 723
			-- upvalues: normalizeStoredOnlineFriendRow (copy), normalizePresenceRawData (copy), v66 (copy), v73 (copy), appendUserToAllFriends (copy), v70 (copy), LocalUserIdStore (copy), getLocalPlayerUserId (copy)
			if not t21 then
				return
			end

			local v181 = t22 or {}
			local t23 = {}

			for _, v in pairs(t21) do
				local userId = v.userId
				local v186 = if userId then tostring(userId) else nil

				if v186 then
					local v187 = normalizeStoredOnlineFriendRow({
						id = v186,
						sortScore = v181[v186]
					})
					local v188 = normalizePresenceRawData(v)

					t23[v186] = v187
					v66.UpdateUserPresence(v186, v188, {
						isUpdatedRealtime = true
					})
					v73.replaceItem(v186, true)
					appendUserToAllFriends(v186)
				end
			end

			local updateItem = v70.updateItem
			local v190 = LocalUserIdStore.getCurrentUserId(false)

			if v190 ~= "" then
			else
				local v191 = getLocalPlayerUserId()

				v190 = not v191 and "" or tostring(v191)
			end

			updateItem(v190, t23)
		end
	}
end

return createFriendsStore
