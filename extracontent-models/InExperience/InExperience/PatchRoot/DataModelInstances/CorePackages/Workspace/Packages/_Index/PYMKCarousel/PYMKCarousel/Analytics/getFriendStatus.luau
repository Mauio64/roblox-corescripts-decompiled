return function(p, flag: boolean?)
	if flag then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return p or Enum.FriendStatus.NotFriend
end
