local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local friendStatuses = dependencies.SocialLuaAnalytics.Analytics.Enums.FriendStatuses
require(parent.Common.LocalTypes)

return function(data)
	if data.isFriendWithUser then
		return friendStatuses.Friends
	end

	if data.hasPendingFriendRequest then
		return friendStatuses.RequestSent
	end

	if data.hasIncomingFriendRequest then
		return friendStatuses.RequestReceived
	end

	return friendStatuses.NotFriends
end
