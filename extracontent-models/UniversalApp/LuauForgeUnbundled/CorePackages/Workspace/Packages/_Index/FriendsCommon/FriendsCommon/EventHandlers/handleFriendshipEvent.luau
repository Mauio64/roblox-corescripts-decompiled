local ApolloFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/ApolloFriends")

local fFlagFriendSortedByPresenceSignalsImplementation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SharedFlags").FFlagFriendSortedByPresenceSignalsImplementation

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/DataHydration").Friends.FriendsStore.get()

local function handleFriendshipEvent(data)
	if data.friendshipUpdate.removedUserId then
		if not fFlagFriendSortedByPresenceSignalsImplementation then
			ApolloFriends.Cache.removeFriendFromCache(data.apolloClient, {
				targetUserId = data.localUserId,
				userId = data.friendshipUpdate.removedUserId
			})
			return
		end

		v5.UpdateIsFriendsWith(data.friendshipUpdate.removedUserId, false)
		v5.UpdateFriendshipStatus(data.friendshipUpdate.removedUserId, Enum.FriendStatus.NotFriend)
	elseif data.friendshipUpdate.addedUserId then
		if fFlagFriendSortedByPresenceSignalsImplementation then
			v5.RefetchOnlineFriends()
			v5.UpdateIsFriendsWith(data.friendshipUpdate.addedUserId, true)
			v5.UpdateFriendshipStatus(data.friendshipUpdate.addedUserId, Enum.FriendStatus.Friend)
		else
			data.onlineFriendsRef:refetch()
			ApolloFriends.Cache.addFriendToFriendsByUserIdCache(data.apolloClient, {
				targetUserId = data.localUserId,
				userId = data.friendshipUpdate.addedUserId,
				hasVerifiedBadge = nil
			})
		end
	end
end

return handleFriendshipEvent
