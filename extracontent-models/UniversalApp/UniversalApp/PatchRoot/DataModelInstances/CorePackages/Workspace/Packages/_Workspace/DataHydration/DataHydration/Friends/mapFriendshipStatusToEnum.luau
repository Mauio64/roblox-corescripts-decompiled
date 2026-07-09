local function mapFriendshipStatusToEnum(s1: string?) -- line: 1
	if s1 == "NotFriends" then
		return Enum.FriendStatus.NotFriend
	end

	if s1 == "Friends" then
		return Enum.FriendStatus.Friend
	end

	if s1 == "RequestSent" then
		return Enum.FriendStatus.FriendRequestSent
	end

	if s1 == "RequestReceived" then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return Enum.FriendStatus.Unknown
end

return mapFriendshipStatusToEnum
