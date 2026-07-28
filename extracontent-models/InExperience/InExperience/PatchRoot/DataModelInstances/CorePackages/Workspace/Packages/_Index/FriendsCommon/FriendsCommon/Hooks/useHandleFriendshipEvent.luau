local FriendsCommon = script:FindFirstAncestor("FriendsCommon")
local FriendsCommonParent = FriendsCommon.Parent
local React = require(FriendsCommonParent.React)
local ApolloFriends = require(FriendsCommonParent.ApolloFriends)
local queries = require(FriendsCommonParent.ApolloLocalState).queries
local userIdExists = require(FriendsCommonParent.SocialCommon).Utils.userIdExists
local ApolloClient = require(FriendsCommonParent.ApolloClient)
local useQuery = ApolloClient.useQuery
local useApolloClient = ApolloClient.useApolloClient
local useLocalUserId = require(FriendsCommonParent.RobloxAppHooks).useLocalUserId
local handleFriendshipEvent = require(FriendsCommon.EventHandlers.handleFriendshipEvent)
local FFlagFriendSortedByPresenceSignalsImplementation = require(FriendsCommonParent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation

local function useHandleFriendshipEvent() -- line: 25
	-- upvalues: useLocalUserId (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), useApolloClient (copy), useQuery (copy), queries (copy), userIdExists (copy), ApolloFriends (copy), React (copy), handleFriendshipEvent (copy)
	local v14 = useLocalUserId()
	local v15 = if not FFlagFriendSortedByPresenceSignalsImplementation then useApolloClient() else nil
	local v16 = if not FFlagFriendSortedByPresenceSignalsImplementation then useQuery(queries.onlineFriendsByUserId, {
		notifyOnNetworkStatusChange = true,
		skip = not userIdExists(v14),
		variables = {
			userId = v14,
			sort = ApolloFriends.Enums.Sort.FriendshipScore
		}
	}) else nil

	return (React.useCallback(function(p1) -- line: 41
		-- upvalues: handleFriendshipEvent (copy), v14 (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), v16 (copy), v15 (copy)
		handleFriendshipEvent({
			localUserId = v14,
			onlineFriendsRef = if not FFlagFriendSortedByPresenceSignalsImplementation then v16 else nil,
			apolloClient = if not FFlagFriendSortedByPresenceSignalsImplementation then v15 else nil,
			friendshipUpdate = p1
		})
	end, { if not FFlagFriendSortedByPresenceSignalsImplementation then v16 else nil }))
end

return useHandleFriendshipEvent
