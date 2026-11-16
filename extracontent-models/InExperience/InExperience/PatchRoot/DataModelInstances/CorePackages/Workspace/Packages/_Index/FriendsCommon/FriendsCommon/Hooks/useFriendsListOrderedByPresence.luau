local FriendsCommon = script:FindFirstAncestor("FriendsCommon")
local parent = FriendsCommon.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local ApolloClient = require(parent.ApolloClient)
local useQuery = ApolloClient.useQuery
local useApolloClient = ApolloClient.useApolloClient

local ApolloLocalState = require(parent.ApolloLocalState)
local queries = ApolloLocalState.queries

local ApolloFriends = require(parent.ApolloFriends)
local ApolloPresence = require(parent.ApolloPresence)

local GraphQLServer = require(parent.GraphQLServer)

local presenceType = GraphQLServer.types.PresenceType

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local DataHydration = require(parent.DataHydration)

local Signals = require(FriendsCommon.Signals)
local FriendsCommonPresenceUpdateSignal = Signals.FriendsCommonPresenceUpdateSignal

local defineFastInt = game:DefineFastInt("FriendsListDefaultPageSize", 12)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation

local usePresenceImpressionEvents = require(script.Parent.usePresenceImpressionEvents)

local defineFastFlag = game:DefineFastFlag("UseFriendsListOrderedByIdPresenceImpressionEventsEnabled", false)

local defineFastFlag2 = game:DefineFastFlag("FriendsListStableEmptyOnlineFriends", false)

local v = DataHydration.Friends.FriendsStore.get()

local frozen = table.freeze({})

local function fn(mapped, friends)
	local presencesById = {}

	for _, item in mapped do
		presencesById[item.id] = item.presence
	end

	local filtered = Cryo.List.filter(friends or {}, function(p): boolean
		return not presencesById[p.id]
	end)

	return Cryo.List.sort(mapped, function(p, p2): boolean
		return p.sortScore > p2.sortScore
	end), filtered
end

local function shouldRefetchOnlineFriends(object, variables, p): boolean
	local query = object:readQuery({ query = queries.onlineFriendsByUserId, variables = variables })

	local presencesById = {}

	for _, v2 in not query and {} or query.onlineFriendsByUserId or {} do
		presencesById[v2.id] = v2.presence
	end

	return #Cryo.List.filter(p, function(p2): boolean
		return ApolloPresence.Formatters.formatNumberToPresenceType(p2.userPresenceType) ~= presenceType.Offline
			and not presencesById[tostring(p2.userId)]
	end) > 0
end

local function bulkUpdateUserPresences(p, items)
	for _, item in items do
		ApolloPresence.Mutations.createUserPresenceCache(p, {
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

local function useFriendsListOrderedByPresence(p)
	local v2

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v2 = nil
	else
		v2 = useApolloClient()
	end

	local v3

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v3 = React.useMemo(function()
			return v.GetOnlineFriends()
		end, {})
	end

	local v4

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v4 = useSignalState(v3)
	end

	local pageSize = p.pageSize or defineFastInt
	local v5

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v5 = React.useMemo(function()
			return v.GetAllFriends()
		end, {})
	end

	local v6

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v6 = useSignalState(v5)
	end

	local v7

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v7 = React.useMemo(function()
			return v.GetAllFriendsStatus()
		end, {})
	end

	local v8

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v8 = useSignalState(v7)
	end

	local variables = { userId = p.userId, sort = ApolloFriends.Enums.Sort.FriendshipScore }

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v9

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v9 = nil
	else
		v9 = useQuery(queries.allFriendsByUserId, {
			errorPolicy = "all",
			skip = false,
			notifyOnNetworkStatusChange = true,
			variables = Cryo.Dictionary.join(variables, { pageLimit = pageSize, pageCursor = "" })
		})
	end

	local v10

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v10 = nil
	else
		v10 = useQuery(queries.onlineFriendsByUserId, {
			skip = false,
			notifyOnNetworkStatusChange = true,
			variables = variables
		})
	end

	local nextCursor

	if FFlagFriendSortedByPresenceSignalsImplementation then
		if v6 then
			nextCursor = v6.nextCursor or nil
		else
			nextCursor = nil
		end
	elseif v9.data then
		nextCursor = v9.data.allFriendsByUserId.nextCursor
	else
		nextCursor = nil
	end

	local friends

	if FFlagFriendSortedByPresenceSignalsImplementation then
		if v6 then
			friends = v6.friends or nil
		else
			friends = nil
		end
	elseif v9.data then
		friends = v9.data.allFriendsByUserId.friends
	else
		friends = nil
	end

	local hasMore

	if FFlagFriendSortedByPresenceSignalsImplementation and v6 then
		hasMore = v6.hasMore or nil
	else
		hasMore = nil
	end

	local v11

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v11 = v4 or not defineFastFlag2 and {} or frozen
	else
		v11 = v10.data and v10.data.onlineFriendsByUserId or {}
	end

	local useCallback = React.useCallback
	local function fn2()
		if FFlagFriendSortedByPresenceSignalsImplementation then
			if not hasMore then
				return
			end
		elseif not nextCursor or nextCursor == "" or v9.loading then
			return
		end

		if FFlagFriendSortedByPresenceSignalsImplementation then
			v.FetchMoreFriends()
			return
		end

		v9:fetchMore({
			variables = { pageCursor = nextCursor, pageLimit = pageSize }
		}):andThen(function(p2)
			ref2.current = p2 and p2.errors
		end)

		ref.current = nextCursor
	end

	local v12

	if not FFlagFriendSortedByPresenceSignalsImplementation then
		v12 = nextCursor
	end

	local loading

	if not FFlagFriendSortedByPresenceSignalsImplementation then
		loading = v9.loading
	end

	local v13

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v13 = hasMore
	end

	local fetchMoreFriends = useCallback(fn2, { v12, loading, v13 })

	local function fn3()
		if FFlagFriendSortedByPresenceSignalsImplementation then
			v.RefetchOnlineFriends()
			v.RefetchAllFriends()
		else
			v10:refetch()
			v9:refetch()
			ref.current = nil
			ref2.current = nil
		end
	end

	if not FFlagFriendSortedByPresenceSignalsImplementation then
		React.useEffect(function()
			FriendsCommonPresenceUpdateSignal.Event:Connect(function(p2)
				bulkUpdateUserPresences(v2, p2)

				if shouldRefetchOnlineFriends(v2, variables, p2) then
					if FFlagFriendSortedByPresenceSignalsImplementation then
						v._fetchOnlineFriendsAsync()
					else
						v10:refetch()
					end
				end
			end)

			return function()
				FriendsCommonPresenceUpdateSignal:Destroy()
			end
		end, {})
	end

	local onlineFriends, offlineFriends = React.useMemo(function()
		return fn(Cryo.List.map(v11, function(p2)
			if
				not p2.presence
				or p2.presence.userPresenceType ~= presenceType.InGame
				or p2.presence.universeId ~= ""
			then
				return p2
			end

			local joined = Cryo.Dictionary.join(p2.presence, {
				userPresenceType = presenceType.Online
			})
			return Cryo.Dictionary.join(p2, { presence = joined })
		end), friends)
	end, { v11, friends })

	if defineFastFlag then
		usePresenceImpressionEvents(v11)
	end

	local isEndOfList = not nextCursor or nextCursor == ""
	local isLoading

	if FFlagFriendSortedByPresenceSignalsImplementation then
		if v6 == nil then
			isLoading = v8 == DataHydration.DataStatus.NotReady
		else
			isLoading = false
		end
	else
		isLoading = v9.loading
	end

	if FFlagFriendSortedByPresenceSignalsImplementation then
		isEndOfList = not hasMore
	end

	return {
		onlineFriends = onlineFriends,
		offlineFriends = offlineFriends,
		fetchMoreFriends = fetchMoreFriends,
		refreshFriendsData = fn3,
		isEndOfList = isEndOfList,
		isLoading = isLoading
	}
end

return useFriendsListOrderedByPresence
