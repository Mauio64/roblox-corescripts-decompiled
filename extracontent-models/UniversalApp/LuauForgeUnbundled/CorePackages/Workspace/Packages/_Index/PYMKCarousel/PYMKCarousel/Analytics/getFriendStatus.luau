return function(p2, p3)
	if p3 then
		return Enum.FriendStatus.FriendRequestReceived
	end

	if p2 then
		return p2
	end

	return Enum.FriendStatus.NotFriend
end
