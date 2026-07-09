local CorePackages = game:GetService("CorePackages")
local UserModel = require(CorePackages.Workspace.Packages.UserLib).Models.UserModel

return function(p1, p2) -- line: 4
	-- upvalues: UserModel (copy)
	local FriendCount = p1.FriendCount
	local v6 = p1.FriendPresenceCounts[UserModel.PresenceType.ONLINE] or 0
	local v7 = p1.FriendPresenceCounts[UserModel.PresenceType.IN_GAME] or 0

	p2.EventStream:setRBXEventStream("onlineFriends", "usersFriendsPresenceOnAppStartup", {
		onlineFriendCount = v6 + v7,
		inGameFriendCount = v7,
		totalFriendCount = FriendCount
	})
end
