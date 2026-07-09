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
local handlePresenceEventWithScores = require(FriendsCommon.EventHandlers.handlePresenceEventWithScores)

local function useHandlePresenceEvent() -- line: 38
	-- upvalues: useLocalUserId (copy), useApolloClient (copy), useQuery (copy), queries (copy), userIdExists (copy), ApolloFriends (copy), React (copy), handlePresenceEventWithScores (copy)
	local v13 = useLocalUserId()
	local v14 = useApolloClient()
	local v15 = useQuery(queries.onlineFriendsByUserId, {
		notifyOnNetworkStatusChange = true,
		skip = not userIdExists(v13),
		variables = {
			userId = v13,
			sort = ApolloFriends.Enums.Sort.FriendshipScore
		}
	})
	local v16 = React.useCallback(function(p1, p2, p3) -- line: 52
		-- upvalues: handlePresenceEventWithScores (copy), v13 (copy), v14 (copy), v15 (copy)
		handlePresenceEventWithScores({
			localUserId = v13,
			apolloClient = v14,
			onlineFriendsRef = v15,
			updatedPresences = p1,
			updatedSortScores = p2,
			rtnMessageId = p3
		})
	end, {
		v13,
		v14,
		v15
	})
	local v17 = React.useCallback(function() -- line: 63
		-- upvalues: v15 (copy)
		return v15.refetch()
	end, { v15 })

	return {
		handleNewEvent = v16,
		refetchOnlineFriends = v17
	}
end

return useHandlePresenceEvent
