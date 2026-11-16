local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/Cryo")

local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloClient")
local useQuery = ApolloClient.useQuery
local useApolloClient = ApolloClient.useApolloClient

local queries = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloLocalState").queries

local ApolloFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloFriends")
local ApolloPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloPresence")

local presenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/GraphQLServer").types.PresenceType

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SignalsReact").useSignalState
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/DataHydration")

local friendsCommonPresenceUpdateSignal = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCommon/FriendsCommon/Signals").FriendsCommonPresenceUpdateSignal

local defineFastInt = game:DefineFastInt("FriendsListDefaultPageSize", 12)

local fFlagFriendSortedByPresenceSignalsImplementation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SharedFlags").FFlagFriendSortedByPresenceSignalsImplementation

local usePresenceImpressionEvents = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCommon/FriendsCommon/Hooks/usePresenceImpressionEvents")

local defineFastFlag = game:DefineFastFlag(
	"UseFriendsListOrderedByIdPresenceImpressionEventsEnabled",
	false
)

local defineFastFlag2 = game:DefineFastFlag("FriendsListStableEmptyOnlineFriends", false)

local v5 = DataHydration.Friends.FriendsStore.get()

local frozen = table.freeze({})

local function fn(mapped, friends)
	local presencesById = {}

	for k, item in mapped do
		presencesById[item.id] = item.presence
	end

	local filtered = Cryo.List.filter(friends or {}, function(p2): boolean
		return not presencesById[p2.id]
	end)

	return Cryo.List.sort(mapped, function(p2, p3): boolean
		return p2.sortScore > p3.sortScore
	end), filtered
end

local function shouldRefetchOnlineFriends(object, p2, p3): boolean
	local query = object:readQuery({
		query = queries.onlineFriendsByUserId,
		variables = p2
	})

	local presencesById = {}

	for k, v6 in not query and {} or query.onlineFriendsByUserId or {} do
		presencesById[v6.id] = v6.presence
	end

	return #Cryo.List.filter(p3, function(p4): boolean
		return ApolloPresence.Formatters.formatNumberToPresenceType(p4.userPresenceType) ~= presenceType.Offline
			and not presencesById[tostring(p4.userId)]
	end) > 0
end

local function bulkUpdateUserPresences(p2, items)
	for k, item in items do
		ApolloPresence.Mutations.createUserPresenceCache(p2, {
			id = item.userId,
			userPresenceNumber = item.userPresenceType,
			lastLocation = item.lastLocation,
			lastOnline = item.lastOnline,
			gameId = item.gameId,
			placeId = item.placeId,
			rootPlaceId = item.rootPlaceId,
			universeId = item.universeId
		})
	end
end

local function useFriendsListOrderedByPresence(p2)
	local v6 = if not fFlagFriendSortedByPresenceSignalsImplementation then useApolloClient() else nil
	local v7

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v7 = React.useMemo(function()
			return v5.GetOnlineFriends()
		end, {})
	end

	local v8 = if fFlagFriendSortedByPresenceSignalsImplementation then useSignalState(v7) else nil

	local pageSize = p2.pageSize or defineFastInt
	local v9

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v9 = React.useMemo(function()
			return v5.GetAllFriends()
		end, {})
	end

	local v10 = if fFlagFriendSortedByPresenceSignalsImplementation then useSignalState(v9) else nil
	local v11

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v11 = React.useMemo(function()
			return v5.GetAllFriendsStatus()
		end, {})
	end

	local v12 = if fFlagFriendSortedByPresenceSignalsImplementation then useSignalState(v11) else nil

	local v13 = { userId = p2.userId, sort = ApolloFriends.Enums.Sort.FriendshipScore }

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v14

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v14 = nil
	else
		v14 = useQuery(queries.allFriendsByUserId, {
			errorPolicy = "all",
			skip = false,
			notifyOnNetworkStatusChange = true,
			variables = Cryo.Dictionary.join(v13, {
				pageLimit = pageSize,
				pageCursor = ""
			})
		})
	end

	local v15

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v15 = nil
	else
		v15 = useQuery(queries.onlineFriendsByUserId, {
			skip = false,
			notifyOnNetworkStatusChange = true,
			variables = v13
		})
	end

	local nextCursor

	if fFlagFriendSortedByPresenceSignalsImplementation then
		nextCursor = if v10 then v10.nextCursor or nil else nil
	else
		nextCursor = if v14.data then v14.data.allFriendsByUserId.nextCursor else nil
	end

	local friends

	if fFlagFriendSortedByPresenceSignalsImplementation then
		friends = if v10 then v10.friends or nil else nil
	else
		friends = if v14.data then v14.data.allFriendsByUserId.friends else nil
	end

	local hasMore

	if fFlagFriendSortedByPresenceSignalsImplementation and v10 then
		hasMore = v10.hasMore or nil
	else
		hasMore = nil
	end

	local v16

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v16 = v8 or not defineFastFlag2 and {} or frozen
	else
		v16 = v15.data and v15.data.onlineFriendsByUserId or {}
	end

	local useCallback = React.useCallback
	local function fn2()
		if fFlagFriendSortedByPresenceSignalsImplementation then
			if not hasMore then
				return
			end
		elseif not nextCursor or nextCursor == "" or v14.loading then
			return
		end

		if fFlagFriendSortedByPresenceSignalsImplementation then
			v5.FetchMoreFriends()
			return
		end

		v14:fetchMore({
			variables = { pageCursor = nextCursor, pageLimit = pageSize }
		}):andThen(function(p3)
			ref2.current = p3 and p3.errors
		end)

		ref.current = nextCursor
	end

	local v18 = if not fFlagFriendSortedByPresenceSignalsImplementation then nextCursor else nil
	local loading = if not fFlagFriendSortedByPresenceSignalsImplementation then v14.loading else nil
	local v20 = useCallback(fn2, {
		v18,
		loading,
		if fFlagFriendSortedByPresenceSignalsImplementation then hasMore else nil
	})

	local function fn3()
		if fFlagFriendSortedByPresenceSignalsImplementation then
			v5.RefetchOnlineFriends()
			v5.RefetchAllFriends()
		else
			v15:refetch()
			v14:refetch()
			ref.current = nil
			ref2.current = nil
		end
	end

	if not fFlagFriendSortedByPresenceSignalsImplementation then
		React.useEffect(function()
			friendsCommonPresenceUpdateSignal.Event:Connect(function(p3)
				bulkUpdateUserPresences(v6, p3)

				if shouldRefetchOnlineFriends(v6, v13, p3) then
					if fFlagFriendSortedByPresenceSignalsImplementation then
						v5._fetchOnlineFriendsAsync()
					else
						v15:refetch()
					end
				end
			end)

			return function()
				friendsCommonPresenceUpdateSignal:Destroy()
			end
		end, {})
	end

	local v21, v22 = React.useMemo(function()
		return fn(Cryo.List.map(v16, function(p3)
			if
				not p3.presence
				or p3.presence.userPresenceType ~= presenceType.InGame
				or p3.presence.universeId ~= ""
			then
				return p3
			end

			local joined = Cryo.Dictionary.join(p3.presence, {
				userPresenceType = presenceType.Online
			})
			return Cryo.Dictionary.join(p3, { presence = joined })
		end), friends)
	end, { v16, friends })

	if defineFastFlag then
		usePresenceImpressionEvents(v16)
	end

	local v23 = not nextCursor or nextCursor == ""
	local v24

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v24 = v10 == nil and v12 == DataHydration.DataStatus.NotReady
	else
		v24 = v14.loading
	end

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v23 = not hasMore
	end

	return {
		onlineFriends = v21,
		offlineFriends = v22,
		fetchMoreFriends = v20,
		refreshFriendsData = fn3,
		isEndOfList = v23,
		isLoading = v24
	}
end

return useFriendsListOrderedByPresence
