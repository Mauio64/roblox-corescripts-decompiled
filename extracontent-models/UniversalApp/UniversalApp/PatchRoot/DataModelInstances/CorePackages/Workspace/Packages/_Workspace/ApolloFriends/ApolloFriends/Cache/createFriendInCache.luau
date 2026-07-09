local Parent = script:FindFirstAncestor("ApolloFriends").Parent
local gql = require(Parent.ApolloClient).gql

local function createFriendInCache(p1, t1: {[any]: any}) -- line: 13
	-- upvalues: gql (copy)
	return (p1.cache:writeFragment({
		data = {
			__typename = "Friend",
			displayName = "",
			id = t1.userId,
			targetUserId = t1.targetUserId,
			hasVerifiedBadge = t1.hasVerifiedBadge or false
		},
		fragment = gql("\t\t\tfragment NewFriend on Friend {\n\t\t\t\tid\n\t\t\t\ttargetUserId\n\t\t\t\thasVerifiedBadge\n\t\t\t\tdisplayName\n\t\t\t}\n\t\t")
	}))
end

return createFriendInCache
