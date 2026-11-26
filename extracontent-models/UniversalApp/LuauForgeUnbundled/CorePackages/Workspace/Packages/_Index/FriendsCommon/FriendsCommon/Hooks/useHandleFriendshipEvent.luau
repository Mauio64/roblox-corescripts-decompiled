local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/React")

local ApolloFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloFriends")

local queries = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloLocalState").queries

local userIdExists = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SocialCommon").Utils.userIdExists

local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloClient")
local useQuery = ApolloClient.useQuery
local useApolloClient = ApolloClient.useApolloClient

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/RobloxAppHooks").useLocalUserId

local handleFriendshipEvent = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCommon/FriendsCommon/EventHandlers/handleFriendshipEvent")

local fFlagFriendSortedByPresenceSignalsImplementation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SharedFlags").FFlagFriendSortedByPresenceSignalsImplementation

local function useHandleFriendshipEvent()
	local v5 = useLocalUserId()

	local v6 = if not fFlagFriendSortedByPresenceSignalsImplementation then useApolloClient() else nil
	local v7

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v7 = nil
	else
		v7 = useQuery(queries.onlineFriendsByUserId, {
			skip = not userIdExists(v5),
			notifyOnNetworkStatusChange = true,
			variables = { userId = v5, sort = ApolloFriends.Enums.Sort.FriendshipScore }
		})
	end

	local function fn(friendshipUpdate)
		handleFriendshipEvent({
			localUserId = v5,
			onlineFriendsRef = if not fFlagFriendSortedByPresenceSignalsImplementation then v7 else nil,
			apolloClient = if not fFlagFriendSortedByPresenceSignalsImplementation then v6 else nil,
			friendshipUpdate = friendshipUpdate
		})
	end

	return (React.useCallback(fn, {
		if not fFlagFriendSortedByPresenceSignalsImplementation then v7 else nil
	}))
end

return useHandleFriendshipEvent
