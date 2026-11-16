local function mapFriendshipStatusToEnum(p: string?)
	if p == "NotFriends" then
		return Enum.FriendStatus.NotFriend
	elseif p == "Friends" then
		return Enum.FriendStatus.Friend
	elseif p == "RequestSent" then
		return Enum.FriendStatus.FriendRequestSent
	elseif p == "RequestReceived" then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return Enum.FriendStatus.Unknown
end

return mapFriendshipStatusToEnum
