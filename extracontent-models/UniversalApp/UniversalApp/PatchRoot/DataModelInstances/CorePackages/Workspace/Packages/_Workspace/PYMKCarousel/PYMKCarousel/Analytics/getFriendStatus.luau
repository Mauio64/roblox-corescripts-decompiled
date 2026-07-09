return function(p1, b1: boolean?) -- line: 1
	if b1 then
		return Enum.FriendStatus.FriendRequestReceived
	end

	if p1 then
		return p1
	end

	return Enum.FriendStatus.NotFriend
end
