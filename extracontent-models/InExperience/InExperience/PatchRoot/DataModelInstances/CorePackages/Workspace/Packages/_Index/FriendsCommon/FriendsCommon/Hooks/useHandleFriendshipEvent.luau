local FriendsCommon = script:FindFirstAncestor("FriendsCommon")
local parent = FriendsCommon.Parent

local React = require(parent.React)

local ApolloFriends = require(parent.ApolloFriends)

local ApolloLocalState = require(parent.ApolloLocalState)
local queries = ApolloLocalState.queries

local SocialCommon = require(parent.SocialCommon)
local userIdExists = SocialCommon.Utils.userIdExists

local ApolloClient = require(parent.ApolloClient)
local useQuery = ApolloClient.useQuery
local useApolloClient = ApolloClient.useApolloClient

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local handleFriendshipEvent = require(FriendsCommon.EventHandlers.handleFriendshipEvent)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation

local function useHandleFriendshipEvent()
	local v = useLocalUserId()
	local v2

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v2 = nil
	else
		v2 = useApolloClient()
	end

	local v3

	if FFlagFriendSortedByPresenceSignalsImplementation then
		v3 = nil
	else
		v3 = useQuery(queries.onlineFriendsByUserId, {
			skip = not userIdExists(v),
			notifyOnNetworkStatusChange = true,
			variables = { userId = v, sort = ApolloFriends.Enums.Sort.FriendshipScore }
		})
	end

	local useCallback = React.useCallback
	local function fn(friendshipUpdate)
		local v4 = {
			localUserId = v,
			onlineFriendsRef = nil,
			apolloClient = nil,
			friendshipUpdate = nil
		}
		local onlineFriendsRef

		if not FFlagFriendSortedByPresenceSignalsImplementation then
			onlineFriendsRef = v3
		end

		v4.onlineFriendsRef = onlineFriendsRef
		local apolloClient

		if not FFlagFriendSortedByPresenceSignalsImplementation then
			apolloClient = v2
		end

		v4.apolloClient = apolloClient
		v4.friendshipUpdate = friendshipUpdate
		handleFriendshipEvent(v4)
	end

	local v4

	if not FFlagFriendSortedByPresenceSignalsImplementation then
		v4 = v3
	end

	return (useCallback(fn, { v4 }))
end

return useHandleFriendshipEvent
