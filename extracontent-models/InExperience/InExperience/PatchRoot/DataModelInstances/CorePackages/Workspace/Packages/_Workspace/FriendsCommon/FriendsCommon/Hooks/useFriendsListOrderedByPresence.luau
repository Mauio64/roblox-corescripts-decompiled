local FriendsCommon = script:FindFirstAncestor("FriendsCommon")
local FriendsCommonParent = FriendsCommon.Parent
local React = require(FriendsCommonParent.React)
local Cryo = require(FriendsCommonParent.Cryo)
local ApolloClient = require(FriendsCommonParent.ApolloClient)
local useQuery = ApolloClient.useQuery
local useApolloClient = ApolloClient.useApolloClient
local queries = require(FriendsCommonParent.ApolloLocalState).queries
local ApolloFriends = require(FriendsCommonParent.ApolloFriends)
local ApolloPresence = require(FriendsCommonParent.ApolloPresence)
local PresenceType = require(FriendsCommonParent.GraphQLServer).types.PresenceType
local useSignalState = require(FriendsCommonParent.SignalsReact).useSignalState
local DataHydration = require(FriendsCommonParent.DataHydration)
local FriendsCommonPresenceUpdateSignal = require(FriendsCommon.Signals).FriendsCommonPresenceUpdateSignal
local v15 = game:DefineFastInt("FriendsListDefaultPageSize", 12)
local SharedFlags = require(FriendsCommonParent.SharedFlags)
local FFlagEnableUseSortScoresForFriendsCarouselLoad = SharedFlags.FFlagEnableUseSortScoresForFriendsCarouselLoad
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local usePresenceImpressionEvents = require(script.Parent.usePresenceImpressionEvents)
local v20 = game:DefineFastFlag("UseFriendsListOrderedByIdPresenceImpressionEventsEnabled", false)
local v21 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Friends.FriendsStore.get()

local function v22(t1: {[any]: any}, t2: {[any]: any}) -- line: 65
	-- upvalues: Cryo (copy), FFlagEnableUseSortScoresForFriendsCarouselLoad (copy), PresenceType (copy)
	local t3 = {}

	for _, v31 in t1 do
		t3[v31.id] = v31.presence
	end

	local v32 = Cryo.List.filter(t2 or {}, function(p1) -- line: 75
		-- upvalues: t3 (copy)
		return not t3[p1.id]
	end)
	local v33

	if FFlagEnableUseSortScoresForFriendsCarouselLoad then
		v33 = Cryo.List.sort(t1, function(p2, p3) -- line: 83
			return p2.sortScore > p3.sortScore
		end)
	else
		local t4 = {}
		local t5 = {}
		local t6 = {}

		for _, v38 in t1 do
			local v39 = if not v38.presence then PresenceType.Offline else v38.presence.userPresenceType

			if v39 == PresenceType.InGame then
				table.insert(t4, v38)
			elseif v39 == PresenceType.InStudio then
				table.insert(t5, v38)
			else
				table.insert(t6, v38)
			end
		end

		v33 = Cryo.List.join(t4, t6, t5)
	end

	return v33, v32
end
local function shouldRefetchOnlineFriends(p4, p5, p6) -- line: 108
	-- upvalues: queries (copy), Cryo (copy), ApolloPresence (copy), PresenceType (copy)
	local v43 = p4:readQuery({
		query = queries.onlineFriendsByUserId,
		variables = p5
	})
	local t7 = {}

	for _, v46 in ((if not v43 then {} else v43.onlineFriendsByUserId)) or {} do
		t7[v46.id] = v46.presence
	end

	return #Cryo.List.filter(p6, function(p7) -- line: 121
		-- upvalues: ApolloPresence (copy), PresenceType (copy), t7 (copy)
		return ApolloPresence.Formatters.formatNumberToPresenceType(p7.userPresenceType) ~= PresenceType.Offline and not t7[tostring(p7.userId)]
	end) > 0
end
local function bulkUpdateUserPresences(p8, p9) -- line: 129
	-- upvalues: ApolloPresence (copy)
	for _, v50 in p9 do
		ApolloPresence.Mutations.createUserPresenceCache(p8, {
			id = v50.userId,
			userPresenceNumber = v50.userPresenceType,
			lastLocation = v50.lastLocation,
			lastOnline = v50.lastOnline,
			gameId = v50.gameId,
			placeId = v50.placeId,
			rootPlaceId = v50.rootPlaceId,
			universeId = v50.universeId
		})
	end
end
local function useFriendsListOrderedByPresence(t8: {[any]: any}) -- line: 144
	-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), useApolloClient (copy), React (copy), v21 (copy), useSignalState (copy), v15 (copy), ApolloFriends (copy), useQuery (copy), queries (copy), Cryo (copy), FriendsCommonPresenceUpdateSignal (copy), bulkUpdateUserPresences (copy), shouldRefetchOnlineFriends (copy), v22 (copy), PresenceType (copy), v20 (copy), usePresenceImpressionEvents (copy), DataHydration (copy)
	local v52 = if not FFlagFriendSortedByPresenceSignalsImplementation then useApolloClient() else nil
	local v53 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else React.useMemo(function() -- line: 155
		-- upvalues: v21 (copy)
		return v21.GetOnlineFriends()
	end, {})
	local v54 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else useSignalState(v53)
	local v55 = t8.pageSize or v15
	local v56 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else React.useMemo(function() -- line: 167
		-- upvalues: v21 (copy)
		return v21.GetAllFriends()
	end, {})
	local v57 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else useSignalState(v56)
	local v58 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else React.useMemo(function() -- line: 177
		-- upvalues: v21 (copy)
		return v21.GetAllFriendsStatus()
	end, {})
	local v59 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else useSignalState(v58)
	local t9 = {
		userId = t8.userId,
		sort = ApolloFriends.Enums.Sort.FriendshipScore
	}
	local v61 = React.useRef(nil)
	local v62 = React.useRef(nil)
	local v63 = if not FFlagFriendSortedByPresenceSignalsImplementation then useQuery(queries.allFriendsByUserId, {
		errorPolicy = "all",
		skip = false,
		notifyOnNetworkStatusChange = true,
		variables = Cryo.Dictionary.join(t9, {
			pageCursor = "",
			pageLimit = v55
		})
	}) else nil
	local v64 = if not FFlagFriendSortedByPresenceSignalsImplementation then useQuery(queries.onlineFriendsByUserId, {
		skip = false,
		notifyOnNetworkStatusChange = true,
		variables = t9
	}) else nil
	local v65 = if not FFlagFriendSortedByPresenceSignalsImplementation then if not v63.data then nil else v63.data.allFriendsByUserId.nextCursor else v57 and v57.nextCursor or nil
	local v66 = if not FFlagFriendSortedByPresenceSignalsImplementation then if not v63.data then nil else v63.data.allFriendsByUserId.friends else v57 and v57.friends or nil
	local v67 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else v57 and v57.hasMore or nil
	local v68 = if not FFlagFriendSortedByPresenceSignalsImplementation then v64.data and v64.data.onlineFriendsByUserId or {} else v54 or {}
	local v69 = React.useCallback(function() -- line: 228
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), v67 (copy), v65 (copy), v63 (copy), v21 (copy), v55 (copy), v62 (copy), v61 (copy)
		if FFlagFriendSortedByPresenceSignalsImplementation then
			if not v67 then
				return
			end
		elseif not v65 or v65 == "" or v63.loading then
			return
		end

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v21.FetchMoreFriends()

			return
		end

		v63:fetchMore({
			variables = {
				pageCursor = v65,
				pageLimit = v55
			}
		}):andThen(function(p10) -- line: 251
			-- upvalues: v62 (copy)
			v62.current = p10 and p10.errors
		end)
		v61.current = v65
	end, {
		if not FFlagFriendSortedByPresenceSignalsImplementation then v65 else nil,
		if not FFlagFriendSortedByPresenceSignalsImplementation then v63.loading else nil,
		if not FFlagFriendSortedByPresenceSignalsImplementation then nil else v67
	})

	if not FFlagFriendSortedByPresenceSignalsImplementation then
		React.useEffect(function() -- line: 276
			-- upvalues: FriendsCommonPresenceUpdateSignal (copy), bulkUpdateUserPresences (copy), v52 (copy), shouldRefetchOnlineFriends (copy), t9 (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), v21 (copy), v64 (copy)
			FriendsCommonPresenceUpdateSignal.Event:Connect(function(p11) -- line: 277
				-- upvalues: bulkUpdateUserPresences (copy), v52 (copy), shouldRefetchOnlineFriends (copy), t9 (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), v21 (copy), v64 (copy)
				bulkUpdateUserPresences(v52, p11)

				if shouldRefetchOnlineFriends(v52, t9, p11) then
					if FFlagFriendSortedByPresenceSignalsImplementation then
						v21._fetchOnlineFriendsAsync()

						return
					end

					v64:refetch()
				end
			end)

			return function() -- line: 288
				-- upvalues: FriendsCommonPresenceUpdateSignal (copy)
				FriendsCommonPresenceUpdateSignal:Destroy()
			end
		end, {})
	end

	local v70, v71 = React.useMemo(function() -- line: 294
		-- upvalues: v22 (copy), v68 (copy), Cryo (copy), PresenceType (copy), v66 (copy)
		local v80 = v22
		local v81 = v68

		return v80(Cryo.List.map(v81, function(p12) -- line: 52
			-- upvalues: PresenceType (copy), Cryo (copy)
			if p12.presence and (p12.presence.userPresenceType == PresenceType.InGame and p12.presence.universeId == "") then
				local v85 = Cryo.Dictionary.join(p12.presence, {
					userPresenceType = PresenceType.Online
				})

				return Cryo.Dictionary.join(p12, {
					presence = v85
				})
			end

			return p12
		end), v66)
	end, {
		v68,
		v66
	})

	if v20 then
		usePresenceImpressionEvents(v68)
	end

	local v72 = not v65 or v65 == ""
	local v73 = if not FFlagFriendSortedByPresenceSignalsImplementation then v63.loading else v57 == nil and v59 == DataHydration.DataStatus.NotReady

	return {
		onlineFriends = v70,
		offlineFriends = v71,
		fetchMoreFriends = v69,
		refreshFriendsData = function() -- line: 263
			-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), v21 (copy), v64 (copy), v63 (copy), v61 (copy), v62 (copy)
			if FFlagFriendSortedByPresenceSignalsImplementation then
				v21.RefetchOnlineFriends()
				v21.RefetchAllFriends()

				return
			end

			v64:refetch()
			v63:refetch()
			v61.current = nil
			v62.current = nil
		end,
		isEndOfList = if not FFlagFriendSortedByPresenceSignalsImplementation then v72 else not v67,
		isLoading = v73
	}
end

return useFriendsListOrderedByPresence
