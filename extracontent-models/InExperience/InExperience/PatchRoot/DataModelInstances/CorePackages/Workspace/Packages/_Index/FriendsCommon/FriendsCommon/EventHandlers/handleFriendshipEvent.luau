local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local ApolloFriends = require(Parent.ApolloFriends)
local FFlagFriendSortedByPresenceSignalsImplementation = require(Parent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation
local DataHydration = require(Parent.DataHydration)
local v5 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Friends.FriendsStore.get()

local function handleFriendshipEvent(t1: {[any]: any}) -- line: 21
	-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), v5 (copy), ApolloFriends (copy)
	if t1.friendshipUpdate.removedUserId then
		if FFlagFriendSortedByPresenceSignalsImplementation then
			v5.UpdateIsFriendsWith(t1.friendshipUpdate.removedUserId, false)

			return
		end

		ApolloFriends.Cache.removeFriendFromCache(t1.apolloClient, {
			targetUserId = t1.localUserId,
			userId = t1.friendshipUpdate.removedUserId
		})

		return
	end

	if t1.friendshipUpdate.addedUserId then
		if FFlagFriendSortedByPresenceSignalsImplementation then
			v5.RefetchOnlineFriends()
			v5.UpdateIsFriendsWith(t1.friendshipUpdate.addedUserId, true)

			return
		end

		t1.onlineFriendsRef:refetch()
		ApolloFriends.Cache.addFriendToFriendsByUserIdCache(t1.apolloClient, {
			hasVerifiedBadge = nil,
			targetUserId = t1.localUserId,
			userId = t1.friendshipUpdate.addedUserId
		})
	end
end

return handleFriendshipEvent
