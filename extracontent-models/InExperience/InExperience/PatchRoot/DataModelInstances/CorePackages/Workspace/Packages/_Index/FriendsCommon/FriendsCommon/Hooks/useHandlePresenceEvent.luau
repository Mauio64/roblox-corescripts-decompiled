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

local handlePresenceEventWithScores = require(FriendsCommon.EventHandlers.handlePresenceEventWithScores)

local function useHandlePresenceEvent()
	local v = useLocalUserId()

	local apolloClient = useApolloClient()

	local onlineFriendsRef = useQuery(queries.onlineFriendsByUserId, {
		skip = not userIdExists(v),
		notifyOnNetworkStatusChange = true,
		variables = { userId = v, sort = ApolloFriends.Enums.Sort.FriendshipScore }
	})

	return {
		handleNewEvent = React.useCallback(function(updatedPresences, updatedSortScores, rtnMessageId)
			handlePresenceEventWithScores({
				localUserId = v,
				apolloClient = apolloClient,
				onlineFriendsRef = onlineFriendsRef,
				updatedPresences = updatedPresences,
				updatedSortScores = updatedSortScores,
				rtnMessageId = rtnMessageId
			})
		end, { v, apolloClient, onlineFriendsRef }),
		refetchOnlineFriends = React.useCallback(function()
			return onlineFriendsRef.refetch()
		end, { onlineFriendsRef })
	}
end

return useHandlePresenceEvent
