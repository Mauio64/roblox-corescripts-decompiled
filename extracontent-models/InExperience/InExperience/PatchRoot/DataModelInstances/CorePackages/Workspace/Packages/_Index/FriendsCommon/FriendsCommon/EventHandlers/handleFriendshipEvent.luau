local parent = script:FindFirstAncestor("FriendsCommon").Parent

local ApolloFriends = require(parent.ApolloFriends)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation

local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()

local function handleFriendshipEvent(data)
	if data.friendshipUpdate.removedUserId then
		if not FFlagFriendSortedByPresenceSignalsImplementation then
			ApolloFriends.Cache.removeFriendFromCache(data.apolloClient, {
				targetUserId = data.localUserId,
				userId = data.friendshipUpdate.removedUserId
			})
			return
		end

		v.UpdateIsFriendsWith(data.friendshipUpdate.removedUserId, false)
		v.UpdateFriendshipStatus(data.friendshipUpdate.removedUserId, Enum.FriendStatus.NotFriend)
	elseif data.friendshipUpdate.addedUserId then
		if FFlagFriendSortedByPresenceSignalsImplementation then
			v.RefetchOnlineFriends()
			v.UpdateIsFriendsWith(data.friendshipUpdate.addedUserId, true)
			v.UpdateFriendshipStatus(data.friendshipUpdate.addedUserId, Enum.FriendStatus.Friend)
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
