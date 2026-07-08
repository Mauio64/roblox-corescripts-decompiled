local ParentParent = script.Parent.Parent
local FriendStatuses = require(ParentParent.dependencies).SocialLuaAnalytics.Analytics.Enums.FriendStatuses

require(ParentParent.Common.LocalTypes)

return function(p1) -- line: 9
	-- upvalues: FriendStatuses (copy)
	if p1.isFriendWithUser then
		return FriendStatuses.Friends
	end

	if p1.hasPendingFriendRequest then
		return FriendStatuses.RequestSent
	end

	if p1.hasIncomingFriendRequest then
		return FriendStatuses.RequestReceived
	end

	return FriendStatuses.NotFriends
end
