local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/React")

local ApolloFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloFriends")

local queries = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloLocalState").queries

local userIdExists = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SocialCommon").Utils.userIdExists

local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloClient")
local useQuery = ApolloClient.useQuery
local useApolloClient = ApolloClient.useApolloClient

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/RobloxAppHooks").useLocalUserId

local handlePresenceEventWithScores = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCommon/FriendsCommon/EventHandlers/handlePresenceEventWithScores")

local function useHandlePresenceEvent()
	local v5 = useLocalUserId()

	local v6 = useApolloClient()

	local v7 = useQuery(queries.onlineFriendsByUserId, {
		skip = not userIdExists(v5),
		notifyOnNetworkStatusChange = true,
		variables = { userId = v5, sort = ApolloFriends.Enums.Sort.FriendshipScore }
	})

	return {
		handleNewEvent = React.useCallback(function(p2, p3, p4)
			handlePresenceEventWithScores({
				localUserId = v5,
				apolloClient = v6,
				onlineFriendsRef = v7,
				updatedPresences = p2,
				updatedSortScores = p3,
				rtnMessageId = p4
			})
		end, { v5, v6, v7 }),
		refetchOnlineFriends = React.useCallback(function()
			return v7.refetch()
		end, { v7 })
	}
end

return useHandlePresenceEvent
