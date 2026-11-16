local function mapFriendshipStatusToEnum(p2)
	if p2 == "NotFriends" then
		return Enum.FriendStatus.NotFriend
	elseif p2 == "Friends" then
		return Enum.FriendStatus.Friend
	elseif p2 == "RequestSent" then
		return Enum.FriendStatus.FriendRequestSent
	elseif p2 == "RequestReceived" then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return Enum.FriendStatus.Unknown
end

return mapFriendshipStatusToEnum
