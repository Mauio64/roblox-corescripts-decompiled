local parent = script:FindFirstAncestor("ApolloFriends").Parent

local ApolloClient = require(parent.ApolloClient)
local gql = ApolloClient.gql

local function createFriendInCache(p, data)
	return (p.cache:writeFragment({
		data = {
			__typename = "Friend",
			id = data.userId,
			targetUserId = data.targetUserId,
			hasVerifiedBadge = data.hasVerifiedBadge or false,
			displayName = ""
		},
		fragment = gql([[
			fragment NewFriend on Friend {
				id
				targetUserId
				hasVerifiedBadge
				displayName
			}
		]])
	}))
end

return createFriendInCache
