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
local FFlagFriendSortedByPresenceSignalsImplementation = require(FriendsCommonParent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation
local usePresenceImpressionEvents = require(script.Parent.usePresenceImpressionEvents)
local v18 = game:DefineFastFlag("UseFriendsListOrderedByIdPresenceImpressionEventsEnabled", false)
local v19 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Friends.FriendsStore.get()

local function v20(t1: {[any]: any}, t2: {[any]: any}) -- line: 64
	-- upvalues: Cryo (copy)
	local t3 = {}

	for _, v29 in t1 do
		t3[v29.id] = v29.presence
	end

	local v30 = Cryo.List.filter(t2 or {}, function(p1) -- line: 74
		-- upvalues: t3 (copy)
		return not t3[p1.id]
	end)

	return Cryo.List.sort(t1, function(p2, p3) -- line: 81
		return p2.sortScore > p3.sortScore
	end), v30
end
local function shouldRefetchOnlineFriends(p4, p5, p6) -- line: 90
	-- upvalues: queries (copy), Cryo (copy), ApolloPresence (copy), PresenceType (copy)
	local v34 = p4:readQuery({
		query = queries.onlineFriendsByUserId,
		variables = p5
	})
	local t4 = {}

	for _, v37 in ((if not v34 then {} else v34.onlineFriendsByUserId)) or {} do
		t4[v37.id] = v37.presence
	end

	return #Cryo.List.filter(p6, function(p7) -- line: 103
		-- upvalues: ApolloPresence (copy), PresenceType (copy), t4 (copy)
		return ApolloPresence.Formatters.formatNumberToPresenceType(p7.userPresenceType) ~= PresenceType.Offline and not t4[tostring(p7.userId)]
	end) > 0
end
local function bulkUpdateUserPresences(p8, p9) -- line: 111
	-- upvalues: ApolloPresence (copy)
	for _, v41 in p9 do
		ApolloPresence.Mutations.createUserPresenceCache(p8, {
			id = v41.userId,
			userPresenceNumber = v41.userPresenceType,
			lastLocation = v41.lastLocation,
			lastOnline = v41.lastOnline,
			gameId = v41.gameId,
			placeId = v41.placeId,
			rootPlaceId = v41.rootPlaceId,
			universeId = v41.universeId
		})
	end
end
local function useFriendsListOrderedByPresence(t5: {[any]: any}) -- line: 126
	-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), useApolloClient (copy), React (copy), v19 (copy), useSignalState (copy), v15 (copy), ApolloFriends (copy), useQuery (copy), queries (copy), Cryo (copy), FriendsCommonPresenceUpdateSignal (copy), bulkUpdateUserPresences (copy), shouldRefetchOnlineFriends (copy), v20 (copy), PresenceType (copy), v18 (copy), usePresenceImpressionEvents (copy), DataHydration (copy)
	local v43 = if not FFlagFriendSortedByPresenceSignalsImplementation then useApolloClient() else nil
	local v44 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else React.useMemo(function() -- line: 137
		-- upvalues: v19 (copy)
		return v19.GetOnlineFriends()
	end, {})
	local v45 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else useSignalState(v44)
	local v46 = t5.pageSize or v15
	local v47 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else React.useMemo(function() -- line: 149
		-- upvalues: v19 (copy)
		return v19.GetAllFriends()
	end, {})
	local v48 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else useSignalState(v47)
	local v49 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else React.useMemo(function() -- line: 159
		-- upvalues: v19 (copy)
		return v19.GetAllFriendsStatus()
	end, {})
	local v50 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else useSignalState(v49)
	local t6 = {
		userId = t5.userId,
		sort = ApolloFriends.Enums.Sort.FriendshipScore
	}
	local v52 = React.useRef(nil)
	local v53 = React.useRef(nil)
	local v54 = if not FFlagFriendSortedByPresenceSignalsImplementation then useQuery(queries.allFriendsByUserId, {
		errorPolicy = "all",
		skip = false,
		notifyOnNetworkStatusChange = true,
		variables = Cryo.Dictionary.join(t6, {
			pageCursor = "",
			pageLimit = v46
		})
	}) else nil
	local v55 = if not FFlagFriendSortedByPresenceSignalsImplementation then useQuery(queries.onlineFriendsByUserId, {
		skip = false,
		notifyOnNetworkStatusChange = true,
		variables = t6
	}) else nil
	local v56 = if not FFlagFriendSortedByPresenceSignalsImplementation then if not v54.data then nil else v54.data.allFriendsByUserId.nextCursor else v48 and v48.nextCursor or nil
	local v57 = if not FFlagFriendSortedByPresenceSignalsImplementation then if not v54.data then nil else v54.data.allFriendsByUserId.friends else v48 and v48.friends or nil
	local v58 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else v48 and v48.hasMore or nil
	local v59 = if not FFlagFriendSortedByPresenceSignalsImplementation then v55.data and v55.data.onlineFriendsByUserId or {} else v45 or {}
	local v60 = React.useCallback(function() -- line: 210
		-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), v58 (copy), v56 (copy), v54 (copy), v19 (copy), v46 (copy), v53 (copy), v52 (copy)
		if FFlagFriendSortedByPresenceSignalsImplementation then
			if not v58 then
				return
			end
		elseif not v56 or v56 == "" or v54.loading then
			return
		end

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v19.FetchMoreFriends()

			return
		end

		v54:fetchMore({
			variables = {
				pageCursor = v56,
				pageLimit = v46
			}
		}):andThen(function(p10) -- line: 233
			-- upvalues: v53 (copy)
			v53.current = p10 and p10.errors
		end)
		v52.current = v56
	end, {
		if not FFlagFriendSortedByPresenceSignalsImplementation then v56 else nil,
		if not FFlagFriendSortedByPresenceSignalsImplementation then v54.loading else nil,
		if not FFlagFriendSortedByPresenceSignalsImplementation then nil else v58
	})

	if not FFlagFriendSortedByPresenceSignalsImplementation then
		React.useEffect(function() -- line: 258
			-- upvalues: FriendsCommonPresenceUpdateSignal (copy), bulkUpdateUserPresences (copy), v43 (copy), shouldRefetchOnlineFriends (copy), t6 (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), v19 (copy), v55 (copy)
			FriendsCommonPresenceUpdateSignal.Event:Connect(function(p11) -- line: 259
				-- upvalues: bulkUpdateUserPresences (copy), v43 (copy), shouldRefetchOnlineFriends (copy), t6 (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), v19 (copy), v55 (copy)
				bulkUpdateUserPresences(v43, p11)

				if shouldRefetchOnlineFriends(v43, t6, p11) then
					if FFlagFriendSortedByPresenceSignalsImplementation then
						v19._fetchOnlineFriendsAsync()

						return
					end

					v55:refetch()
				end
			end)

			return function() -- line: 270
				-- upvalues: FriendsCommonPresenceUpdateSignal (copy)
				FriendsCommonPresenceUpdateSignal:Destroy()
			end
		end, {})
	end

	local v61, v62 = React.useMemo(function() -- line: 276
		-- upvalues: v20 (copy), v59 (copy), Cryo (copy), PresenceType (copy), v57 (copy)
		local v71 = v20
		local v72 = v59

		return v71(Cryo.List.map(v72, function(p12) -- line: 51
			-- upvalues: PresenceType (copy), Cryo (copy)
			if p12.presence and (p12.presence.userPresenceType == PresenceType.InGame and p12.presence.universeId == "") then
				local v76 = Cryo.Dictionary.join(p12.presence, {
					userPresenceType = PresenceType.Online
				})

				return Cryo.Dictionary.join(p12, {
					presence = v76
				})
			end

			return p12
		end), v57)
	end, {
		v59,
		v57
	})

	if v18 then
		usePresenceImpressionEvents(v59)
	end

	local v63 = not v56 or v56 == ""
	local v64 = if not FFlagFriendSortedByPresenceSignalsImplementation then v54.loading else v48 == nil and v50 == DataHydration.DataStatus.NotReady

	return {
		onlineFriends = v61,
		offlineFriends = v62,
		fetchMoreFriends = v60,
		refreshFriendsData = function() -- line: 245
			-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), v19 (copy), v55 (copy), v54 (copy), v52 (copy), v53 (copy)
			if FFlagFriendSortedByPresenceSignalsImplementation then
				v19.RefetchOnlineFriends()
				v19.RefetchAllFriends()

				return
			end

			v55:refetch()
			v54:refetch()
			v52.current = nil
			v53.current = nil
		end,
		isEndOfList = if not FFlagFriendSortedByPresenceSignalsImplementation then v63 else not v58,
		isLoading = v64
	}
end

return useFriendsListOrderedByPresence
