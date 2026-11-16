local gql = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloFriends/ApolloClient").gql

local function createFriendInCache(p2, data)
	return (p2.cache:writeFragment({
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
